.486
DATA SEGMENT USE16
    MESG1 DB 'Please Enter A Number! ',0DH,0AH,'$'
    MESG2 DB '------Error ! $ '
DATA ENDS
CODE SEGMENT USE16
          ASSUME CS:CODE,DS:DATA
    BEG:  MOV    AX,DATA
          MOV    DS,AX
          MOV    AH,9
          MOV    DX,OFFSET MESG1
          INT    21H                ;显示操作提示
          MOV    AH,1
          INT    21H                ;等待键入
          CMP    AL,3AH
          JNC    ERROR              ;＞'9'转
          CMP    AL,30H
          JC     ERROR              ;＜'0'转
          SUB    AL,30H
          MOV    BL,AL              ;BL=0～9 的二进制数
          MOV    AH,2
          MOV    DL,'='
          INT    21H
          CALL   DISP
          MOV    AH,2
          MOV    DL,'B'
          INT    21H
          MOV    AH,2
          MOV    DL,0AH
          INT    21H
          MOV    AH,2
          MOV    DL,0DH
          INT    21H

          MOV    BL,2
          CALL   DISP

          JMP    EXIT
    ERROR:MOV    AH,9
          LEA    DX, MESG2
          INT    21H                ;显示错误信息
    EXIT: MOV    AH,4CH
          INT    21H
    ;---------------------------------
DISP PROC                           ;显示BL中的二进制数
          MOV    CX,8
    LAST: MOV    DL,'0'
          RCL    BL,1
          JNC    NEXT
          MOV    DL,'1'
    NEXT: MOV    AH,2
          INT    21H
          LOOP   LAST
          RET
DISP ENDP
CODE ENDS
	END BEG   
