#ifndef _GRAPHICS_H_
#define _GRAPHICS_H_

enum color_list{
    COLOR_BLACK = 0,
    COLOR_BRIGHT_RED = 1,
    COLOR_BRIGHT_GREEN,
    COLOR_BRIGHT_YELLOW,
    COLOR_BRIGHT_BLUE,
    COLOR_BRIGHT_PURPLE,
    COLOR_BRIGHT_LI_BLUE,
    COLOR_WHITE,
    COLOR_BRIGHT_GRAY,
    COLOR_DARK_RED,
    COLOR_DARK_GREEN,
    COLOR_DARK_YELLOW,
    COLOR_DARK_BLUE,
    COLOR_DARK_PUREPLE,
    COLOR_DARK_LI_BLUE,
    COLOR_DARK_GRAY,
};

void init_palette(void);

void init_screen(unsigned char *vram, int x_size, int y_size);

int box_fill(unsigned char color_num, int x0, int y0, int x1, int y1);

int draw_ascii_font8(int x, int y, unsigned char color, char *str);

void init_mouse_cursor8(unsigned char *mouse, unsigned char bc);

void draw_block8_8(int pxsize, int pysize, int px0, int py0, unsigned char *buf, int bxsize);
#endif
