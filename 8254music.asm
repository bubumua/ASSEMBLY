.486
DATAS SEGMENT USE16
	TABF  DW  -1,262,350,352,350,441,393,350,393,441
	      DW  350,352,441,525,589,588,589,525,441
	      DW  440,350,393,350,393,441,350,293,294,262
	      DW  350,589,525,441,440,350,393,350,393,589
	      DW  525,441,440,525,589,700,525,441,440,350
	      DW  393,350,393,441,350,294,292,262,350,0
	TABT  DB  4,4,6,2,4,4,6,2,4,4
	      DB  6,2,4,4,12,1,3,6,2
	      DB  4,4,6,2,4,4,6,2,4,4
	      DB  12,4,6,2,4,4,6,2,4,4
	      DB  6,2,4,4,12,4,6,2,4,4
	      DB  6,2,4,4,6,2,4,4,12
	N     EQU 150000
	TTT   DW  0                                      	;此处输入数据段代码
DATAS ENDS


CODES SEGMENT  USE16
	      ASSUME CS:CODES,DS:DATAS
	START:
	      MOV    AX,DATAS
	      MOV    DS,AX
	OPEN: IN     AL,61H
	      OR     AL,03H
	      OUT    61H,AL
	AGA:  LEA    SI,TABF
	      LEA    DI,TABT
	LAST: CMP    WORD PTR [SI],0
	      JE     AGA
	      MOV    DX,12H
	      MOV    AX,34DEH
	      DIV    WORD PTR [SI]
	      OUT    42H,AL
	      MOV    AL,AH
	      OUT    42H,AL
	      CALL   DELAY
	      ADD    SI,2
	      INC    DI
	      MOV    AH,1
	      INT    16H
	      JZ     LAST
	CLOSE:IN     AL,61H
	      AND    AL,11111100B
	      OUT    61H,AL
	      MOV    AH,4CH
	      INT    21H
    	
DELAY PROC
	      MOV    EAX,0
	      MOV    AL,[DI]
	      IMUL   EAX,EAX,N
	      MOV    DX,AX
	      ROL    EAX,16
	      MOV    CX,AX
	      MOV    AH,86H
	      INT    15H
	      RET

DELAY ENDP
CODES ENDS
    END START


