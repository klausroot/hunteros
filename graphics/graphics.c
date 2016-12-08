#include "graphics.h"
#include "asm/cpu.h"



static void set_palette(int start, int end, unsigned int *rgb);


static unsigned char *vram_addr;
static int scrn_xsize;

static void init_screen_info(unsigned char *addr, int x_size)
{
    vram_addr = addr;
    scrn_xsize = x_size;
}

static unsigned char *get_vram_addr(void)
{
    return vram_addr;
}

static int get_screen_width(void)
{
    return scrn_xsize;
}


void init_screen(unsigned char *vram, int x_size, int y_size)
{

    init_screen_info(vram, x_size);

    box_fill(COLOR_DARK_LI_BLUE, 0, 0, x_size - 1, y_size - 29);    
    box_fill(COLOR_BRIGHT_GRAY, 0, y_size - 28, x_size - 1, y_size - 28);
    box_fill(COLOR_WHITE, 0, y_size - 27, x_size - 1, y_size - 27);
    box_fill(COLOR_BRIGHT_GRAY, 0, y_size - 26, x_size - 1, y_size - 1);

    //Í¹Æðbutton
    box_fill(COLOR_WHITE, 3, y_size - 24, 59, y_size - 24);
    box_fill(COLOR_WHITE, 2, y_size - 24, 2, y_size - 4);
    box_fill(COLOR_DARK_GRAY, 3, y_size - 4, 59, y_size - 4);
    box_fill(COLOR_DARK_GRAY, 59, y_size - 23, 59, y_size - 4);
    box_fill(COLOR_BLACK, 60, y_size - 24, 60, y_size - 3);
    box_fill(COLOR_BLACK, 2, y_size - 3, 59, y_size - 3); 

    //°¼½øÈ¥µÄbutton
    box_fill(COLOR_DARK_GRAY, x_size - 47, y_size - 24, x_size - 4, y_size - 24);
    box_fill(COLOR_DARK_GRAY, x_size - 47, y_size - 23, x_size - 47, y_size - 4);
    box_fill(COLOR_WHITE, x_size - 47, y_size - 3, x_size - 4, y_size - 3);
    box_fill(COLOR_WHITE, x_size - 3, y_size - 24, x_size - 3, y_size - 3); 
}


int box_fill(unsigned char color, int x0, int y0, int x1, int y1)
{
    int x,y;
    unsigned char *vram = 0;
    int x_size = 0;

    vram = get_vram_addr();
    x_size = get_screen_width();

    for (y = y0; y <= y1; y++){
        for (x = x0; x <= x1; x++){
            vram[y * x_size + x] = color;
        }
    }
    return 0;
}


static const unsigned int color_tbl[] = { //8 BITS
    0x000000, //ºÚ
    0xff0000, //ÁÁºì
    0x00ff00, //ÁÁÂÌ
    0xffff00, //ÁÁ»Æ
    0x0000ff, //ÁÁÀ¶
    0xff00ff, //ÁÁ×Ï
    0x00ffff, //Ç³ÁÁÀ¶
    0xffffff, //°×
    0xc6c6c6, //ÁÁ»Ò
    0x840000, //°µºì
    0x008400, //°µÂÌ
    0x848400, //°µ»Æ
    0x000084, //°µÀ¶
    0x840084, //°µ×Ï
    0x008484, //Ç³°µÀ¶
    0x848484, //°µ»Ò
};

void init_palette(void)
{
   set_palette(0, 15, color_tbl);
}

#define PALETTE_W_START  0x03c8
#define PALETTE_IOW      0x03C9

#define COLOR_R(x)     (unsigned char)((x >> 16) & 0xff)
#define COLOR_G(x)     (unsigned char)((x >> 8) & 0xff)
#define COLOR_B(x)     (unsigned char)(x & 0xff)
void set_palette(int start, int end, unsigned int *rgb)
{
    int i = 0;

    cpu_irq_disable();

    outb(PALETTE_W_START, start);

    for (i = start; i <= end; i++){
    	outb(PALETTE_IOW, COLOR_R(rgb[i]) / 4);
    	outb(PALETTE_IOW, COLOR_G(rgb[i]) / 4);
    	outb(PALETTE_IOW, COLOR_B(rgb[i]) / 4);
    }

    cpu_irq_enable();
}

/*
static const unsigned char font_A[16] = {
    0x00, 0x18, 0x18, 0x18, 0x18, 0x24, 0x24, 0x24, 
    0x24, 0x7e, 0x42, 0x42, 0x42, 0xe7, 0x00, 0x00,
};
*/
void draw_font8(int x, int y,  unsigned char color, unsigned char *font)
{
    int i = 0;
    
    unsigned char *vram, *vram_p;
    unsigned char fd;//font_data
    int xsize = 0;
    
    vram = get_vram_addr();
    xsize = get_screen_width();

    for (i = 0; i < 16; i++){
        vram_p = vram + xsize * (y + i) + x;
        fd = font[i];
        if (fd & 0x80){vram_p[0] = color;}
        if (fd & 0x40){vram_p[1] = color;}
        if (fd & 0x20){vram_p[2] = color;}
        if (fd & 0x10){vram_p[3] = color;}
        if (fd & 0x08){vram_p[4] = color;}
        if (fd & 0x04){vram_p[5] = color;}
        if (fd & 0x02){vram_p[6] = color;}
        if (fd & 0x01){vram_p[7] = color;}   
    }
}

extern unsigned char hankaku[];

int draw_ascii_font8(int x, int y, unsigned char color, char *str)
{
    char *p_str;//= NULL;
    int x_pos = x;

    if (!str){
        return -1;
    }
    p_str = str;

    for (;*p_str != '\0'; p_str++){
        draw_font8(x_pos, y, color, hankaku + *p_str * 16);
        x_pos+=8;
    }

    return 0;
}

static char cursor[16][16] = {
    "**************..",
    "*OOOOOOOOOOO*...",
    "*OOOOOOOOOO*....",
    "*OOOOOOOOO*.....",
    "*OOOOOOOO*......",
    "*OOOOOOO*.......",
    "*OOOOOOO*.......",
    "*OOOOOOOO*......",
    "*OOOO**OOO*.....",
    "*OOO*..*OOO*....",
    "*oo*....*OOO*...",
    "*o*......*OOO*..",
    "**........*OOO*.",
    "*..........*OOO*",
    "............*OO*",
    ".............***",
};

void init_mouse_cursor8(unsigned char *mouse, unsigned char bc)
{
    int x = 0;
    int y = 0;

    for (y = 0; y < 16; y++){
        for (x = 0; x < 16; x ++){
            if (cursor[y][x] == '*'){
                mouse[y * 16 + x] = COLOR_BLACK;
            }
            
            if (cursor[y][x] == 'O'){
                mouse[y * 16 + x] = COLOR_WHITE;
            }

            if (cursor[y][x] == '.'){
                mouse[y * 16 + x] = bc;
            }
        }
    }
}


void draw_block8_8(int pxsize, int pysize, int px0, int py0, unsigned char *buf, int bxsize)
{
    int x;
    int y;
    unsigned char *vram = 0;
    int vxsize = 0;
    
    vram = get_vram_addr();
    vxsize = get_screen_width();

    for (y = 0; y < pysize; y++){
        for (x = 0; x < pxsize; x++){
            vram[(py0 + y) * vxsize + (px0 + x)] = buf[y * bxsize + x];
        }
    }
}
