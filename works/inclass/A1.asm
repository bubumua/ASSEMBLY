.586
DATAS SEGMENT USE16
    BUF   DB 'HELLO WORLD!','$'
DATAS ENDS

CODES SEGMENT USE16
          ASSUME CS:CODES,DS:DATAS
    START:
          MOV    AX,DATAS
          MOV    DS,AX
          MOV    AH,9
          LEA    DX,BUF
          INT    21H
          MOV    AH,4CH
          INT    21H
CODES ENDS
    END START
