#include "irq.h"
#include "graphics.h"
#include "stdio.h"
#include "system/fifo.h"


void init_pic(void)
{
    outb(PIC0_IMR, 0xff); //��ֹPIC0�����ж�
    outb(PIC1_IMR, 0xff); //

    outb(PIC0_ICW1, 0x11); //���ش���ģʽ (edge trigger mode)
    outb(PIC0_ICW2, 0x20); //IRQ0-7��INT20-27����
    outb(PIC0_ICW3, 1 << 2); //PIC1��IRQ2����
    outb(PIC0_ICW4, 0x01); //�޻�����ģʽ

    outb(PIC1_ICW1, 0x11); //���ش���ģʽ
    outb(PIC1_ICW2, 0x28); //IRQ8-15��INT28-2f����
    outb(PIC1_ICW3, 2   ); //PIC1��IRQ2����
    outb(PIC1_ICW4, 0x01); //�޻�����ģʽ

    outb(PIC0_IMR, 0xfb); // 11111011 PIC1����ȫ����ֹ
    outb(PIC1_IMR, 0xff); // 11111111 ��ֹ�����ж�

    io_sti();

} 

struct key_buf{

};

#define PORT_KEYDAT		0x0060
void irq_handler1(int *esp)
{
	unsigned char data;// s[4];
	outb(PIC0_OCW2, 0x61); //֪ͨPIC IRQ-01�Ѿ��������

	data = inb(PORT_KEYDAT);
//	sprintf(s, "%02x", data);
//    box_fill(COLOR_BLACK, 0, 0, 32 * 8 - 1, 15);
//    draw_ascii_font8(0, 0, COLOR_WHITE, s);
	put_bdata_fifo(data, "keyboard");
    //draw_ascii_font8(0, 0, COLOR_WHITE, "INT 21 (IRQ-1) : PS/2 keyboard");
}

void irq_handler12(int *esp)
{
	unsigned char data;// s[8];

    outb(PIC1_OCW2, 0x64); //֪ͨPIC IRQ-12�Ѿ��������
    outb(PIC0_OCW2, 0x62); //֪ͨPIC IRQ-02�Ѿ��������
    data = inb(PORT_KEYDAT);
//	sprintf(s, "%02x", data);
//    box_fill(COLOR_BLACK, 32, 16, 32 * 8 - 1, 31);
//    draw_ascii_font8(32, 16, COLOR_WHITE, s);
    put_bdata_fifo(data, "mouse");
//    box_fill(COLOR_BLACK, 0, 0, 32 * 8 - 1, 15);
//    draw_ascii_font8(0, 0, COLOR_WHITE, "INT 2C (IRQ-12) : PS/2 mouse");
}

/*************************************************
 *PIC0�жϵĲ���������
 *����ж���Athlon64X2��ͨ��оƬ���ṩ�ı�����ֻ��Ҫִ��һ��
 *����ж�ֻ�ǽ��գ���ִ���κβ���
 *
 * Ϊʲô������ ����>��Ϊ����жϿ����ǵ������������ġ�
 *                  ֻ�Ǵ���һЩ��Ҫ�������
 *:wq
 * ***********************************************/
void irq_handler7(int *esp)
{
	outb(PIC0_OCW2, 0x67); //֪ͨPIC��IRQ-07(�ο�7-1)
}

