#ifndef _SHEET_H_
#define _SHEET_H_
#include <hunter/list.h>

struct sheet {
	unsigned char *buf;
	int bwidth;
	int bheight;
	int vx0;
	int vy0;
	int height; //以图层为单位
	int flag;
	int color;
	struct list_head entry;
	void *parent;
};

void *sheet_ctrl_init(unsigned char *vram, int xsize, int ysize);
struct sheet *new_sheet(void);
void free_sheet(struct sheet *sht);
void sheet_refresh(struct sheet *sht);
void sheet_slide(struct sheet *sht, int vx0, int vy0);
int sheet_switch(struct sheet *sht, int height);
int sheet_setbuf(struct sheet *sht, void *buf, int xsize, int ysize, int color);
#endif
