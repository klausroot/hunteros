#ifndef _FIFO_H_
#define _FIFO_H_
#include <hunter/list.h>

#define FIFO_BYTE_NUM	128
#define FIFO_WORD_NUM	FIFO_BYTE_NUM / 2
#define FIFO_DWORD_NUM	FIFO_BYTE_NUM / 4
struct st_fifo{
	char *fname;
	int next_r, next_w;
	int size, free;
	unsigned int flag;
	union{
		unsigned char b_data[FIFO_BYTE_NUM];
		//short w_data[FIFO_WORD_NUM];
		//int dw_data[FIFO_DWORD_NUM];
	};
	struct list_head entry;

};

int put_bdata_fifo(unsigned char data, char *name);
int get_bdata_fifo(char *name);


int register_fifo(struct st_fifo *, char *name);

int fifo_status(char *name);
#endif
