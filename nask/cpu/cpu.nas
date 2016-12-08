;nask function

;TAB=4


[FORMAT "WCOFF"]    ;制作目标文件的模式
[INSTRSET "i486p"]  ;使用i486为止的指令
[BITS 32]           ;制作32位机器语言

;制作目标文件的信息

[FILE "naskcpu.nas"]    ;文件名

        GLOBAL  _cpu_hlt
        GLOBAL  _write_mem_8bits   ;程序中包含的函数名
        GLOBAL  _cpu_irq_disable, _cpu_irq_enable
        GLOBAL  _outb, _inb
        GLOBAL  _load_gdtr, _load_idtr ;设置段描述表和中断描述表

        GLOBAL  _io_cli, _io_sti, _io_load_eflags, _io_store_eflags     ;开关中断函数集
        GLOBAL  _asm_irq_handler1, _asm_irq_handler7, _asm_irq_handler12
        EXTERN  _irq_handler1, _irq_handler7, _irq_handler12        

;实际函数

[SECTION .text]     ;放入text段

_cpu_hlt: ;void cpu_hlt(void)
        HLT
        RET

_write_mem_8bits:      ;void write_mem_8bits(int addr, int val)
        MOV     ECX,[ESP+4]
        MOV     AL,[ESP+8]
        MOV     [ECX],AL
        RET
_outb:
        MOV     EDX,[ESP+4]
        MOV     AL,[ESP+8]
        OUT     DX,AL
        RET
_inb:
		MOV		EDX,[ESP+4]
		MOV		EAX,0
		IN		AL,DX
		RET
_cpu_irq_disable:
        PUSHFD  
        POP     EAX
        MOV     DWORD [_cpu_sr],EAX
        CLI
        RET
_cpu_irq_enable:
        MOV     EAX,[_cpu_sr]
        PUSH    EAX
        POPFD
        RET


_io_cli:
        CLI
        RET
_io_sti:
        STI
        RET
        
_io_load_eflags:
        PUSHFD
        POP     EAX
        RET
_io_store_eflags:
        MOV     EAX,[ESP+4]
        PUSH    EAX
        POPFD
        RET

_load_gdtr:     ;void load_gdtr(int limit, int addr)
        MOV     AX,[ESP+4]
        MOV     [ESP+6],AX
        LGDT    [ESP+6]
        RET
_load_idtr:     ;void load_idtr(int limit, int addr)
        MOV     AX,[ESP+4]
        MOV     [ESP+6],AX
        LIDT    [ESP+6]
        RET

_asm_irq_handler1:
        PUSH    ES
        PUSH    DS
        PUSHAD
        MOV     EAX,ESP
        PUSH    EAX
        MOV     AX,SS
        MOV     DS,AX
        MOV     ES,AX
        CALL    _irq_handler1
        POP     EAX
        POPAD
        POP     DS
        POP     ES
        IRETD

_asm_irq_handler7:
        PUSH    ES
        PUSH    DS
        PUSHAD
        MOV     EAX,ESP
        PUSH    EAX
        MOV     AX,SS
        MOV     DS,AX
        MOV     ES,AX
        CALL    _irq_handler7
        POP     EAX
        POPAD
        POP     DS
        POP     ES
        IRETD

_asm_irq_handler12:
        PUSH    ES
        PUSH    DS
        PUSHAD
        MOV     EAX,ESP
        PUSH    EAX
        MOV     AX,SS
        MOV     DS,AX
        MOV     ES,AX
        CALL    _irq_handler12
        POP     EAX
        POPAD
        POP     DS
        POP     ES
        IRETD


[SECTION .data]
        ALIGNB  4
_cpu_sr:
        RESB    4
