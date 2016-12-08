#include "irq.h"


void irq_handler_keyboard(int *esp)
{
    box_fill(COLOR_BLACK, 0, 0, 32 * 8 - 1, 15);
    draw_ascii_font8(0, 0, COLOR_WHITE, "INT 21 (IRQ-1) : PS/2 keyboard");
}
