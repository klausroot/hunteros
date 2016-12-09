#include "irq.h"
#include "circuit_ctl.h"
#include "keyboard.h"

void irq_handler_keyboard(int *esp)
{
    //box_fill(COLOR_BLACK, 0, 0, 32 * 8 - 1, 15);
    //draw_ascii_font8(0, 0, COLOR_WHITE, "INT 21 (IRQ-1) : PS/2 keyboard");
}


#define KEYSTA_SEND_NOTREADY	0x02
#define KEYCMD_WRITE_MODE		0x60
#define KBC_MODE				0x47

void wait_KBC_sendready(void)
{
	/* 等待键盘控制电路准备完毕 */
	for (;;) {
		if ((inb(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0) {
			break;
		}
	}
	return;
}

void init_keyboard(void)
{
	/* 初始化键盘控制电路 */
	wait_KBC_sendready();
	outb(PORT_KEYCMD, KEYCMD_WRITE_MODE);
	wait_KBC_sendready();
	outb(PORT_KEYDAT, KBC_MODE);
	return;
}
