#ifndef _ASM_CPU_H_
#define _ASM_CPU_H_

extern void cpu_hlt(void);
extern void write_memb(int addr, int val);
extern void cpu_irq_disable(void);
extern void cpu_irq_enable(void);
extern void outb(unsigned int port, unsigned char val);
extern int inb(int port);
extern void load_gdtr(int limit, int addr);
extern void load_idtr(int limit, int addr);

extern int load_cr0(void);
extern void store_cr0(int cr0);

extern unsigned int io_load_eflags(void);
extern void io_store_eflags(unsigned int eflg);

void asm_irq_handler1(void);
void asm_irq_handler7(void);
void asm_irq_handler12(void);

extern void io_cli(void);
extern void io_sti(void);
extern void io_stihlt(void);
#endif
