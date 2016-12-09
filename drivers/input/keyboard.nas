[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_inb
	EXTERN	_outb
[FILE "keyboard.c"]
[SECTION .text]
	GLOBAL	_irq_handler_keyboard
_irq_handler_keyboard:
	PUSH	EBP
	MOV	EBP,ESP
	POP	EBP
	RET
	GLOBAL	_wait_KBC_sendready
_wait_KBC_sendready:
	PUSH	EBP
	MOV	EBP,ESP
L3:
	PUSH	100
	CALL	_inb
	POP	EDX
	AND	EAX,2
	JNE	L3
	LEAVE
	RET
	GLOBAL	_init_keyboard
_init_keyboard:
	PUSH	EBP
	MOV	EBP,ESP
	CALL	_wait_KBC_sendready
	PUSH	96
	PUSH	100
	CALL	_outb
	CALL	_wait_KBC_sendready
	PUSH	71
	PUSH	96
	CALL	_outb
	LEAVE
	RET
