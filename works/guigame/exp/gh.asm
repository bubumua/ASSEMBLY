SECTION  core  vstart=0x0
     [bits 32]
 
     show_caller    dd 0x0                   ;偏移（不用）
                    dw 0x0                   ;选择子
     back_caller    dd 0x0                   ;偏移（不用）
                    dw 0x0                   ;选择子
     rect_caller    dd 0x0                   ;偏移（不用）
                    dw 0x0                   ;选择子
     cmd_caller     dd 0x0                   ;偏移（不用）
                    dw 0x0                   ;选择子
 
     ;rect_caller的输入参数是:
     ;EAX-低16位为Y值，高16位为Y的高度
     ;EBX-低16位为X值，高16位为X的宽度
     ;CL=颜色
     mov cl, [_color]
     mov eax, 0x640064
     mov ebx, 0xa000a0
_draw_rectangle:
     call far [rect_caller]
     mov edx, eax
     shr edx, 16
     sub edx, 8
     shl edx, 16
     and eax, 0xffff
     add eax, 4
     or eax, edx	 
 
     mov edx, ebx
     shr edx, 16
     sub edx, 8
     shl edx, 16
     and ebx, 0xffff
     add ebx, 4
     or ebx, edx
	 
	 inc cl
     cmp cl, 14
     jb _next_rectangle
     mov cl, 1
     mov eax, 0x640064
     mov ebx, 0xa000a0	 
_next_rectangle:
     push eax
     mov eax, 16                              ;休眠160毫秒
     call far [back_caller]
     pop eax
	 
     push eax
     call far [cmd_caller]
     cmp al, 0x55
     jnz _go_on
     pop eax
     mov cl, 1
     mov eax, 0x640064
     mov ebx, 0xa000a0
     jmp _draw_rectangle
_go_on:	 
	 pop eax
     jmp _draw_rectangle
	 
;-------------------------------------------------------------------------------
	 
 
;-------------------------------------------------------------------------------	 
     _color  db 1,0,0,0
     _x_	 dd 160                           ;x坐标
     _y_     dd 100		                      ;y坐标
     _cmd    db 0,0,0,0
	 
;-------------------------------------------------------------------------------
SECTION core_trail
;-------------------------------------------------------------------------------
core_end:
