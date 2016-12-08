#include "irq.h"
#include "asm/cpu.h"
#include "graphics.h"


void init_pic(void)
{
    outb(PIC0_IMR, 0xff); //禁止PIC0所有中断
    outb(PIC1_IMR, 0xff); //

    outb(PIC0_ICW1, 0x11); //边沿触发模式 (edge trigger mode)
    outb(PIC0_ICW2, 0x20); //IRQ0-7由INT20-27接收
    outb(PIC0_ICW3, 1 << 2); //PIC1由IRQ2连接
    outb(PIC0_ICW4, 0x01); //无缓冲区模式

    outb(PIC1_ICW1, 0x11); //边沿触发模式
    outb(PIC1_ICW2, 0x28); //IRQ8-15由INT28-2f接收
    outb(PIC1_ICW3, 2   ); //PIC1由IRQ2连接
    outb(PIC1_ICW4, 0x01); //无缓冲区模式

    outb(PIC0_IMR, 0xfb); // 11111011 PIC1以外全部禁止
    outb(PIC1_IMR, 0xff); // 11111111 禁止所有中断

    io_sti();

} 

struct key_buf{

};

#define PORT_KEYDAT		0x0060
void irq_handler1(int *esp)
{
	unsigned char data, s[4];
	outb(PIC0_OCW2, 0x61); //通知PIC IRQ-01已经受理完毕

	data = inb(PORT_KEYDAT);
//	sprintf(s, "%02x", data);
//    box_fill(COLOR_BLACK, 0, 0, 32 * 8 - 1, 15);
//    draw_ascii_font8(0, 16, COLOR_WHITE, s);
	put_bdata_fifo(data, "keyboard");
    //draw_ascii_font8(0, 0, COLOR_WHITE, "INT 21 (IRQ-1) : PS/2 keyboard");
}

void irq_handler12(int *esp)
{
    box_fill(COLOR_BLACK, 0, 0, 32 * 8 - 1, 15);
    draw_ascii_font8(0, 0, COLOR_WHITE, "INT 2C (IRQ-12) : PS/2 mouse");
}

/*************************************************
 *PIC0中断的不完整策略
 *这个中断在Athlon64X2上通过芯片组提供的便利，只需要执行一次
 *这个中断只是接收，不执行任何操作
 *
 * 为什么不处理？ ——>因为这个中断可能是电气噪声引发的、
 *                  只是处理一些重要的情况。
 *:wq
 * ***********************************************/
void irq_handler7(int *esp)
{
	outb(PIC0_OCW2, 0x67); //通知PIC的IRQ-07(参考7-1)
}
