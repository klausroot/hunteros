; hunteros-ipl
; TAB=4

CYLS	EQU		10				; ����CYLS=10

		ORG		0x7c00			; ָ������װ�ص�ַ

; ��׼FAT12��ʽ����ר�õĴ��� Stand FAT12 format floppy code

		JMP		entry
		DB		0x90
		DB		"HUNTERBT"		; �����������ƣ�8�ֽڣ�
		DW		512				; ÿ��������sector����С������512�ֽڣ�
		DB		1				; �أ�cluster����С������Ϊ1��������
		DW		1				; FAT��ʼλ�ã�һ��Ϊ��һ��������
		DB		2				; FAT����������Ϊ2��
		DW		224				; ��Ŀ¼��С��һ��Ϊ224�
		DW		2880			; �ô��̴�С������Ϊ2880����1440*1024/512��
		DB		0xf0			; �������ͣ�����Ϊ0xf0��
		DW		9				; FAT�ĳ��ȣ���??9������
		DW		18				; һ���ŵ���track���м�������������Ϊ18��
		DW		2				; ��ͷ������??2��
		DD		0				; ��ʹ�÷�����������0
		DD		2880			; ��дһ�δ��̴�С
		DB		0,0,0x29		; ���岻�����̶���
		DD		0xffffffff		; �������ǣ�������
		DB		"HUNTEROS   "	; ���̵����ƣ�����Ϊ11��?��������ո�
		DB		"FAT12   "		; ���̸�ʽ���ƣ���??8��?��������ո�
		RESB	18				; �ȿճ�18�ֽ�

; ��������

entry:
		MOV		AX,0			; ��ʼ���Ĵ���
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

; ��ȡ����

		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0			; ����0
		MOV		DH,0			; ��ͷ0
		MOV		CL,2			; ����2

readloop:
		MOV		SI,0			; ��¼ʧ�ܴ����Ĵ���

retry:
		MOV		AH,0x02			; AH=0x02 : �������
		MOV		AL,1			; 1������
		MOV		BX,0
		MOV		DL,0x00			; A������
		INT		0x13			; ���ô���BIOS
		JNC		next			; û��������ת��fin
		ADD		SI,1			; ��SI��1
		CMP		SI,5			; �Ƚ�SI��5
		JAE		error			; SI >= 5 ��ת��error
		MOV		AH,0x00
		MOV		DL,0x00			; A������
		INT		0x13			; ����������
		JMP		retry
next:
		MOV		AX,ES			; ���ڴ��ַ����0x200��512/16ʮ������ת����
		ADD		AX,0x0020
		MOV		ES,AX			; ADD ES,0x020��Ϊû��ADD ES��ֻ��ͨ��AX����
		ADD		CL,1			; ��CL�����1
		CMP		CL,18			; �Ƚ�CL��18
		JBE		readloop		; CL <= 18 ��ת��readloop
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop		; DH < 2 ��ת��readloop
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; CH < CYLS ��ת��readloop

; ��ȡ��ϣ���ת��hunteros.sysִ�У�
		MOV		[0x0ff0],CH		; IPL���ɤ��ޤ��i����Τ�����
		JMP		0xc200

error:
		MOV		SI,msg

putloop:
		MOV		AL,[SI]
		ADD		SI,1			; ��SI��1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			; ��ʾһ������
		MOV		BX,15			; ָ���ַ���ɫ
		INT		0x10			; �����Կ�BIOS
		JMP		putloop

fin:
		HLT						; ��CPUֹͣ���ȴ�ָ��
		JMP		fin				; ����ѭ��

msg:
		DB		0x0a, 0x0a		; ��������
		DB		"load error"
		DB		0x0a			; ����
		DB		0

		RESB	0x7dfe-$		; ��д0x00ֱ��0x001fe

		DB		0x55, 0xaa
