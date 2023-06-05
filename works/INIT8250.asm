MOV	DX,3FBH		    ;置除数锁存器（分频系数）
MOV	AL,80H
OUT	DX,AL		    ; 通讯线路控制寄存器最高位置“1”
MOV	DX,3F8H
MOV	AL,0CH
OUT	DX,AL		    ; 除数低位送入 除数锁存器 LSB （低`8位）
MOV	DX,3F9H
MOV	AL,0		    ; 除数高位送入 除数锁存器 MSB （高`8位）
OUT	DX,AL
MOV	DX,3FBH		    ; 置通信线路控制寄存器（数据格式） 
MOV	AL,00001110B    ; 7 个字符位，2个停止位，奇校验
OUT	DX,AL
MOV	DX,3F9H		    ; 置中断允许寄存器
MOV	AL,0FH		    ; 允许所有中断
OUT	DX,AL
MOV	DX,3FCH		    ; 置MODEM控制器
MOV	AL,0BH		    ; 使 OUT2、DTR、RTS 有效
OUT	DX,AL

I8250	PROC
	; 置寻址位=1
 	MOV	DX ,	3FBH
    MOV	AL ,	80H
    OUT	DX ,	AL

	;置分频系数=0060H
    ;高8位
    MOV	DX ,	3F9H
    MOV	AL ,	0
    OUT	DX ,	AL
    ;低8位
    MOV	DX ,	3F8H
    MOV	AL ,	60H
    OUT	DX ,	AL

    ;定义一帧数据格式
	MOV	DX ,	3FBH
    MOV	AL ,	03H
    OUT	DX ,	AL

	;置中断允许寄存器
    MOV	DX ,	3F9H
    MOV	AL ,	0
    OUT	DX ,	AL

	;置MODEM控制寄存器
    MOV	DX ,	3FCH
    MOV	 AL ,	10H
    OUT	DX ,	AL

 	RET
I8250  	ENDP
