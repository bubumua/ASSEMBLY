.486
DATA SEGMENT USE16
    MESG   DB 'HELLO!',0DH,0AH,'$'
    OLD1C  DD ?
    ICOUNT DB 18
    COUNT  DB 10
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
    SCAN:   
            CMP    COUNT,0
            JNZ    SCAN
            CLI
            CALL   RESET
            STI
            MOV    AH,4CH
            INT    21H
    ;SHOW MESG
SHOW8 PROC
            MOV    CX,8
            MOV    BL,MESG
            MOV    DL,31H
    AGA:    
            ROL    BL,1
            JC     OUTPUT
            MOV    DL,30H
    OUTPUT: 
            MOV    AH,02H
            INT    21H
            LOOP   AGA
            RET
SHOW8 ENDP
    ;DEFINE SERVICE
SERVICE PROC
            PUSHA
            PUSH   DS
            MOV    AX,DATA
            MOV    DS,AX
            DEC    ICOUNT
            JNZ    EXIT
            MOV    ICOUNT,18
            DEC    COUNT
            MOV    AH,9
            LEA    DX,MESG
            INT    21H
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