.486
DATA SEGMENT USE16
    MESG   DB 'HELLO!',0DH,0AH,'$'    ;定义要输出的语句
    OLD1C  DD ?
    ICOUNT DB 18                      ;计时计数器
    COUNT  DB 10                      ;行数计数器
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
    START:  
            MOV    AX,DATA
            MOV    DS,AX
            CLI                           ;禁止中断
            CALL   READ1C                 ;利用35号子功能读原1C
            CALL   WRITE1C                ;利用25号子功能写1C
            STI                           ;恢复中断
    SCAN:   
            CMP    COUNT,0                ;检查输出行数是否达到预设
            JNZ    SCAN                   ;若达到，则恢复1C；否则再此检查
            CLI
            CALL   RESET
            STI
            MOV    AH,4CH
            INT    21H
    
SERVICE PROC                              ;DEFINE SERVICE
            PUSHA
            PUSH   DS
            MOV    AX,DATA
            MOV    DS,AX
            DEC    ICOUNT
            JNZ    EXIT                   ;未到1s就跳过
            MOV    ICOUNT,18
            DEC    COUNT
            MOV    AH,9                   ;输出一行字符串
            LEA    DX,MESG
            INT    21H
    EXIT:   
            POP    DS
            POPA
            IRET
SERVICE ENDP
   
RESET PROC                                ;RESET 1CH
            MOV    DX,WORD PTR OLD1C
            MOV    DS,WORD PTR OLD1C+2
            MOV    AX,251CH
            INT    21H
            RET
RESET ENDP
    
WRITE1C PROC                              ;WRITE 1C
            PUSH   DS
            MOV    AX,CODE
            MOV    DS,AX
            MOV    DX,OFFSET SERVICE
            MOV    AX,251CH
            INT    21H
            POP    DS
            RET
WRITE1C ENDP
    
READ1C PROC                               ;READ 1C
            MOV    AX,351CH
            INT    21H
            MOV    WORD PTR OLD1C,BX
            MOV    WORD PTR OLD1C+2,ES
            RET
READ1C ENDP
CODE ENDS
    END START