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
          LOOP   AGA                ;结果为321 —— 说明先判断CX>0，若真，则DEC CX，然后跳转；若假，跳出循环
          MOV    AH,4CH
          INT    21H
CODE ENDS
    END START