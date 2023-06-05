.486
DATA SEGMENT USE16
    MESG  DB 16
    OLD1C DD 0

DATA ENDS

CODE SEGMENT USE16
          ASSUME CS:CODE,DS:DATA
    START:
          MOV    AX,DATA
          MOV    DS,AX
         
          MOV    BL,2
          MOV    DL,30H
          MOV    CX,4
    ; AGA:
    ;        SAL    BL,1
    ;        JNC    OUTPUT
    ;        MOV    DL,31H
    ; OUTPUT:
    ;        MOV    AH,02H
    ;        INT    21H
    ;        LOOP   AGA
          CALL   DISP
    ED:   
          MOV    AH,4CH
          INT    21H
DISP PROC                           ;显示BL中的二进制数
          MOV    CX,8
    LAST: 
          MOV    DL,'0'
          RCL    BL,1
          JNC    NEXT
          MOV    DL,'1'
    NEXT: 
          MOV    AH,2
          INT    21H
          LOOP   LAST
          RET
DISP ENDP
CODE ENDS
    END START