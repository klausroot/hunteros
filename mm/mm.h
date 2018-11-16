#ifndef _MEMORY_MANAGER_H_
#define _MEMORY_MANAGER_H_

#include "stddef.h"

void mm_init(unsigned int addr, unsigned int size);
int mm_space_add(unsigned int addr, unsigned int size);
unsigned int mm_total(void);
void *lmalloc(size_t size);
void *lrealloc(void *addr, size_t size);
void *lzalloc(size_t size);
void lfree(void *addr);
int lmstate(void);

#endif
