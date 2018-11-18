#include "sheet.h"
#include "mm.h"

#define MAX_SHEETS 		256

#define SHEET_INUSED 	0x1

struct sheet_manager {
	unsigned char *vram; //��ʾ��ַ
	int xsize;
	int ysize;
	int top; //ͼ��ĸ߶�(�ǻ���߶ȣ�����ͼ���ڵĲ�����
	struct list_head head;
	struct sheet sht_table[MAX_SHEETS];
};

static struct sheet_manager *sheet_manager = NULL;

void *sheet_ctrl_init(unsigned char *vram, int xsize, int ysize)
{
	struct sheet_manager *sm;
	int i = 0;

	if (sheet_manager) {
		return sheet_manager;
	}

	sm = lmalloc(sizeof(struct sheet_manager));
	if (!sm) {
		return NULL;
	}

	sm->vram = vram;
	sm->xsize = xsize;
	sm->ysize = ysize;
	sm->top = -1;
	for (i = 0; i < MAX_SHEETS; i++) {
		sm->sht_table[i].flag = 0;
		sm->sht_table[i].buf = NULL;
	}

	INIT_LIST_HEAD(&sm->head);

	sheet_manager = sm;
	return sm;
}

struct sheet *new_sheet(void)
{
	struct sheet_manager *sm = sheet_manager;
	struct sheet *new;
	int i = 0;

	for (i = 0; i < MAX_SHEETS; i++) {
		if (sm->sht_table[i].flag & SHEET_INUSED) {
			continue;
		}
		new = &sm->sht_table[i];
		new->flag |= SHEET_INUSED;
		new->height = -1;
		new->parent = sm;
		return new;
	}

	return NULL;
}

int sheet_setbuf(struct sheet *sht, void *buf, int xsize, int ysize, int color)
{
	sht->buf = buf;
	sht->color = color;
	sht->bwidth = xsize;
	sht->bheight = ysize;

	return 0;
}



static void __sheet_refresh(struct sheet *sht, int vx0, int vy0, int vx1, int vy1)
{
	struct sheet_manager *sm = (struct sheet_manager *)sht->parent;
	struct sheet *p;
	unsigned char *buf;
	unsigned char *vram = sm->vram;
	unsigned char c = 0;
	int bx, by, vx, vy, bx0, by0, bx1, by1;

	if (!sht || !sm) {
		return;
	}
	/* ֻˢ��ͼ������Ӧ����
	|--------------------------------------------|
	|											 |
	|											 |
	|			(vx0,vy0)						 |
	|				|-----------|				 |
	|				|			|				 |
	|				|			|				 |
	|				|-----------|				 |
	|						(vx1,vy1)			 |
	|											 |
	|											 |
	|--------------------------------------------|
	*/
	list_for_each_entry(p, &sm->head, entry) {/*ֻˢ�¶�Ӧ*/
		buf = p->buf;
		if (!buf) {
			continue;
		}
		bx0 = vx0 - p->vx0;
		by0 = vy0 - p->vy0;
		bx1 = vx1 - p->vx0;
		by1 = vy1 - p->vy0;

		if (bx0 < 0) bx0 = 0;
		if (by0 < 0) by0 = 0;
		if (bx1 > p->bwidth) bx1 = p->bwidth;
		if (by1 > p->bheight) by1 = p->bheight;

		for (by = by0; by < by1; by++) {
			vy = p->vy0 + by;
			for (bx = bx0; bx < bx1; bx++) {
				vx = p->vx0 + bx;
				c = buf[vy * p->bwidth + vx];
				if (c != p->color) {
					vram[vy * sm->xsize + vx] = c;
				}
			}
		}
	}
}

void sheet_refresh(struct sheet *sht, int bx0, int by0, int bx1, int by1)
{
	if (sht->height >= 0) {
		__sheet_refresh(sht, sht->vx0 + bx0, sht->vy0 + by0, sht->vx0 + bx1, sht->vy0 + by1);
	}
}

void sheet_slide(struct sheet *sht, int vx0, int vy0)
{
	int old_vx0, old_vy0;

	if (!sht) {
		return;
	}

	old_vx0 = sht->vx0;
	old_vy0 = sht->vy0;

	sht->vx0 = vx0;
	sht->vy0 = vy0;
	if (sht->height >= 0) {
		__sheet_refresh(sht, old_vx0, old_vy0, old_vx0 + sht->bwidth, old_vy0 + sht->bheight);
		__sheet_refresh(sht, vx0, vy0, vx0 + sht->bwidth, vy0 + sht->bheight);
	}
}

/*
 * ͼ�������л�
 */
int sheet_switch(struct sheet *sht, int height)
{
	struct sheet_manager *sm = (struct sheet_manager *)sht->parent;
	int old_h = -1;
	struct sheet *p;
	struct sheet *next = NULL;
	int up, down;

	if (!sht || !sm) {
		return -1;
	}

	old_h = sht->height;

	if (old_h != -1 && height == old_h) {/*�����ǰ��ͼ��λ������*/
		return 0;
	}

	up = (height > old_h) ? 1 : 0;
	down = (height < old_h) ? 1 : 0;

	/*��ɾ����ͼ��*/
	if (old_h != -1) {
		__list_del_entry(&sht->entry);
		sm->top--;
	}

	/*��������/���� ���Ҷ�Ӧ����λ�ã�������ǰ���ͼ��߶�*/
	list_for_each_entry(p, &sm->head, entry) {
		if (!next && p->height >= height) {
			next = p;
		}

		if (up && p->height >= height) {
			p->height++;
		}

		if (down && (p->height >= height && p->height < old_h)) {
			p->height++;
		}
	}

	sht->height = height;
	if (height != -1) {
		if (next) {
			__list_add(&sht->entry, next->entry.prev, &next->entry);
		} else {
			list_add_tail(&sm->head, &sht->entry);
		}
		sm->top++;
	}

	sheet_refresh(sht, sht->vx0, sht->vy0, sht->bwidth, sht->bheight);
	return 0;
}



void free_sheet(struct sheet *sht)
{
	/*
	 * �����غ���ձ�־
	 */
	sheet_switch(sht, -1);//�е����²�����

	sht->flag &= ~SHEET_INUSED;
	sht->buf = NULL;
}
