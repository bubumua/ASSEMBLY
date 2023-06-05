.486
DATA SEGMENT USE16
    MESG  DB 1,'A',0DH,0AH,'$'
    OLD1C DD 0

DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    START:  
            MOV    AX,DATA
            MOV    DS,AX
            CLI
            CALL   READ1C
            CALL   WRITE1C
            STI
    SCAN:   MOV    AH,1
            INT    16H
            JZ     SCAN
            CLI
            CALL   RESET
            STI
            MOV    BL,MESG
            CALL   SHOW8
            MOV    AH,4CH
            INT    21H
    ;SHOW MESG
SHOW8 PROC
            MOV    CX,8
    AGA:    
            MOV    DL,30H
            ROL    BL,1
            JNC    OUTPUT
            MOV    DL,31H
    OUTPUT: 
            MOV    AH,02H
            INT    21H
            LOOP   AGA
            MOV    AH,2
            MOV    DL,0DH
            INT    21H
            MOV    AH,2
            MOV    DL,0AH
            INT    21H

            RET
SHOW8 ENDP
    ;DEFINE SERVICE
SERVICE PROC
            PUSHA
            PUSH   DS
            MOV    AX,DATA
            MOV    DS,AX
            INC    MESG
            MOV    BL,MESG
            CALL   SHOW8
    EXIT:   
            POP    DS
            POPA
            IRET
SERVICE ENDP
    ;RESET 1CH
RESET PROC
            MOV    DX,WORD PTR OLD1C
            MOV    DS,WORD PTR OLD1C+2
            MOV    AX,251CH
            INT    21H
            RET
RESET ENDP
    ;SET MASK
I8259A PROC
            IN     AL,21H
            AND    AL,11111110B
            OUT    21H,AL
            RET
I8259A ENDP
    ;WRITE 1C
WRITE1C PROC
            PUSH   DS
            MOV    AX,CODE
            MOV    DS,AX
            MOV    DX,OFFSET SERVICE
            MOV    AX,251CH
            INT    21H
            POP    DS
            RET
WRITE1C ENDP
    ;READ 1C
READ1C PROC
            MOV    AX,351CH
            INT    21H
            MOV    WORD PTR OLD1C,BX
            MOV    WORD PTR OLD1C+2,ES
            RET
READ1C ENDP
CODE ENDS
    END START