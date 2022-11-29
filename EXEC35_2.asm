.486
DATA SEGMENT USE16
    STRING DB 'COMPUTER','$'
DATA ENDS

CODE SEGMENT USE16
          ASSUME CS:CODE,DS:DATA
    START:
          MOV    AX,DATA
          MOV    DS,AX
          MOV    BX,OFFSET STRING
    LOP:  MOV    DL,[BX]
          MOV    AH,2
          INT    21H
          INC    BX
          CMP    BYTE PTR [BX],'$'    ;另一种写法: CMP    BX,OFFSET STRING+8
          JNE    LOP
          MOV    AH,4CH
          INT    21H
CODE ENDS
    END START