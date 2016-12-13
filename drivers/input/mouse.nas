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
	MOV	DL,BYTE [_mouse_dec+3]
	MOV	EBP,ESP
	TEST	DL,DL
	PUSH	ESI
	PUSH	EBX
	MOV	CL,BYTE [12+EBP]
	MOV	EBX,DWORD [8+EBP]
	JNE	L3
	CMP	CL,-6
	JE	L13
L5:
	XOR	ESI,ESI
L2:
	POP	EBX
	MOV	EAX,ESI
	POP	ESI
	POP	EBP
	RET
L13:
	MOV	BYTE [_mouse_dec+3],1
	JMP	L5
L3:
	CMP	DL,1
	JE	L14
L6:
	MOVZX	EAX,DL
	CMP	DL,3
	MOV	BYTE [_mouse_dec-1+EAX],CL
	JE	L15
	LEA	EAX,DWORD [1+EDX]
	MOV	BYTE [_mouse_dec+3],AL
	JMP	L5
L15:
	MOV	BYTE [_mouse_dec+3],1
	TEST	EBX,EBX
	JE	L5
	MOV	AL,BYTE [_mouse_dec]
	AND	EAX,7
	MOVZX	EAX,AL
	MOV	DWORD [8+EBX],EAX
	MOVZX	EDX,BYTE [_mouse_dec+1]
	MOV	DWORD [EBX],EDX
	MOVZX	EAX,BYTE [_mouse_dec+2]
	MOV	DWORD [4+EBX],EAX
	MOV	AL,BYTE [_mouse_dec]
	AND	EAX,16
	TEST	AL,AL
	JE	L10
	OR	EDX,-256
	MOV	DWORD [EBX],EDX
L10:
	MOV	AL,BYTE [_mouse_dec]
	AND	EAX,32
	TEST	AL,AL
	JE	L11
	OR	DWORD [4+EBX],-256
L11:
	NEG	DWORD [4+EBX]
	MOV	ESI,1
	JMP	L2
L14:
	MOV	AL,CL
	XOR	ESI,ESI
	AND	EAX,1
	TEST	AL,AL
	JNE	L2
	JMP	L6
[SECTION .data]
	ALIGNB	4
_mouse_dec:
	RESB	4
