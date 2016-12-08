[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_fifo_head
[FILE "fifo.c"]
[SECTION .data]
	ALIGNB	4
_fifo_head:
	DD	_fifo_head
	DD	_fifo_head
[SECTION .text]
	GLOBAL	_put_bdata_fifo
_put_bdata_fifo:
	PUSH	EBP
	MOV	EBP,ESP
	POP	EBP
	RET
	GLOBAL	_get_bdata_fifo
_get_bdata_fifo:
	PUSH	EBP
	MOV	EBP,ESP
	XOR	EAX,EAX
	POP	EBP
	RET
	GLOBAL	_put_wdata_fifo
_put_wdata_fifo:
	PUSH	EBP
	MOV	EBP,ESP
	POP	EBP
	RET
	GLOBAL	_put_dwdata_fifo
_put_dwdata_fifo:
	PUSH	EBP
	MOV	EBP,ESP
	POP	EBP
	RET
	GLOBAL	_register_fifo
_register_fifo:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	ESI
	PUSH	EBX
	MOV	ESI,DWORD [8+EBP]
	TEST	ESI,ESI
	JE	L24
	MOV	ECX,DWORD [72+EAX]
	LEA	EBX,DWORD [-72+ECX]
	LEA	EAX,DWORD [72+ESI]
	MOV	EDX,DWORD [72+EBX]
	MOV	DWORD [72+ESI],EDX
	MOV	DWORD [72+EBX],EAX
	MOV	DWORD [4+EDX],EAX
	MOV	DWORD [4+EAX],ECX
	XOR	EAX,EAX
L23:
	POP	EBX
	POP	ESI
	POP	EBP
	RET
L24:
	OR	EAX,-1
	JMP	L23
