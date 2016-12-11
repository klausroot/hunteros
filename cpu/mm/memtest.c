#include "asm/cpu.h"
#define EFLAG_AC_BIT		0x00040000
#define CR0_CACHE_DISABLE 	0x60000000

#define MEM_TEST_U32		0xaa55aa55
#define MEM_TEST_U32_REVRSE	0x55aa55aa

unsigned int mem_test_sub(unsigned int start, unsigned int end)
{
	unsigned int addr;
	unsigned int *ptr;
	unsigned int save_data;

	for (addr = start; addr <= end; addr+= 4){
		ptr = (unsigned int *)addr;
		save_data = *ptr;
		*ptr = MEM_TEST_U32; //试写
		*ptr ^= 0xffffffff; //反转
		if (*ptr != MEM_TEST_U32_REVRSE){
			*ptr = save_data;
			goto _bad_mem;
		}
		*ptr ^= 0xffffffff; //再次反转
		if (*ptr != MEM_TEST_U32){
			*ptr = save_data;
			goto _bad_mem;
		}
		*ptr = save_data;
	}

	return addr;
_bad_mem:

	return addr;
}

unsigned int mem_test(unsigned int start, unsigned int end)
{
	unsigned char flg486 = 0;
	unsigned int eflg, cr0;
	unsigned int ret = 0;

	//判断CPU是386还是486以上的
	eflg = io_load_eflags();
	eflg |= EFLAG_AC_BIT; //AC-bit = 1
	io_store_eflags(eflg);
	eflg = io_load_eflags();
	if (eflg & EFLAG_AC_BIT){ //如果是386，设定AC=1,AC的值还是会自动回到0
		flg486 = 1;
	}

	eflg &= ~EFLAG_AC_BIT; //AC-bit = 0
	io_store_eflags(eflg);

	if (flg486){
		cr0 = load_cr0();
		cr0 |= CR0_CACHE_DISABLE; //禁止cache
		store_cr0(cr0);
	}

	ret = mem_test_sub(start, end);

	if (flg486){
		cr0 = load_cr0();
		cr0 &= CR0_CACHE_DISABLE;//打开cache
		store_cr0(cr0);
	}
	return ret;
}
