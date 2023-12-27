.486
DATA SEGMENT USE16
    TIP  DB 'INPUT THE MESSAGE(30 CHARS AT MOST)',0AH,0DH,'$'
    RST  DB 'The received characters are: $'
    NL   DB 0AH, 0DH,'$'
    BUF  DB 30
         DB ?
         DB 30 DUP(?)
DATA ENDS

CODE SEGMENT USE16
           ASSUME CS:CODE,DS:DATA
    START: 
           MOV    AX,DATA
           MOV    DS,AX
           CALL   I8250
    ;输出提示语句
           MOV    AH,9
           LEA    DX,TIP
           INT    21H
    ;接收输入的文本
           MOV    AH,0AH
           MOV    DX,OFFSET BUF
           INT    21H
    ;获取实际键入的字符个数于BX
           MOV    BL,BUF+1
           MOV    BH,0
    ;用 ‘$’作为串结束符
           MOV    SI,OFFSET BUF+2
           MOV    BYTE PTR[BX+SI],'$'
    ;光标下移一行
           MOV    AH,2
           MOV    DL,0AH
           INT    21H
    ;将字符个数给CX
           MOV    CX,BX
    ;将字符串首地址给BX
           MOV    BX,OFFSET BUF+2
    ;输出接收提示语句
           MOV    AH,9
           LEA    DX,RST
           INT    21H
    SCANSD:
           MOV    DX,3FDH
           IN     AL,DX                  ;读取通信线状态寄存器
           TEST   AL,20H                 ;测试D5位是否为1，为1表示可以发送消息
           JZ     SCANSD                 ;反复检查是否可以发送消息
    ;写入要发送的数据
           MOV    DX,3F8H
           MOV    AL,[BX]
           OUT    DX,AL
           INC    BX
    SCANRC:
           MOV    DX,3FDH                ;测试是否能接收数据
           IN     AL,DX
           TEST   AL,01H
           JZ     SCANRC
    ;取出接收的数据
           MOV    DX,3F8H                ;读取接收缓冲器
           IN     AL,DX
           AND    AL,7FH                 ;因为接收ASCII码，所以将最高位清零
    ;输出接收到的字符
           MOV    DL,AL
           MOV    AH,2
           INT    21H
           LOOP   SCANSD
    NEXT:  
           MOV    DX,3FDH
           IN     AL,DX
           TEST   AL,40H                 ;测试D6位是否为1，为1表示发送完毕
           JZ     NEXT                   ;反复检查是否发送完毕
    ;换行
           MOV    AH,9
           LEA    DX,NL
           INT    21H

           MOV    AH,4CH
           INT    21H
          
I8250 PROC
    ; 置寻址位=1
           MOV    DX ,	3FBH
           MOV    AL ,	80H
           OUT    DX ,	AL

    ;置分频系数=0060H
    ;高8位
           MOV    DX ,	3F9H
           MOV    AL ,	0
           OUT    DX ,	AL
    ;低8位
           MOV    DX ,	3F8H
           MOV    AL ,	60H
           OUT    DX ,	AL

    ;定义一帧数据格式
           MOV    DX ,	3FBH
           MOV    AL ,	03H
           OUT    DX ,	AL

    ;置中断允许寄存器
           MOV    DX ,	3F9H
           MOV    AL ,	0
           OUT    DX ,	AL

    ;置MODEM控制寄存器
           MOV    DX ,	3FCH
           MOV    AL ,	10H
           OUT    DX ,	AL

           RET
I8250 ENDP
CODE ENDS
    END START