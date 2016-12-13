[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_io_load_eflags
	EXTERN	_io_store_eflags
	EXTERN	_load_cr0
	EXTERN	_store_cr0
[FILE "memtest.c"]
[SECTION .text]
	GLOBAL	_mem_test_sub
_mem_test_sub:
	PUSH	EBP
	MOV	EBP,ESP
	MOV	EDX,DWORD [12+EBP]
	MOV	EAX,DWORD [8+EBP]
	CMP	EAX,EDX
	JA	L11
L9:
	ADD	EAX,4
	CMP	EAX,EDX
	JBE	L9
L11:
L7:
	POP	EBP
	RET
	GLOBAL	_mem_test
_mem_test:
	PUSH	EBP
	MOV	EBP,ESP
	PUSH	ESI
	PUSH	EBX
	XOR	ESI,ESI
	CALL	_io_load_eflags
	OR	EAX,262144
	PUSH	EAX
	CALL	_io_store_eflags
	CALL	_io_load_eflags
	POP	EDX
	TEST	EAX,262144
	JE	L13
	MOV	ESI,1
L13:
	AND	EAX,-262145
	PUSH	EAX
	CALL	_io_store_eflags
	POP	EAX
	MOV	EAX,ESI
	TEST	AL,AL
	JNE	L16
L14:
	PUSH	DWORD [12+EBP]
	PUSH	DWORD [8+EBP]
	CALL	_mem_test_sub
	POP	EDX
	MOV	EBX,EAX
	POP	ECX
	MOV	EAX,ESI
	TEST	AL,AL
	JNE	L17
L15:
	LEA	ESP,DWORD [-8+EBP]
	MOV	EAX,EBX
	POP	EBX
	POP	ESI
	POP	EBP
	RET
L17:
	CALL	_load_cr0
	AND	EAX,-1610612737
	PUSH	EAX
	CALL	_store_cr0
	POP	EAX
	JMP	L15
L16:
	CALL	_load_cr0
	OR	EAX,1610612736
	PUSH	EAX
	CALL	_store_cr0
	POP	EBX
	JMP	L14
