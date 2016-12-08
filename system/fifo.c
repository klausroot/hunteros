#include "system/fifo.h"
#include "string.h"
static struct list_head fifo_head = {&fifo_head, &fifo_head};//INIT_LIST_HEAD(&fifo_head);

void put_bdata_fifo(char data, char *name)
{
	struct st_fifo *fifo;

	list_for_each_entry(fifo, &fifo_head, entry){
		if (strcmp(fifo->fname, name)){
			if (fifo->next < FIFO_BYTE_NUM){
				fifo->b_data[fifo->next] = data;
				fifo->next++;
			}
		}
	}
}

char get_bdata_fifo(char *name)
{
	struct st_fifo *fifo;
	int i;
	char data = 0;

	list_for_each_entry(fifo, &fifo_head, entry){
		if (strcmp(fifo->fname, name)){
			data = fifo->b_data[0];
			for (i = 0; i < fifo->next; i++){
				fifo->b_data[i] = fifo->b_data[i+1];
			}
			fifo->next--;
		}
	}
	return data;
}

void put_wdata_fifo(short data, char *name)
{

}

void put_dwdata_fifo(int data, char *name)
{

}

int fifo_status(char *name)
{
	struct st_fifo *fifo;

	list_for_each_entry(fifo, &fifo_head, entry){
		if (strcmp(fifo->fname, name)){
			if (fifo->next < FIFO_BYTE_NUM){
				return fifo->next;
			}
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
		fifo->next = 0;
		list_add(&fifo->entry, &reg_fifo->entry);
		return 0;
	}
	return -1;
}
