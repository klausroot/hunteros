#include "asm/cpu.h"
#include "graphics.h"
#include "dsctbl.h"
#include "stdio.h"
#include "irq.h"
#include "system/fifo.h"
#include "input/keyboard.h"
#include "input/mouse.h"

struct boot_info{
    unsigned char   cyls;
    unsigned char   leds;
    unsigned char   vmode;
    unsigned char   reserved;
    short           scrn_x;
    short           scrn_y;
    unsigned char   *vram;   
};

#define BOOT_INFO       0x0ff0

struct st_fifo keyboard_fifo, mouse_fifo;

void os_entry(void)
{
    struct boot_info *binfo;
    char var[64];
    unsigned char mouse_cursor[16*16];
    int data;
    int mx, my;

    binfo =  (struct boot_info *)BOOT_INFO;

    init_gdt_idt(); //��ʼ��gdt/idt

    init_pic();

    init_palette();

    init_screen(binfo->vram, binfo->scrn_x, binfo->scrn_y);

    //draw_font8(binfo->vram, binfo->scrn_x, 3, 3, COLOR_WHITE, font_A);
    draw_ascii_font8(5, 48, COLOR_WHITE, "Hunter OS -- V1.0");
    draw_ascii_font8(5, 64, COLOR_WHITE, "-- Create by lichao.");

    sprintf(var, "Screen size : %d x %d.", binfo->scrn_x, binfo->scrn_y);

    draw_ascii_font8(5, 80, COLOR_WHITE, var);

    outb(PIC0_IMR, 0xf9); /*����PIC1�ͼ����жϣ�11111001)*/
    outb(PIC1_IMR, 0xef); /*��������ж�(11101111)*/

    init_mouse_cursor8(mouse_cursor, COLOR_DARK_LI_BLUE);

    mx = (binfo->scrn_x - 16) / 2; //���㻭����������
    my = (binfo->scrn_y - 28 - 16) / 2;

    draw_block8_8(16, 16, mx, my, mouse_cursor, 16);
    
    init_keyboard();
    init_mouse();

    struct mouse_pos mpos;
    register_fifo(&keyboard_fifo, "keyboard");
    register_fifo(&mouse_fifo, "mouse");
    while(1){
    	io_cli();
    	if (!fifo_status("keyboard") && !fifo_status("mouse")){
    		io_stihlt();
    	}else {
    		if (fifo_status("keyboard")){
//    			box_fill(COLOR_BRIGHT_LI_BLUE, 0, 32, 360, 48);
//    			sprintf(s, "enter -- %d : %s %02x %02x %02x %02x %02x %02x %02x %02x.", i++, keyboard_fifo.fname,
//    					keyboard_fifo.b_data[0], keyboard_fifo.b_data[1], keyboard_fifo.b_data[2], keyboard_fifo.b_data[3],
//    					keyboard_fifo.b_data[4], keyboard_fifo.b_data[5], keyboard_fifo.b_data[6], keyboard_fifo.b_data[7]);
//    			draw_ascii_font8(0, 32, COLOR_WHITE, s);
    			data = get_bdata_fifo("keyboard");
    			io_sti();
    			sprintf(var, "%02x", data);
    			box_fill(COLOR_DARK_LI_BLUE, 0, 16, 15, 31);
    			draw_ascii_font8(0, 16, COLOR_WHITE, var);
    		}else if (fifo_status("mouse")){
    			data = get_bdata_fifo("mouse");
    			io_sti();

    			if (mouse_decode(&mpos, data)){
    				//��ʾ����
					sprintf(var, "[lrc %4d %4d]", mpos.x, mpos.y);
					if (mpos.btn & 0x01){
						var[1] = 'L';
					}
					if (mpos.btn & 0x02){
						var[2] = 'R';
					}
					if (mpos.btn & 0x04){
						var[3] = 'C';
					}
	    			box_fill(COLOR_DARK_LI_BLUE, 32, 16, 32 + 15 * 8 - 1, 31);
	    			draw_ascii_font8(32, 16, COLOR_WHITE, var);
	    			//���ָ���ƶ�
	    			box_fill(COLOR_DARK_LI_BLUE, mx, my, mx + 15, my + 15);
	    			mx += mpos.x;
	    			my += mpos.y;
	    			if (mx < 0){
	    				mx = 0;
	    			}
	    			if (my < 0){
	    				my = 0;
	    			}
	    			if (mx > (binfo->scrn_x - 16)){
	    				mx = binfo->scrn_x - 16;
	    			}
	    			if (my > (binfo->scrn_y - 16)){
	    				my = binfo->scrn_y - 16;
	    			}
	    			sprintf(var, "(%3d, %3d)", mx, my);
	    			box_fill(COLOR_DARK_LI_BLUE, 0, 0, 79, 15); //��������
	    			draw_ascii_font8(0, 0, COLOR_WHITE, var); //��ʾ����
	    			draw_block8_8(16, 16, mx, my, mouse_cursor, 16);//�����
    			}
//    			sprintf(var, "%02x", data);
//    			box_fill(COLOR_DARK_LI_BLUE, 32, 96, 47, 111);
//    			draw_ascii_font8(32, 96, COLOR_WHITE, var);
        	}
    	}
    }

    while(1)
    {
        cpu_hlt();// 
    }
}


