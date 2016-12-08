#include "dsctbl.h"
#include "asm/cpu.h"

struct segment_descriptor{
    short limit_low;
    short base_low;
    unsigned char base_mid;
    unsigned char access_right;
    unsigned char limit_high;
    unsigned char base_high;
};

struct gate_descriptor{
    short offset_low;
    short selector;
    unsigned char dw_count;
    unsigned char access_right;
    short offset_high;
};


/********************************************************************************
 *
 *  accsess right -- 段属性(段的访问权属性)
 *
 *  xxxx0000xxxxxxxx(12 bits)
 *  
 *  
 *  高4位：在limit_high  的高4位里
 *  
 *  GD00 : G -- G bit, D -- 段的模式(1-32位模式 0-16位模式, 除80286程序外，通常D=1)
 *
 *  低8位：
 *  00000000(0x00) : 未使用的记录表
 *  
 *  10010010(0x92) : 系统专用，可读写的段。不可执行
 *
 *  10011010(0x9a) : 系统专用，可执行的段。可读不可写
 *
 *  11110010(0xf2) : 应用程序用，可读写的段。不可执行
 *
 *  11111010(0xfa) : 应用程序用，可执行的段。可读不可写
 *
 *
 ********************************************************************************/
void set_segm_desc(struct segment_descriptor *sd, unsigned int limit, int base, int ar)
{
    if (limit > 0xfffff){
        ar |= 0x8000; /*G_bit = 1*/
        limit /= 0x1000;
    }

    sd->limit_low = limit & 0xffff;
    sd->base_low = base & 0xffff;
    sd->base_mid = (base >> 16) & 0xff;
    sd->access_right = ar & 0xff;
    sd->limit_high = ((limit >> 16) & 0x0f) | ((ar >> 8) & 0xf0);//高4位存放ar高4位
    sd->base_high = (base >> 24) & 0xff;
}

void set_gate_desc(struct gate_descriptor *gd, int offset, int selector, int ar)
{   
    gd->offset_low = offset & 0xffff;
    gd->selector = selector;
    gd->dw_count = (ar >> 8) & 0xff;
    gd->access_right = ar & 0xff;
    gd->offset_high = (offset >> 16) & 0xffff;
}


#define GDT_ADDR    0x00270000
#define LIMIT_GDT   0x0000ffff
#define IDT_ADDR    0x0026f800
#define LIMIT_IDT   0x000007ff
#define BOOTPACK_ADDR   0x00280000
#define LIMIT_BOOTPACK  0x0007ffff
#define AR_DATA32_RW    0x4092
#define AR_CODE32_ER    0x409a
#define AR_INTGATE32    0x008e

/**************************************************************
 *	@name : init_gdt_idt
 *	@return : void
 *	@description : 初始化 gdt(global (segment) descriptor table)全局段号记录表
 *				         初始化 idt(interrupt decriptor table)中断记录表
 *
 **************************************************************/
void init_gdt_idt(void)
{
    struct segment_descriptor *gdt = (struct segment_descriptor *)GDT_ADDR;
    struct gate_descriptor *idt     = (struct gate_descriptor    *)IDT_ADDR;

    int i;

    /*GDT 初始化*/
    for (i = 0; i <= (LIMIT_GDT / 8); i++){
        set_segm_desc(gdt + i, 0, 0, 0);
    }

    set_segm_desc(gdt + 1, 0xffffffff, 0x00000000, AR_DATA32_RW);
    set_segm_desc(gdt + 2, LIMIT_BOOTPACK, BOOTPACK_ADDR, AR_CODE32_ER);

    load_gdtr(LIMIT_GDT, GDT_ADDR);

    /*IDT 初始化*/
    for (i = 0; i <= (LIMIT_IDT / 8); i++){
        set_gate_desc(idt + i, 0, 0, 0);
    }
    load_idtr(LIMIT_IDT, IDT_ADDR);

    /*IDT 设置*/
    set_gate_desc(idt + 0x20 + 1, (int)asm_irq_handler1, 2 * 8, AR_INTGATE32);
    set_gate_desc(idt + 0x20 + 7, (int)asm_irq_handler7, 2 * 8, AR_INTGATE32);
    set_gate_desc(idt + 0x20 + 12, (int)asm_irq_handler12, 2 * 8, AR_INTGATE32);
}
