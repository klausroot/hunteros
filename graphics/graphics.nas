[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_lmalloc
	EXTERN	_cpu_irq_disable
	EXTERN	_outb
	EXTERN	_cpu_irq_enable
	EXTERN	_hankaku
[FILE "graphics.c"]
[SECTION .text]
_init_screen_info:
	PUSH	EBP
	MOV	EBP,ESP
	MOV	EAX,DWORD [8+EBP]
	MOV	DWORD [_vram_addr],EAX
	MOV	EAX,DWORD [12+EBP]
	POP	EBP
	MOV	DWORD [_scrn_xsize],EAX
	RET
_get_vram_addr:
	PUSH	EBP
	MOV	EAX,DWORD [_vram_addr]
	MOV	EBP,ESP
	POP	EBP
	RET
_get_screen_width:
	PUSH	EBP
	MOV	EAX,DWORD [_scrn_xsize]
	MOV	EBP,ESP
	POP	EBP
	RET
	GLOBAL	_init_screen
_init_screen:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	SUB	ESP,16
	MOV	ESI,DWORD [16+EBP]
	PUSH	12
	CALL	_lmalloc
	MOV	EDI,EAX
	POP	EAX
	XOR	EAX,EAX
	TEST	EDI,EDI
	JE	L4
	MOV	EAX,DWORD [8+EBP]
	MOV	EBX,DWORD [12+EBP]
	MOV	DWORD [8+EDI],EAX
	DEC	EBX
	MOV	EAX,DWORD [12+EBP]
	MOV	DWORD [4+EDI],ESI
	MOV	DWORD [EDI],EAX
	LEA	EAX,DWORD [-29+ESI]
	PUSH	EAX
	PUSH	EBX
	PUSH	0
	PUSH	0
	PUSH	14
	PUSH	EDI
	CALL	_box_fill
	LEA	EAX,DWORD [-28+ESI]
	PUSH	EAX
	PUSH	EBX
	PUSH	EAX
	PUSH	0
	PUSH	8
	PUSH	EDI
	CALL	_box_fill
	LEA	EAX,DWORD [-27+ESI]
	ADD	ESP,48
	PUSH	EAX
	PUSH	EBX
	PUSH	EAX
	PUSH	0
	PUSH	7
	PUSH	EDI
	CALL	_box_fill
	LEA	EAX,DWORD [-1+ESI]
	PUSH	EAX
	LEA	EAX,DWORD [-26+ESI]
	PUSH	EBX
	PUSH	EAX
	PUSH	0
	PUSH	8
	PUSH	EDI
	CALL	_box_fill
	LEA	EAX,DWORD [-24+ESI]
	ADD	ESP,48
	MOV	DWORD [-16+EBP],EAX
	PUSH	EAX
	PUSH	59
	PUSH	EAX
	PUSH	3
	PUSH	7
	PUSH	EDI
	CALL	_box_fill
	LEA	EAX,DWORD [-4+ESI]
	PUSH	EAX
	MOV	DWORD [-20+EBP],EAX
	PUSH	2
	PUSH	DWORD [-16+EBP]
	PUSH	2
	PUSH	7
	PUSH	EDI
	CALL	_box_fill
	ADD	ESP,48
	PUSH	DWORD [-20+EBP]
	PUSH	59
	PUSH	DWORD [-20+EBP]
	PUSH	3
	PUSH	15
	PUSH	EDI
	CALL	_box_fill
	LEA	EAX,DWORD [-23+ESI]
	PUSH	DWORD [-20+EBP]
	PUSH	59
	MOV	DWORD [-24+EBP],EAX
	PUSH	EAX
	SUB	ESI,3
	PUSH	59
	PUSH	15
	PUSH	EDI
	CALL	_box_fill
	ADD	ESP,48
	PUSH	ESI
	PUSH	60
	PUSH	DWORD [-16+EBP]
	PUSH	60
	PUSH	0
	PUSH	EDI
	CALL	_box_fill
	PUSH	ESI
	PUSH	59
	PUSH	ESI
	PUSH	2
	PUSH	0
	PUSH	EDI
	CALL	_box_fill
	MOV	EBX,DWORD [12+EBP]
	ADD	ESP,48
	MOV	EAX,DWORD [12+EBP]
	PUSH	DWORD [-16+EBP]
	SUB	EAX,4
	SUB	EBX,47
	PUSH	EAX
	MOV	DWORD [-28+EBP],EAX
	PUSH	DWORD [-16+EBP]
	PUSH	EBX
	PUSH	15
	PUSH	EDI
	CALL	_box_fill
	PUSH	DWORD [-20+EBP]
	PUSH	EBX
	PUSH	DWORD [-24+EBP]
	PUSH	EBX
	PUSH	15
	PUSH	EDI
	CALL	_box_fill
	ADD	ESP,48
	PUSH	ESI
	PUSH	DWORD [-28+EBP]
	PUSH	ESI
	PUSH	EBX
	PUSH	7
	PUSH	EDI
	CALL	_box_fill
	MOV	EAX,DWORD [12+EBP]
	PUSH	ESI
	SUB	EAX,3
	PUSH	EAX
	PUSH	DWORD [-16+EBP]
	PUSH	EAX
	PUSH	7
	PUSH	EDI
	CALL	_box_fill
	MOV	EAX,EDI
L4:
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	GLOBAL	_box_fill
_box_fill:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	SUB	ESP,12
	MOV	EAX,DWORD [8+EBP]
	MOV	DL,BYTE [12+EBP]
	MOV	BYTE [-13+EBP],DL
	TEST	EAX,EAX
	JE	L8
	MOV	EDI,DWORD [8+EAX]
	TEST	EDI,EDI
	JNE	L7
L8:
	OR	EAX,-1
L6:
	ADD	ESP,12
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
L7:
	MOV	EAX,DWORD [EAX]
	MOV	ECX,DWORD [20+EBP]
	MOV	DWORD [-24+EBP],EAX
	CMP	ECX,DWORD [28+EBP]
	JG	L20
	MOV	EBX,EAX
	IMUL	EBX,ECX
L18:
	MOV	EDX,DWORD [16+EBP]
	CMP	EDX,DWORD [24+EBP]
	JG	L22
	LEA	EAX,DWORD [EDI+EBX*1]
	LEA	EAX,DWORD [EAX+EDX*1]
	MOV	DWORD [-20+EBP],EAX
L17:
	MOV	ESI,DWORD [-20+EBP]
	MOV	AL,BYTE [-13+EBP]
	INC	EDX
	MOV	BYTE [ESI],AL
	INC	ESI
	MOV	DWORD [-20+EBP],ESI
	CMP	EDX,DWORD [24+EBP]
	JLE	L17
L22:
	INC	ECX
	ADD	EBX,DWORD [-24+EBP]
	CMP	ECX,DWORD [28+EBP]
	JLE	L18
L20:
	XOR	EAX,EAX
	JMP	L6
[SECTION .data]
_color_tbl:
	DD	0
	DD	16711680
	DD	65280
	DD	16776960
	DD	255
	DD	16711935
	DD	65535
	DD	16777215
	DD	13027014
	DD	8650752
	DD	33792
	DD	8684544
	DD	132
	DD	8650884
	DD	33924
	DD	8684676
[SECTION .text]
	GLOBAL	_init_palette
_init_palette:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	_color_tbl
	PUSH	15
	PUSH	0
	CALL	_set_palette
	LEAVE
	RET
_set_palette:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	MOV	EBX,DWORD [8+EBP]
	MOV	EDI,DWORD [12+EBP]
	MOV	ESI,DWORD [16+EBP]
	CALL	_cpu_irq_disable
	MOVZX	EAX,BL
	PUSH	EAX
	PUSH	968
	CALL	_outb
	CMP	EBX,EDI
	POP	EDX
	POP	ECX
	JLE	L29
L31:
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	JMP	_cpu_irq_enable
L29:
	MOV	AL,BYTE [2+ESI+EBX*4]
	SHR	AL,2
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_outb
	MOV	EAX,DWORD [ESI+EBX*4]
	SHR	EAX,10
	AND	EAX,63
	PUSH	EAX
	PUSH	969
	CALL	_outb
	MOV	AL,BYTE [ESI+EBX*4]
	SHR	AL,2
	INC	EBX
	MOVZX	EAX,AL
	PUSH	EAX
	PUSH	969
	CALL	_outb
	ADD	ESP,24
	CMP	EBX,EDI
	JLE	L29
	JMP	L31
	GLOBAL	_draw_font8
_draw_font8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	ESI
	XOR	ESI,ESI
	MOV	EAX,DWORD [8+EBP]
	MOV	BL,BYTE [20+EBP]
	TEST	EAX,EAX
	JE	L32
	MOV	EDI,DWORD [8+EAX]
	TEST	EDI,EDI
	JE	L32
	MOV	EAX,DWORD [EAX]
	MOV	DWORD [-16+EBP],EAX
L47:
	MOV	EAX,DWORD [16+EBP]
	MOV	EDX,DWORD [12+EBP]
	ADD	EAX,ESI
	IMUL	EAX,DWORD [-16+EBP]
	LEA	EAX,DWORD [EAX+EDI*1]
	LEA	ECX,DWORD [EDX+EAX*1]
	MOV	EAX,DWORD [24+EBP]
	MOV	DL,BYTE [ESI+EAX*1]
	TEST	DL,DL
	JNS	L39
	MOV	BYTE [ECX],BL
L39:
	MOV	AL,DL
	AND	EAX,64
	TEST	AL,AL
	JE	L40
	MOV	BYTE [1+ECX],BL
L40:
	MOV	AL,DL
	AND	EAX,32
	TEST	AL,AL
	JE	L41
	MOV	BYTE [2+ECX],BL
L41:
	MOV	AL,DL
	AND	EAX,16
	TEST	AL,AL
	JE	L42
	MOV	BYTE [3+ECX],BL
L42:
	MOV	AL,DL
	AND	EAX,8
	TEST	AL,AL
	JE	L43
	MOV	BYTE [4+ECX],BL
L43:
	MOV	AL,DL
	AND	EAX,4
	TEST	AL,AL
	JE	L44
	MOV	BYTE [5+ECX],BL
L44:
	MOV	AL,DL
	AND	EAX,2
	TEST	AL,AL
	JE	L45
	MOV	BYTE [6+ECX],BL
L45:
	AND	EDX,1
	TEST	DL,DL
	JE	L37
	MOV	BYTE [7+ECX],BL
L37:
	INC	ESI
	CMP	ESI,15
	JLE	L47
L32:
	POP	EBX
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
	GLOBAL	_draw_ascii_font8
_draw_ascii_font8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	PUSH	EBX
	PUSH	EDI
	MOV	EAX,DWORD [24+EBP]
	MOV	DL,BYTE [20+EBP]
	MOV	EDI,DWORD [8+EBP]
	MOV	BYTE [-13+EBP],DL
	MOV	ESI,DWORD [12+EBP]
	TEST	EAX,EAX
	JE	L51
	TEST	EDI,EDI
	JE	L51
	MOV	EBX,EAX
	CMP	BYTE [EAX],0
	JNE	L56
L58:
	XOR	EAX,EAX
L49:
	LEA	ESP,DWORD [-12+EBP]
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
L56:
	MOVSX	EAX,BYTE [EBX]
	SAL	EAX,4
	INC	EBX
	ADD	EAX,_hankaku
	PUSH	EAX
	MOVZX	EAX,BYTE [-13+EBP]
	PUSH	EAX
	PUSH	DWORD [16+EBP]
	PUSH	ESI
	ADD	ESI,8
	PUSH	EDI
	CALL	_draw_font8
	ADD	ESP,20
	CMP	BYTE [EBX],0
	JNE	L56
	JMP	L58
L51:
	OR	EAX,-1
	JMP	L49
[SECTION .data]
_cursor:
	DB	"**************.."
	DB	"*OOOOOOOOOOO*..."
	DB	"*OOOOOOOOOO*...."
	DB	"*OOOOOOOOO*....."
	DB	"*OOOOOOOO*......"
	DB	"*OOOOOOO*......."
	DB	"*OOOOOOO*......."
	DB	"*OOOOOOOO*......"
	DB	"*OOOO**OOO*....."
	DB	"*OOO*..*OOO*...."
	DB	"*OO*....*OOO*..."
	DB	"*O*......*OOO*.."
	DB	"**........*OOO*."
	DB	"*..........*OOO*"
	DB	"............*OO*"
	DB	".............***"
[SECTION .text]
	GLOBAL	_init_mouse_cursor8
_init_mouse_cursor8:
	PUSH	EBP
	XOR	ECX,ECX
	MOV	EBP,ESP
	PUSH	EDI
	XOR	EDI,EDI
	PUSH	ESI
	XOR	ESI,ESI
	PUSH	EBX
	PUSH	EAX
	MOV	AL,BYTE [12+EBP]
	MOV	EBX,DWORD [8+EBP]
	MOV	BYTE [-13+EBP],AL
L71:
	LEA	EAX,DWORD [ESI+EDI*1]
	CMP	BYTE [_cursor+EAX],42
	JE	L77
L68:
	CMP	BYTE [_cursor+EAX],79
	JE	L78
L69:
	CMP	BYTE [_cursor+EAX],46
	JE	L79
L66:
	INC	ESI
	CMP	ESI,15
	JLE	L71
	INC	ECX
	ADD	EDI,16
	CMP	ECX,15
	JG	L80
	XOR	ESI,ESI
	JMP	L71
L80:
	POP	EAX
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
L79:
	MOV	DL,BYTE [-13+EBP]
	MOV	BYTE [EAX+EBX*1],DL
	JMP	L66
L78:
	MOV	BYTE [EAX+EBX*1],7
	JMP	L69
L77:
	MOV	BYTE [EAX+EBX*1],0
	JMP	L68
	GLOBAL	_draw_block8_8
_draw_block8_8:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EDI
	PUSH	ESI
	XOR	ESI,ESI
	PUSH	EBX
	SUB	ESP,20
	CALL	_get_vram_addr
	MOV	DWORD [-16+EBP],EAX
	CALL	_get_screen_width
	CMP	ESI,DWORD [12+EBP]
	MOV	DWORD [-20+EBP],EAX
	JGE	L93
	XOR	EDI,EDI
L91:
	XOR	EBX,EBX
	CMP	EBX,DWORD [8+EBP]
	JGE	L95
	MOV	EAX,DWORD [24+EBP]
	ADD	EAX,EDI
	MOV	DWORD [-28+EBP],EAX
L90:
	MOV	EAX,DWORD [20+EBP]
	MOV	EDX,DWORD [16+EBP]
	ADD	EAX,ESI
	ADD	EDX,EBX
	IMUL	EAX,DWORD [-20+EBP]
	ADD	EAX,EDX
	MOV	ECX,DWORD [-16+EBP]
	MOV	EDX,DWORD [-28+EBP]
	INC	EBX
	MOV	DL,BYTE [EDX]
	MOV	BYTE [EAX+ECX*1],DL
	INC	DWORD [-28+EBP]
	CMP	EBX,DWORD [8+EBP]
	JL	L90
L95:
	INC	ESI
	ADD	EDI,DWORD [28+EBP]
	CMP	ESI,DWORD [12+EBP]
	JL	L91
L93:
	ADD	ESP,20
	POP	EBX
	POP	ESI
	POP	EDI
	POP	EBP
	RET
[SECTION .data]
	ALIGNB	4
_vram_addr:
	RESB	4
[SECTION .data]
	ALIGNB	4
_scrn_xsize:
	RESB	4
