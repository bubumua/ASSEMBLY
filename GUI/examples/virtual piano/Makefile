NAME = sound
OBJS = $(NAME).obj
RES  = $(NAME).res

LINK_FLAG = /subsystem:windows
ML_FLAG = /c /coff

$(NAME).exe: $(OBJS) $(RES)
	link $(LINK_FLAG) $(OBJS) $(RES)
.asm.obj:
	ml $(ML_FLAG) $<
.re.res:
	rc $<

clean:
	del *.obj
	del *.res
