#include "mm.h"
#include "hunter/list.h"

#define MEMMAN_ERROR_DEBUG 	1
#define MEMMAN_ALIGN_SIZE 	32

#define ALIGN(s, align) \
	({\
		int m = (unsigned int)(s) & ((align) - 1); \
		int ret = (unsigned int)(s) + (m ? ((align) - m) : 0); \
		ret; \
	})

#define ALIGN_OFFSET(s, align) \
	({\
		int m = (unsigned int)(s) & ((align) - 1);\
		m ? (s - m) : 0;\
	})

#define MEMMAN_ALIGN(x) ALIGN(x, MEMMAN_ALIGN_SIZE)

#define MEM_OFFSET	ALIGN_OFFSET(sizeof(struct mem), MEMMAN_ALIGN_SIZE)

#define __mm_rw_lock()
#define __mm_rw_unlock()

#define __mem_position(buf) \
	(struct mem *)((unsigned int)buf - sizeof(struct mem))

/*
 * ϵͳ�ڴ����ģ��
 */
struct mem_manager {
#if MEMMAN_ERROR_DEBUG
	int protect_s;
#endif
	unsigned int addr;//��ʼ��ַ
	unsigned int size;//����
	unsigned int unused;//δʹ�ÿռ��ܺ�
	unsigned int used;	//��ʹ�ÿռ��ܺ�
	struct list_head lused;//��ռ���б�
	struct list_head lfree;//δռ���б�
};

struct mem_free {//�����ڴ�ṹ
	struct list_head entry;
	unsigned int len;
};

struct mem {
#if MEMMAN_ERROR_DEBUG
	int protect_s;
#endif
	struct list_head entry;
	unsigned int size;
#if MEMMAN_ERROR_DEBUG
	int protect_e;
#endif
};

struct mem_manager *mm_head = NULL;
/*
 * ϵͳ�ڴ�����ʼ��
 *
 * ʹ���������ʽ
 */
void mm_init(unsigned int addr, unsigned int size)
{
	int offset = 0;
	struct mem_free *mfree;

	mm_head = (struct mem_manager *)ALIGN(addr, 4);

	offset = MEMMAN_ALIGN(mm_head + 1) - (unsigned int)mm_head;

#if MEMMAN_ERROR_DEBUG
	mm_head->protect_s = 0x12345678;
#endif
	mm_head->addr = addr;
	mm_head->size = size;
	mm_head->unused = mm_head->size - offset;
//	mm_head->used = 0;
//	INIT_LIST_HEAD(&mm_head->lused);
	INIT_LIST_HEAD(&mm_head->lfree);

	/*��ӵ�һ�������ڴ�*/
	mfree = (struct mem_free *)(mm_head->addr + offset);
	mfree->len = mm_head->unused;
	list_add_tail(&mfree->entry, &mm_head->lfree);
}

int mm_space_add(unsigned int addr, unsigned int size)
{
	struct mem_free *new_free;
	struct mem_free *mfree;

	new_free = (struct mem_free *)addr;
	new_free->len = size;

	__mm_rw_lock();

	list_for_each_entry(mfree, &mm_head->lfree, entry) {
		if ((unsigned int)mfree <= (unsigned int)new_free &&
			(unsigned int)mfree + mfree->len > (unsigned int)new_free) {
			/*
			 * �����е�free��ĵ�ַ�г�ͻ
			 */
			goto __exit;
		}

		if ((unsigned int)mfree > (unsigned int)new_free) {
			break;
		}
	}

	if (mfree > new_free) {
		__list_add(&new_free->entry, mfree->entry.prev, &mfree->entry);
	} else {
		list_add_tail(&new_free->entry, &mm_head->lfree);
	}

	mm_head->size += size;
	mm_head->unused += size;
__exit:
	__mm_rw_unlock();
	return 0;
}

unsigned int mm_total(void)
{
	if (!mm_head) {
		return 0;
	}
	return mm_head->unused;
}

int lmstate(void)
{
	return 0;
}

/*
 * malloc ����
 * ����ƥ������size��free�б��ҵ����ʳ��Ƚ������´���
 *
 */
void *lmalloc(size_t size)
{
	int offset;
	struct mem_free *mfree;
	struct mem_free *new_free;
	struct mem *new_mem;
	void *ret = NULL;


	offset = MEM_OFFSET;
	size = MEMMAN_ALIGN(sizeof(struct mem) + offset + size);
	__mm_rw_lock();

	list_for_each_entry(mfree, &mm_head->lfree, entry) {
		if (mfree->len < size) {
			continue;
		}
	}

	if (mfree) {
		if (mfree->len > size + sizeof(struct mem_free)) {
			new_free = (struct mem_free *)((unsigned int)mfree + size);
			new_free->len = mfree->len - size;
			__list_add(&new_free->entry, mfree->entry.prev, mfree->entry.next);
		} else {
			size = mfree->len;
			__list_del_entry(&mfree->entry);
		}

		new_mem = (struct mem *)((unsigned int)mfree + offset);
		new_mem->size = size;
#if MEMMAN_ERROR_DEBUG
		new_mem->protect_s = 0x55AA55AA;
		new_mem->protect_e = 0xAA55AA55;
#endif
		INIT_LIST_HEAD(&new_mem->entry);
		ret = new_mem + 1;
		mm_head->unused -= size;
	}

	__mm_rw_unlock();
	return ret;
}

/*
 * realloc ����
 *
 */
void *lrealloc(void *addr, size_t size)
{
	int offset;
	struct mem *lmem;
	struct mem *r_lmem;

	lmem = __mem_position(addr);
	offset = MEM_OFFSET;
	size = MEMMAN_ALIGN(sizeof(struct mem) + offset + size);

	if (lmem->size < size) {
		lfree(addr);
		return lmalloc(size);
	}

	if (lmem->size - size < 2 * (sizeof(struct mem) + offset)) {
		return addr;
	}

	r_lmem = (struct mem *)((unsigned int)lmem + size);
	r_lmem->size = size - lmem->size;
#if MEMMAN_ERROR_DEBUG
	r_lmem->protect_s = 0x55AA55AA;
	r_lmem->protect_e = 0xAA55AA55;
#endif
	INIT_LIST_HEAD(&r_lmem->entry);
	lfree(r_lmem + 1);

	lmem->size = size;

	return addr;
}

void *lzalloc(size_t size)
{
	void *mem;

	mem = lmalloc(size);
	if (mem) {
//		memset(mem, 0x0, size);
	}

	return mem;
}

void lfree(void *addr)
{
	struct mem *lmem;
	struct mem_free *new_free;
	struct mem_free *mfree;
	struct mem_free *prev, *next;
	int offset = 0;

	lmem = __mem_position(addr);
	offset = MEM_OFFSET;
	new_free = (struct mem_free *)((unsigned int)lmem - offset);

	new_free->len = lmem->size;
	__mm_rw_lock();

	list_for_each_entry(mfree, &mm_head->lfree, entry) {
		if (mfree <= new_free && (unsigned int)mfree + mfree->len > (unsigned int)new_free) {
			/**free �����г��ִ�������**/
			goto __exit;
		}

		if (mfree > new_free) {
			__list_add(&new_free->entry, mfree->entry.prev, mfree->entry.next);
			goto __free;
		}
	}

	list_add_tail(&new_free->entry, &mm_head->lfree);

__free:

	prev = list_entry(new_free->entry.prev, struct mem_free, entry);
	next = list_entry(new_free->entry.next, struct mem_free, entry);

	if ((unsigned int)prev + prev->len == (unsigned int)new_free) {
		prev->len += new_free->len;
		__list_del_entry(&new_free->entry);
	}

	if ((unsigned int)new_free + new_free->len == (unsigned int)next) {
		new_free->len += next->len;
		__list_del_entry(&next->entry);
	}
	mm_head->unused += new_free->len;

__exit:
	__mm_rw_unlock();

}
