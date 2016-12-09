[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_wait_KBC_sendready
	EXTERN	_outb
[FILE "mouse.c"]
[SECTION .text]
	GLOBAL	_init_mouse
_init_mouse:
	PUSH	EBP
	MOV	EBP,ESP
	CALL	_wait_KBC_sendready
	PUSH	212
	PUSH	100
	CALL	_outb
	CALL	_wait_KBC_sendready
	PUSH	244
	PUSH	96
	CALL	_outb
	MOV	BYTE [_mouse_dec+3],0
	LEAVE
	RET
	GLOBAL	_mouse_decode
_mouse_decode:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	EBX
	SUB	ESP,32
	MOV	DL,BYTE [_mouse_dec+3]
	MOV	ECX,DWORD [8+EBP]
	MOV	EBX,DWORD [12+EBP]
	TEST	DL,DL
	JNE	L3
	CMP	BL,-6
	JE	L11
L5:
	XOR	EAX,EAX
L2:
	ADD	ESP,32
	POP	EBX
	POP	EBP
	RET
L11:
	MOV	BYTE [_mouse_dec+3],1
	JMP	L5
L3:
	MOVZX	EAX,DL
	CMP	DL,3
	MOV	BYTE [_mouse_dec-1+EAX],BL
	JE	L12
	LEA	EAX,DWORD [1+EDX]
	MOV	BYTE [_mouse_dec+3],AL
	JMP	L5
L12:
	MOV	BYTE [_mouse_dec+3],1
	TEST	ECX,ECX
	JE	L5
	MOV	AL,BYTE [_mouse_dec]
	AND	EAX,7
	MOVZX	EAX,AL
	MOV	DWORD [8+ECX],EAX
	MOVZX	EDX,BYTE [_mouse_dec+1]
	MOV	DWORD [ECX],EDX
	MOVZX	EAX,BYTE [_mouse_dec+2]
	MOV	DWORD [4+ECX],EAX
	MOV	AL,BYTE [_mouse_dec]
	AND	EAX,16
	TEST	AL,AL
	JE	L8
	OR	EDX,-256
	MOV	DWORD [ECX],EDX
L8:
	MOV	AL,BYTE [_mouse_dec]
	AND	EAX,32
	TEST	AL,AL
	JE	L9
	OR	DWORD [4+ECX],-256
L9:
	NEG	DWORD [4+ECX]
	MOV	EAX,1
	JMP	L2
[SECTION .data]
	ALIGNB	4
_mouse_dec:
	RESB	4
