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
	/* ������� */
	wait_KBC_sendready();
	outb(PORT_KEYCMD, KEYCMD_SENDTO_MOUSE);
	wait_KBC_sendready();
	outb(PORT_KEYDAT, MOUSECMD_ENABLE);

	mouse_dec.phase = 0;
	return; /* ˳���Ļ������̿������᷵��ACK(0xfa) */
}

int mouse_decode(struct mouse_pos *mpos, unsigned char data)
{
	//char var[32];
	if (mouse_dec.phase == 0){
		if (data == 0xfa){
			mouse_dec.phase = 1;//��Ϊ����һ���ֶζ�ȡ
			return 0;
		}
	} else {
		mouse_dec.buf[mouse_dec.phase - 1] = data;
		//���ö�ȡ��һ���ֶ�
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
				mpos->y = 0 - mpos->y;//���y�����뻭��ķ����෴
				return 1;
			}
		} else {
			mouse_dec.phase++;
		}
		return 0;
	}
	return 0;
}
