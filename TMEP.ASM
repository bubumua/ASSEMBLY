MOV AL,10000100B        ;计数器2号的锁存命令
OUT 43H,AL              ;写入控制字寄存器
IN AL,42H               ;读低8位
MOV CL,AL               ;存于CL中
IN AL,42H               ;读高8位
MOV CH,AL               ;存于CH中

;假设微机系统外扩了如下的一个‘单脉冲发生器’，该‘单脉冲发生器’电路受一个自复开关K的控制，每按一次K，该电路输出一个正脉冲，输入到系统机从8259的IR1作为外部中断请求。
;要求：每按一次K，屏幕上显示一行字符串“Welcome!”。主机键盘按任意键，程序结束，返回DOS。
;编写开放8259和中断向量置换程序

;中断向量置换程序
WR PROC
    PUSH DS
    MOV AX,CODE
    MOV DS,AX
    MOV DX, OFFSET SERVICE
    MOV AX,250AH
    INT 21H
    POP DS
    RET
WR ENDP

;开放8259A（即确保未屏蔽响应中断）
OPEN PROC
    IN AL,21H
    AND AL,11111011B
    OUT 21H,AL
    IN AL,0A1H
    AND AL,11111101B
    OUT 0A1H,AL
    RET
OPEN ENDP
    
