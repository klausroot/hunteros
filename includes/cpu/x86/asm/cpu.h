#ifndef _ASM_CPU_H_
#define _ASM_CPU_H_

void cpu_hlt(void);
void write_memb(int addr, int val);
void cpu_irq_disable(void);
void cpu_irq_enable(void);
void outb(unsigned int port, unsigned char val);
int inb(int port);
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);

void asm_irq_handler1(void);
void asm_irq_handler7(void);
void asm_irq_handler12(void);

extern void io_cli(void);
extern void io_sti(void);
extern void io_stihlt(void);
#endif
