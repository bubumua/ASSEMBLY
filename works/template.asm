.486
DATA SEGMENT USE16
    ;此处输入数据段代码
DATA ENDS

STACK SEGMENT USE16
    ;此处输入堆栈段代码
STACK ENDS

CODE SEGMENT USE16
          ASSUME CS:CODE,DS:DATA,SS:STACK
    START:
          MOV    AX,DATA
          MOV    DS,AX
    ;此处输入代码段代码
          MOV    AH,4CH
          INT    21H
CODE ENDS
    END START