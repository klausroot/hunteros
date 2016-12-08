#ifndef _FIFO_H_
#define _FIFO_H_
#include <hunter/list.h>

#define FIFO_BYTE_NUM	64
#define FIFO_WORD_NUM	FIFO_BYTE_NUM / 2
#define FIFO_DWORD_NUM	FIFO_BYTE_NUM / 4
struct st_fifo{
	char *fname;
	int next;
	union{
		char b_data[FIFO_BYTE_NUM];
		short w_data[FIFO_WORD_NUM];
		int dw_data[FIFO_DWORD_NUM];
	};
	struct list_head entry;

};

void put_bdata_fifo(char data, char *name);

void put_wdata_fifo(short data, char *name);

void put_dwdata_fifo(int data, char *name);

int register_fifo(struct st_fifo *);

#endif
