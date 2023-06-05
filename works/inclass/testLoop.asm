;验证LOOP的循环逻辑
.486
DATA SEGMENT USE16
    ;此处输入数据段代码
DATA ENDS

CODE SEGMENT USE16
          ASSUME CS:CODE,DS:DATA
    START:
          MOV    AX,DATA
          MOV    DS,AX
          MOV    CX,3
    AGA:  MOV    DL,CL
          ADD    DL,30H
          MOV    AH,2
          INT    21H
          LOOP   AGA
          MOV    AH,4CH
          INT    21H
CODE ENDS
    END START