PDATA SEGMENT
    X       DB 10
    Y       DB 40
    CHRTAB  DW 5
            DB 01,0,0,0DBH,1,0,13H,1,0
            DB 2FH,-1,-1,5CH,0,2
    CHRTAB2 DW 5
            DB 00H,0,0,00H,1,0,00H,1,0
            DB 00H,-1,-1,00H,0,2
PDATA ENDS
;-------------------------------------
STACKS SEGMENT PARA STACK'STACK'
           DB 100 DUP(?)
STACKS ENDS
;-------------------------------------
CODES SEGMENT
            ASSUME CS:CODES,DS:PDATA,SS:STACKS
START PROC FAR
            PUSH   DS
            MOV    AX,0
            PUSH   AX
            MOV    AX,PDATA
            MOV    DS,AX
    ;-------------------------------------
            STI
            MOV    AL,02                          ;设置显示方式：80*25黑白
            MOV    AH,0
            INT    10H
    ;-------------------------------------
            MOV    DI,OFFSET CHRTAB
            MOV    CX,[DI]
            MOV    DH,X                           ;定参考点于X行Y列
            MOV    DL,Y
            ADD    DI,2
    ;-------------------------------------
    AGAIN:  
    NEXT:   
            ADD    DH,[DI+1]
            ADD    DL,[DI+2]
            MOV    AH,2                           ;显示字符图形
            INT    10H
            MOV    AL,[DI]
            PUSH   CX
            MOV    CX,1
            MOV    AH,10
            INT    10H
            POP    CX
            ADD    DI,3                           ;指向下一字符
            LOOP   NEXT
            CALL   SOFTDLY                        ;调用延时子程序
    ;-------------------------------------
            MOV    DI,OFFSET CHRTAB2
            MOV    CX,[DI]
            MOV    DH,X
            MOV    DL,Y
            ADD    DI,2
    NEXT2:                                        ;清除原图形
            ADD    DH,[DI+1]
            ADD    DL,[DI+2]
            MOV    AH,2
            INT    10H
            MOV    AL,[DI]
            PUSH   CX
            MOV    CX,1
            MOV    AH,10
            INT    10H
            POP    CX
            ADD    DI,3
            LOOP   NEXT2
    ;-------------------------------------
            INC    Y                              ;改变参考点，实现人像的移动
            MOV    DI,OFFSET CHRTAB
            MOV    CX,[DI]
            MOV    DH,X
            MOV    DL,Y
            ADD    DI,2
            JMP    AGAIN
            RET
START ENDP
    ;-------------------------------------
SOFTDLY PROC                                      ;定义延时子程序
            MOV    BL,100
    DELAY:  MOV    CX,2801
    WAITS:  LOOP   WAITS
            DEC    BL
            JNZ    DELAY
            RET
SOFTDLY ENDP
    ;-------------------------------------
CODES ENDS
    END START
