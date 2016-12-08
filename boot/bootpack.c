#include "asm/cpu.h"
#include "graphics.h"
#include "dsctbl.h"
#include "stdio.h"
#include "irq.h"

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

void os_entry(void)
{
    
    struct boot_info *binfo;
    char var[64];
    unsigned char mouse_cursor[16*16];

    binfo =  (struct boot_info *)BOOT_INFO;

    init_gdt_idt(); //��ʼ��gdt/idt

    init_pic();

    init_palette();

    init_screen(binfo->vram, binfo->scrn_x, binfo->scrn_y);

    //draw_font8(binfo->vram, binfo->scrn_x, 3, 3, COLOR_WHITE, font_A);
    draw_ascii_font8(5, 35, COLOR_WHITE, "Hunter OS -- V1.0");
    draw_ascii_font8(5, 54, COLOR_WHITE, "-- Create by lichao.");

    sprintf(var, "Screen size : %d x %d.", binfo->scrn_x, binfo->scrn_y);

    draw_ascii_font8(5, 73, COLOR_WHITE, var);


    init_mouse_cursor8(mouse_cursor, COLOR_DARK_LI_BLUE);

    draw_block8_8(16, 16, 150, 152, mouse_cursor, 16);
    
    outb(PIC0_IMR, 0xf9);
    outb(PIC1_IMR, 0xef);
    
    while(1)
    {
        cpu_hlt();// 
    }
}


/*
int dvb_s2_main(void)
{
    struct TS_PAT *PAT_

}
*/
