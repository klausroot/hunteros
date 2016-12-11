#include "circuit_ctl.h"
#include "irq.h"
#include "mouse.h"
#include "graphics.h"

#define KEYCMD_SENDTO_MOUSE		0xd4
#define MOUSECMD_ENABLE			0xf4

struct mouse_dec_info{
	unsigned char buf[3];
	unsigned char phase;
};

static struct mouse_dec_info mouse_dec;

void init_mouse(void)
{
	/* 激活鼠标 */
	wait_KBC_sendready();
	outb(PORT_KEYCMD, KEYCMD_SENDTO_MOUSE);
	wait_KBC_sendready();
	outb(PORT_KEYDAT, MOUSECMD_ENABLE);

	mouse_dec.phase = 0;
	return; /* 顺利的话，键盘控制器会返回ACK(0xfa) */
}

int mouse_decode(struct mouse_pos *mpos, unsigned char data)
{
	//char var[32];
	if (mouse_dec.phase == 0){
		if (data == 0xfa){
			mouse_dec.phase = 1;//设为鼠标第一个字段读取
			return 0;
		}
	} else {
		mouse_dec.buf[mouse_dec.phase - 1] = data;
		//设置读取下一个字段
		if (mouse_dec.phase >= 3){
			mouse_dec.phase = 1;
			if (mpos){
				mpos->btn = mouse_dec.buf[0] & 0x7;
				mpos->x = mouse_dec.buf[1];
				mpos->y = mouse_dec.buf[2];

				if (mouse_dec.buf[0] & 0x10){
					mpos->x |= 0xffffff00;
				}
				if (mouse_dec.buf[0] & 0x20){
					mpos->y |= 0xffffff00;
				}
				mpos->y = 0 - mpos->y;//鼠标y方向与画面的符号相反
				return 1;
			}
		} else {
			mouse_dec.phase++;
		}
		return 0;
	}
	return 0;
}
