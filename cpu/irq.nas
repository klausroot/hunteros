[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_outb
	EXTERN	_io_sti
	EXTERN	_inb
	EXTERN	_put_bdata_fifo
	EXTERN	_box_fill
	EXTERN	_draw_ascii_font8
[FILE "irq.c"]
[SECTION .text]
	GLOBAL	_init_pic
_init_pic:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	255
	PUSH	33
	CALL	_outb
	PUSH	255
	PUSH	161
	CALL	_outb
	PUSH	17
	PUSH	32
	CALL	_outb
	PUSH	32
	PUSH	33
	CALL	_outb
	ADD	ESP,32
	PUSH	4
	PUSH	33
	CALL	_outb
	PUSH	1
	PUSH	33
	CALL	_outb
	PUSH	17
	PUSH	160
	CALL	_outb
	PUSH	40
	PUSH	161
	CALL	_outb
	ADD	ESP,32
	PUSH	2
	PUSH	161
	CALL	_outb
	PUSH	1
	PUSH	161
	CALL	_outb
	PUSH	251
	PUSH	33
	CALL	_outb
	PUSH	255
	PUSH	161
	CALL	_outb
	ADD	ESP,32
	LEAVE
	JMP	_io_sti
[SECTION .data]
LC0:
	DB	"keyboard",0x00
[SECTION .text]
	GLOBAL	_irq_handler1
_irq_handler1:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	97
	PUSH	32
	CALL	_outb
	PUSH	96
	CALL	_inb
	PUSH	LC0
	MOVZX	EAX,AL
	PUSH	EAX
	CALL	_put_bdata_fifo
	LEAVE
	RET
[SECTION .data]
LC1:
	DB	"INT 2C (IRQ-12) : PS/2 mouse",0x00
[SECTION .text]
	GLOBAL	_irq_handler12
_irq_handler12:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	100
	PUSH	160
	CALL	_outb
	PUSH	98
	PUSH	32
	CALL	_outb
	PUSH	15
	PUSH	255
	PUSH	0
	PUSH	0
	PUSH	0
	CALL	_box_fill
	ADD	ESP,36
	PUSH	LC1
	PUSH	7
	PUSH	0
	PUSH	0
	CALL	_draw_ascii_font8
	LEAVE
	RET
	GLOBAL	_irq_handler7
_irq_handler7:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	103
	PUSH	32
	CALL	_outb
	LEAVE
	RET
