#include "system/fifo.h"
#include "string.h"
static struct list_head fifo_head = {.next = &fifo_head, .prev = &fifo_head};//INIT_LIST_HEAD(&fifo_head);

#define FLAGS_OVERRUN  0x0001

int put_bdata_fifo(unsigned char data, char *name)
{
	struct st_fifo *fifo;

	list_for_each_entry(fifo, &fifo_head, entry){
		if (strcmp(fifo->fname, name) == 0){
			if (!fifo->free){
				//没有空间 ，溢出
				fifo->flag |= FLAGS_OVERRUN;
				return -1;
			}
			fifo->b_data[fifo->next_w] = data;
			fifo->next_w++;
			if (fifo->next_w >= fifo->size){
				fifo->next_w = 0;
			}
			fifo->free--;
			return 0;
		}
	}
	return -2;
}

int get_bdata_fifo(char *name)
{
	struct st_fifo *fifo;
	int data = 0;

	list_for_each_entry(fifo, &fifo_head, entry){
		if (strcmp(fifo->fname, name) == 0){

			if (fifo->free == fifo->size){
				//缓冲区为空
				return -1;
			}
			data = fifo->b_data[fifo->next_r];
			fifo->next_r++;
			if (fifo->next_r >= fifo->size){
				fifo->next_r = 0;
			}
			fifo->free++;
			return data;
		}
	}
	return -1;
}

int fifo_status(char *name)
{
	struct st_fifo *fifo;

	list_for_each_entry(fifo, &fifo_head, entry){
		if (strcmp(fifo->fname, name) == 0){
			return (fifo->size - fifo->free);
		}
	}
	return 0;
}

int register_fifo(struct st_fifo *fifo, char *name)
{
	struct st_fifo *reg_fifo;
	if (fifo){
		list_for_each_entry(reg_fifo, &fifo_head, entry){
			if (strcmp(reg_fifo->fname, name) == 0){
				return 0;
			}
		}
		fifo->fname = name;
		fifo->size = sizeof(fifo->b_data);
		fifo->next_w = 0;
		fifo->next_r = 0;
		fifo->flag = 0;
		list_add(&fifo->entry, &fifo_head);
		return 0;
	}
	return -1;
}
