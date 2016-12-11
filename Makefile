TOOLPATH = ./tolset/z_tools/
INCPATH  = ./tolset/z_tools/hunteros/
ROOT	 = .


CC		 = gcc
MAKE     = $(TOOLPATH)make.exe -r
NASK     = $(TOOLPATH)nask.exe
CC1      = $(TOOLPATH)cc1.exe #-I$(INCPATH) -Icpu/asm/cpu.h -Os -Wall -quiet
GAS2NASK = $(TOOLPATH)gas2nask.exe -a
MAKEFONT = $(TOOLPATH)makefont.exe
BIN2OBJ  = $(TOOLPATH)bin2obj.exe
OBJ2BIM  = $(TOOLPATH)obj2bim.exe
BIM2HRB  = $(TOOLPATH)bim2hrb.exe
RULEFILE = $(TOOLPATH)hunteros/hunteros.rule
EDIMG    = $(TOOLPATH)edimg.exe
IMGTOL   = $(TOOLPATH)imgtol.com
COPY     = cp
DEL      = rm

# 默认动作

#C to OBJ
OBJS = $(ROOT)/boot/bootpack.obj \
	   $(ROOT)/graphics/graphics.obj \
	   $(ROOT)/cpu/dsctbl.obj \
	   $(ROOT)/cpu/irq.obj \
	   $(ROOT)/cpu/mm/memtest.obj \
	   $(ROOT)/system/fifo.obj \
	   $(ROOT)/drivers/input/keyboard.obj \
	   $(ROOT)/drivers/input/mouse.obj \

#NASK to OBJ
OBJ_BS = $(ROOT)/nask/cpu/cpu.obj \

#NASK to BIN
OBJ_LS = $(ROOT)/nask/ipl/ipl10.bin	\
$(ROOT)/nask/cpu/asmhead.bin	\

OBJ_FONT = $(ROOT)/font/hankaku.obj \

INCLUDES = \
-I$(INCPATH) \
-I$(ROOT)/includes/cpu/x86	\
-I$(ROOT)/cpu \
-I$(ROOT)/graphics \
-I$(ROOT)/includes \
-I$(ROOT)/drivers \

CC_ARGS	= \
-Os	\
-Wall	\
-quiet	\


include $(ROOT)/rule.mk

default :
	$(MAKE) img

# 镜像文件生成


#ipl10.bin : ipl10.nas Makefile
#	$(NASK) ipl10.nas ipl10.bin ipl10.lst

#asmhead.bin : asmhead.nas Makefile
#	$(NASK) asmhead.nas asmhead.bin asmhead.lst

#bootpack.gas : bootpack.c Makefile
#	$(CC1) $(INCLUDES) $(CC_ARGS) -o bootpack.gas bootpack.c

#bootpack.nas : bootpack.gas Makefile
#	$(GAS2NASK) bootpack.gas bootpack.nas

#bootpack.obj : bootpack.nas Makefile
#	$(NASK) bootpack.nas bootpack.obj bootpack.lst

#naskcpu.obj : naskcpu.nas Makefile
#	$(NASK)	naskcpu.nas naskcpu.obj naskcpu.lst

bootpack.bim : $(OBJS) $(OBJ_BS) $(OBJ_FONT) Makefile
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k map:bootpack.map \
		$(OBJS) $(OBJ_BS) $(OBJ_FONT)
# 3MB+64KB=3136KB

bootpack.hrb : bootpack.bim Makefile
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

hunteros.bin : $(ROOT)/nask/cpu/asmhead.bin bootpack.hrb Makefile
	cat $(ROOT)/nask/cpu/asmhead.bin bootpack.hrb > hunteros.bin 

hunteros.img : $(ROOT)/nask/ipl/ipl10.bin hunteros.bin Makefile
	$(EDIMG)   imgin:$(TOOLPATH)fdimg0at.tek \
		wbinimg src:$(ROOT)/nask/ipl/ipl10.bin len:512 from:0 to:0 \
		copy from:hunteros.bin to:@: \
		imgout:hunteros.img

# 其他指令

run :
	$(MAKE) img
	$(COPY) hunteros.img ..\tolset\z_tools\qemu\fdimage0.bin
	$(MAKE) -C ../tolset/z_tools/qemu

install :
	$(MAKE) img
	$(IMGTOL) w a: hunteros.img

img :
	$(MAKE) hunteros.img
#clean :
#	-$(DEL) *.bin
#	-$(DEL) *.lst
#	-$(DEL) *.gas
#	-$(DEL) *.obj
#	-$(DEL) bootpack.nas
#	-$(DEL) bootpack.map
#	-$(DEL) bootpack.bim
#	-$(DEL) bootpack.hrb
#	-$(DEL) hunteros.bin

src_only :
	$(MAKE) clean
	-$(DEL) hunteros.img
