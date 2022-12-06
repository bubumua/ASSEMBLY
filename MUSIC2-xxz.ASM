		.486
DATAS SEGMENT USE16
	TABF  DW  441,443,525,589,742,-1,744,589	; 音符音高
	      DW  525,-1,525,589,525,525
	      DW  441,443,525,589,742,-1,744,589
	      DW  525,-1,525,589,525,525
	      DW  525,-1,523-1,521,441,525
	      DW  589,-1,591,525,525
	      DW  441,393,441,525,441,393
	      DW  350,-1,352,393,350,350
	      DW  441,393,350,441,393,441
	      DW  525,589,742,525,525
	      DW  393,441,525,393,441,350,294
	      DW  262,262,294,350
	      DW  393,441,350,393,350,294
	      DW  262
	TABT  DB  8,4,4,4,4,1,4,4               	; 音符时值倍率
	      DB  8,1,4,4,8,8
	      DB  8,4,4,4,4,4,4
	      DB  8,1,4,4,8,8
	      DB  8,1,8,1,8,4,4
	      DB  8,1,8,8,8
	      DB  8,4,4,8,4,4
	      DB  8,1,4,4,8,8
	      DB  4,4,4,4,12,4
	      DB  8,4,4,8,8
	      DB  8,4,4,4,4,4,4
	      DB  8,8,8,8
	      DB  12,4,4,4,4,4
	      DB  32
	N1    EQU 100
	N2    EQU 750                           	; 音符基础时值
DATAS ENDS

CODES SEGMENT  USE16
	      ASSUME CS:CODES,DS:DATAS
	START:
	      MOV    AX,DATAS
	      MOV    DS,AX
	OPEN: 
	      IN     AL,61H
	      OR     AL,03H
	      OUT    61H,AL           	;接通扬声器
	AGA:  
	      LEA    SI,TABF          	;SI是频率表指针
	      LEA    DI,TABT          	;DI是时间表指针
	LAST: 
	      CMP    WORD PTR [SI],0  	;判断是否唱完一遍
	      JE     AGA              	;若是,转移
	      MOV    DX,12H
	      MOV    AX,34DEH
	      DIV    WORD PTR [SI]    	;频率转换成计数初值
	      OUT    42H,AL           	;低8位送2号计数器
	      MOV    AL,AH
	      OUT    42H,AL           	;高8位送2号计数器
	      CALL   DELAY            	;延时
	      ADD    SI,2             	;频率表指针加2
	      INC    DI               	;时间表指针加1
	      MOV    AH,1
	      INT    16H              	;检测是否有键入
	      JZ     LAST             	;若没有,则跳转
	CLOSE:
	      IN     AL,61H
	      AND    AL,11111100B
	      OUT    61H,AL           	;关闭扬声器
	      MOV    AH,4CH
	      INT    21H
    	
DELAY PROC                    		;延时子程序
	      MOV    EAX,0
	      MOV    AL, [DI]
	      MOV    CL,N1
	      MUL    CL
	      MOV    CX,N2
	      MUL    CX
	      MOV    CX, DX
	      MOV    DX, AX
	      MOV    AH,86H
	      INT    15H
	      RET
DELAY ENDP
CODES ENDS
    END START



