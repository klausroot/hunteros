#ifndef _MOUSE_H_
#define _MOUSE_H_
struct mouse_pos{
	int x;
	int y;
	int btn;
};
void init_mouse(void);

int mouse_decode(struct mouse_pos *mpos, unsigned char data);

#endif
