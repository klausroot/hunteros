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
	EXTERN	_outb
	EXTERN	_init_mouse_cursor8
	EXTERN	_draw_block8_8
	EXTERN	_init_keyboard
	EXTERN	_init_mouse
	EXTERN	_register_fifo
	EXTERN	_io_cli
	EXTERN	_fifo_status
	EXTERN	_get_bdata_fifo
	EXTERN	_io_sti
	EXTERN	_mouse_decode
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
LC6:
	DB	"[lrc %4d %4d]",0x00
LC7:
	DB	"(%3d, %3d)",0x00
LC5:
	DB	"%02x",0x00
[SECTION .text]
	GLOBAL	_os_entry
_os_entry:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	MOV	ESI,2
	PUSH	EBX
	LEA	EBX,DWORD [-76+EBP]
	SUB	ESP,340
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
	PUSH	48
	PUSH	5
	CALL	_draw_ascii_font8
	PUSH	LC1
	PUSH	7
	PUSH	64
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
	LEA	EBX,DWORD [-332+EBP]
	PUSH	80
	PUSH	5
	CALL	_draw_ascii_font8
	ADD	ESP,32
	PUSH	249
	PUSH	33
	CALL	_outb
	PUSH	239
	PUSH	161
	CALL	_outb
	PUSH	14
	PUSH	EBX
	CALL	_init_mouse_cursor8
	MOVSX	EAX,WORD [4084]
	LEA	ECX,DWORD [-16+EAX]
	MOV	EAX,ECX
	MOV	ECX,2
	CDQ
	IDIV	ESI
	MOV	EDI,EAX
	MOVSX	EAX,WORD [4086]
	PUSH	16
	LEA	ESI,DWORD [-44+EAX]
	PUSH	EBX
	MOV	EAX,ESI
	CDQ
	IDIV	ECX
	PUSH	EAX
	MOV	ESI,EAX
	PUSH	EDI
	PUSH	16
	PUSH	16
	CALL	_draw_block8_8
	ADD	ESP,48
	CALL	_init_keyboard
	CALL	_init_mouse
	PUSH	LC3
	PUSH	_keyboard_fifo
	CALL	_register_fifo
	PUSH	LC4
	PUSH	_mouse_fifo
	CALL	_register_fifo
L23:
	ADD	ESP,16
L18:
	CALL	_io_cli
	PUSH	LC3
	CALL	_fifo_status
	POP	EDX
	TEST	EAX,EAX
	JNE	L5
	PUSH	LC4
	CALL	_fifo_status
	POP	EBX
	TEST	EAX,EAX
	JE	L24
L5:
	PUSH	LC3
	CALL	_fifo_status
	POP	ECX
	TEST	EAX,EAX
	JNE	L25
	PUSH	LC4
	CALL	_fifo_status
	POP	EDX
	TEST	EAX,EAX
	JE	L18
	PUSH	LC4
	CALL	_get_bdata_fifo
	MOV	EBX,EAX
	CALL	_io_sti
	MOVZX	EAX,BL
	PUSH	EAX
	LEA	EAX,DWORD [-348+EBP]
	PUSH	EAX
	CALL	_mouse_decode
	ADD	ESP,12
	TEST	EAX,EAX
	JE	L18
	PUSH	DWORD [-344+EBP]
	PUSH	DWORD [-348+EBP]
	PUSH	LC6
	LEA	EBX,DWORD [-76+EBP]
	PUSH	EBX
	CALL	_sprintf
	ADD	ESP,16
	MOV	EAX,DWORD [-340+EBP]
	TEST	EAX,1
	JE	L11
	MOV	BYTE [-75+EBP],76
L11:
	TEST	EAX,2
	JE	L12
	MOV	BYTE [-74+EBP],82
L12:
	AND	EAX,4
	JE	L13
	MOV	BYTE [-73+EBP],67
L13:
	PUSH	31
	PUSH	151
	PUSH	16
	PUSH	32
	PUSH	14
	CALL	_box_fill
	PUSH	EBX
	PUSH	7
	PUSH	16
	PUSH	32
	CALL	_draw_ascii_font8
	LEA	EAX,DWORD [15+ESI]
	ADD	ESP,36
	PUSH	EAX
	LEA	EAX,DWORD [15+EDI]
	PUSH	EAX
	PUSH	ESI
	PUSH	EDI
	PUSH	14
	CALL	_box_fill
	ADD	ESP,20
	ADD	ESI,DWORD [-344+EBP]
	ADD	EDI,DWORD [-348+EBP]
	JS	L26
L14:
	TEST	ESI,ESI
	JS	L27
L15:
	MOVSX	EAX,WORD [4084]
	SUB	EAX,16
	CMP	EDI,EAX
	JLE	L16
	MOV	EDI,EAX
L16:
	MOVSX	EAX,WORD [4086]
	SUB	EAX,16
	CMP	ESI,EAX
	JLE	L17
	MOV	ESI,EAX
L17:
	PUSH	ESI
	PUSH	EDI
	PUSH	LC7
	PUSH	EBX
	CALL	_sprintf
	PUSH	15
	PUSH	79
	PUSH	0
	PUSH	0
	PUSH	14
	CALL	_box_fill
	ADD	ESP,36
	PUSH	EBX
	PUSH	7
	PUSH	0
	PUSH	0
	CALL	_draw_ascii_font8
	LEA	EAX,DWORD [-332+EBP]
	PUSH	16
	PUSH	EAX
	PUSH	ESI
	PUSH	EDI
	PUSH	16
	PUSH	16
	CALL	_draw_block8_8
	ADD	ESP,40
	JMP	L18
L27:
	XOR	ESI,ESI
	JMP	L15
L26:
	XOR	EDI,EDI
	JMP	L14
L25:
	PUSH	LC3
	CALL	_get_bdata_fifo
	MOV	EBX,EAX
	CALL	_io_sti
	PUSH	EBX
	LEA	EBX,DWORD [-76+EBP]
	PUSH	LC5
	PUSH	EBX
	CALL	_sprintf
	PUSH	31
	PUSH	15
	PUSH	16
	PUSH	0
	PUSH	14
	CALL	_box_fill
	ADD	ESP,36
	PUSH	EBX
	PUSH	7
	PUSH	16
	PUSH	0
	CALL	_draw_ascii_font8
	JMP	L23
L24:
	CALL	_io_stihlt
	JMP	L18
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
