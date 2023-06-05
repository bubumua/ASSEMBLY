;屏幕显示4位的16进制数（要显示的放在DW里，用到EDX）
.486
DATA SEGMENT USE16
      BUF  DW 947AH      ;此处输入数据段代码
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
      START:
            MOV    AX,DATA
            MOV    DS,AX
            MOV    DX,BUF
            MOV    CX,4
            SAL    EDX,16
      AGA:  ROL    EDX,4
            AND    DL,0FH
            CMP    DL,10
            JC     NEXT
            ADD    DL,7
      NEXT: ADD    DL,30H
            MOV    AH,2
            INT    21H
            LOOP   AGA
            MOV    AH,4CH
            INT    21H
CODE ENDS
    END START