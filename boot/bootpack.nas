[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_init_gdt_idt
	EXTERN	_init_pic
	EXTERN	_init_palette
	EXTERN	_init_screen
	EXTERN	_draw_ascii_font8
	EXTERN	_sprintf
	EXTERN	_init_mouse_cursor8
	EXTERN	_draw_block8_8
	EXTERN	_outb
	EXTERN	_register_fifo
	EXTERN	_io_cli
	EXTERN	_fifo_status
	EXTERN	_get_bdata_fifo
	EXTERN	_io_sti
	EXTERN	_box_fill
	EXTERN	_io_stihlt
[FILE "bootpack.c"]
[SECTION .data]
LC0:
	DB	"Hunter OS -- V1.0",0x00
LC1:
	DB	"-- Create by lichao.",0x00
LC2:
	DB	"Screen size : %d x %d.",0x00
LC3:
	DB	"keyboard",0x00
LC4:
	DB	"mouse",0x00
LC5:
	DB	"%02x",0x00
[SECTION .text]
	GLOBAL	_os_entry
_os_entry:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EBX
	SUB	ESP,320
	LEA	EBX,DWORD [-68+EBP]
	CALL	_init_gdt_idt
	CALL	_init_pic
	CALL	_init_palette
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_init_screen
	PUSH	LC0
	PUSH	7
	PUSH	35
	PUSH	5
	CALL	_draw_ascii_font8
	PUSH	LC1
	PUSH	7
	PUSH	54
	PUSH	5
	CALL	_draw_ascii_font8
	ADD	ESP,44
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	LC2
	PUSH	EBX
	CALL	_sprintf
	PUSH	EBX
	PUSH	7
	LEA	EBX,DWORD [-324+EBP]
	PUSH	73
	PUSH	5
	CALL	_draw_ascii_font8
	ADD	ESP,32
	PUSH	14
	PUSH	EBX
	CALL	_init_mouse_cursor8
	PUSH	16
	PUSH	EBX
	PUSH	152
	PUSH	150
	PUSH	16
	PUSH	16
	CALL	_draw_block8_8
	ADD	ESP,32
	PUSH	249
	PUSH	33
	CALL	_outb
	PUSH	239
	PUSH	161
	CALL	_outb
	PUSH	LC3
	PUSH	_keyboard_fifo
	CALL	_register_fifo
	PUSH	LC4
	PUSH	_mouse_fifo
	CALL	_register_fifo
	ADD	ESP,32
L8:
	CALL	_io_cli
	PUSH	LC3
	CALL	_fifo_status
	POP	EBX
	TEST	EAX,EAX
	JNE	L5
	PUSH	LC4
	CALL	_fifo_status
	POP	ECX
	TEST	EAX,EAX
	JE	L13
L5:
	PUSH	LC3
	CALL	_fifo_status
	POP	EDX
	TEST	EAX,EAX
	JE	L8
	PUSH	LC3
	CALL	_get_bdata_fifo
	MOV	BL,AL
	CALL	_io_sti
	MOVSX	EAX,BL
	PUSH	EAX
	LEA	EBX,DWORD [-68+EBP]
	PUSH	LC5
	PUSH	EBX
	CALL	_sprintf
	PUSH	32
	PUSH	15
	PUSH	16
	PUSH	0
	PUSH	6
	CALL	_box_fill
	ADD	ESP,36
	PUSH	EBX
	PUSH	7
	PUSH	16
	PUSH	0
	CALL	_draw_ascii_font8
	ADD	ESP,16
	JMP	L8
L13:
	CALL	_io_stihlt
	JMP	L8
	GLOBAL	_keyboard_fifo
[SECTION .data]
	ALIGNB	16
_keyboard_fifo:
	RESB	80
	GLOBAL	_mouse_fifo
[SECTION .data]
	ALIGNB	16
_mouse_fifo:
	RESB	80
