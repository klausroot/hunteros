deps = $(OBJS:.obj=.d)
deps += $(OBJ_BS:.obj=.d)
deps += $(OBJ_LS:.bin=.d)

.PHONY: out clean
 
 
out: object 
 
 
object: $(OBJ_LS) $(OBJ_BS) $(OBJS) $(OBJ_FONT) 

$(OBJ_LS):%.bin:%.nas
	@$(NASK) $< $@ $(@:.bin=.lst)
 
$(OBJ_BS):%.obj:%.nas
	@$(NASK) $< $@ $(@:.obj=.lst)


$(OBJS):%.obj:%.c
	@$(CC) -MM $(INCLUDES) $< > $(@:.obj=.d.1) &&	\
	if [ -s "$(@:.obj=.d.1)"]; then	\
	echo -n $(dir $@) > $(@:.obj=.d);	\
	cat $(@:.obj=.d.1) >> $(@:.obj=.d);	\
	echo >> $(@:.obj=.d);	\
	fi
	rm $(@:.obj=.d.1)
	$(CC1) $(INCLUDES) $(CC_ARGS) $< -o $(@:.obj=.gas)
	$(GAS2NASK) $(@:.obj=.gas) $(@:.obj=.nas)
	$(NASK) $(@:.obj=.nas) $@ $(@:.obj=.lst)

$(OBJ_FONT):%.obj:%.txt
	@$(MAKEFONT) $< $(@:.obj=.bin)
	$(BIN2OBJ) $(@:.obj=.bin) $@ _$(basename $(notdir $@))  

# $@--��ʾĿ���ļ�(�ַ���)
# $^--��ʾ���������ļ�
# $<--��ʾ��һ�������ļ�
# $?--��ʾ��Ŀ���ļ���Ҫ�µ������ļ��б�
# $(@:.obj=.nas) ��.obj�滻��.nas
#
clean:
	find . -name "*.d" -delete
	find . -name "*.d.1" -delete
	find . -name "*.obj" -delete
	find . -name "*.gas" -delete
	find . -name "*.lst" -delete
	find . -name "*.bin" -delete
 
 
-include $(deps)

