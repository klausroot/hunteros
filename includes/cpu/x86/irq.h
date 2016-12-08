#ifndef _CPU_IRQ_H_
#define _CPU_IRQ_H_

#define PIC0_ICW1   0x0020 // initial control word
#define PIC0_OCW2   0x0020
#define PIC0_IMR    0x0021 // interrupt mask register
#define PIC0_ICW2   0x0021
#define PIC0_ICW3   0x0021
#define PIC0_ICW4   0x0021
#define PIC1_ICW1   0x00a0
#define PIC1_OCW2   0x00a0
#define PIC1_IMR    0x00a1
#define PIC1_ICW2   0x00a1
#define PIC1_ICW3   0x00a1
#define PIC1_ICW4   0x00a1

void init_pic(void);

#endif
