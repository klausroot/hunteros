[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_init_gdt_idt
	EXTERN	_init_pic
	EXTERN	_outb
	EXTERN	_init_keyboard
	EXTERN	_init_mouse
	EXTERN	_mem_test
	EXTERN	_mm_init
	EXTERN	_mm_space_add
	EXTERN	_init_palette
	EXTERN	_sheet_ctrl_init
	EXTERN	_new_sheet
	EXTERN	_lmalloc
	EXTERN	_sheet_setbuf
	EXTERN	_init_screen
	EXTERN	_draw_ascii_font8
	EXTERN	_sprintf
	EXTERN	_mm_total
	EXTERN	_init_mouse_cursor8
	EXTERN	_sheet_switch
[FILE "bootpack.c"]
[SECTION .data]
LC0:
	DB	"Hunter OS -- V1.0.0",0x00
LC1:
	DB	"-- Create by lichao.",0x00
LC2:
	DB	"Screen size : %d x %d.",0x00
LC3:
	DB	"memory : %dMB, free size : %dKB",0x00
[SECTION .text]
	GLOBAL	_os_entry
_os_entry:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	SUB	ESP,340
	CALL	_init_gdt_idt
	CALL	_init_pic
	PUSH	249
	PUSH	33
	CALL	_outb
	PUSH	239
	PUSH	161
	CALL	_outb
	CALL	_init_keyboard
	CALL	_init_mouse
	PUSH	-1073741825
	PUSH	4194304
	CALL	_mem_test
	PUSH	647168
	PUSH	4096
	MOV	DWORD [-352+EBP],EAX
	CALL	_mm_init
	ADD	ESP,32
	MOV	EAX,DWORD [-352+EBP]
	SUB	EAX,4194304
	PUSH	EAX
	PUSH	4194304
	CALL	_mm_space_add
	CALL	_init_palette
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	DWORD [4088]
	CALL	_sheet_ctrl_init
	CALL	_new_sheet
	MOV	EDI,EAX
	CALL	_new_sheet
	MOV	ESI,EAX
	MOVSX	EDX,WORD [4086]
	MOVSX	EAX,WORD [4084]
	IMUL	EAX,EDX
	PUSH	EAX
	CALL	_lmalloc
	PUSH	-1
	MOV	EBX,EAX
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	EBX
	PUSH	EDI
	CALL	_sheet_setbuf
	LEA	EAX,DWORD [-332+EBP]
	ADD	ESP,44
	PUSH	99
	PUSH	16
	PUSH	16
	PUSH	EAX
	PUSH	ESI
	CALL	_sheet_setbuf
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	EBX
	LEA	EBX,DWORD [-76+EBP]
	CALL	_init_screen
	ADD	ESP,32
	MOV	ESI,EAX
	PUSH	LC0
	PUSH	7
	PUSH	48
	PUSH	5
	PUSH	EAX
	CALL	_draw_ascii_font8
	PUSH	LC1
	PUSH	7
	PUSH	64
	PUSH	5
	PUSH	ESI
	CALL	_draw_ascii_font8
	ADD	ESP,40
	MOVSX	EAX,WORD [4086]
	PUSH	EAX
	MOVSX	EAX,WORD [4084]
	PUSH	EAX
	PUSH	LC2
	PUSH	EBX
	CALL	_sprintf
	PUSH	EBX
	PUSH	7
	PUSH	80
	PUSH	5
	PUSH	ESI
	CALL	_draw_ascii_font8
	ADD	ESP,36
	CALL	_mm_total
	SHR	EAX,10
	PUSH	EAX
	PUSH	DWORD [-352+EBP]
	PUSH	LC3
	PUSH	EBX
	CALL	_sprintf
	PUSH	EBX
	PUSH	7
	PUSH	96
	PUSH	32
	PUSH	ESI
	CALL	_draw_ascii_font8
	LEA	EAX,DWORD [-332+EBP]
	ADD	ESP,36
	PUSH	14
	PUSH	EAX
	CALL	_init_mouse_cursor8
	PUSH	0
	PUSH	EDI
	CALL	_sheet_switch
	ADD	ESP,16
L2:
	JMP	L2
	GLOBAL	_keyboard_fifo
[SECTION .data]
	ALIGNB	16
_keyboard_fifo:
	RESB	160
	GLOBAL	_mouse_fifo
[SECTION .data]
	ALIGNB	16
_mouse_fifo:
	RESB	160
