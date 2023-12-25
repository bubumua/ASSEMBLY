;FILENAME EXA131.ASM]
.486
DATA SEGMENT USE16
    BUF  DB  '1A35U6T7S8W5Z8PBDC'
    SIZ  EQU $-OFFSET BUF
    TMP  DB  0
DATA ENDS

CODE SEGMENT USE16
         ASSUME CS:CODE,DS:DATA
    BEG: 
         MOV    AX,DATA
         MOV    DS,AX
         LEA    BX,BUF
         MOV    AL,0                 ;TARGET NUMBER
         MOV    CX,SIZ
    AGA: 
         CMP    BYTE PTR [BX],42H
         JC     GOON
         CMP    BYTE PTR [BX],45H
         JA     GOON
         INC    AL
    GOON:
         INC    BX
         SUB    CX,1
         JA     AGA
         MOV    CX,8
         MOV    BL,AL
    ROA: 
         MOV    DL,'1'
         SHL    BL,1
         JC     SONE
         MOV    DL,'0'
    SONE:
         MOV    AH,02H
         INT    21H
         SUB    CX,1
         JA     ROA
         MOV    DL,'B'
         MOV    AH,02H
         INT    21H
    
         MOV    AH,4CH
         INT    21H

CODE ENDS
    END BEG
