;统计BUF单元开始的一串字符串中数字的个数（0-9），并以二进制显示在屏幕上
.486
DATA SEGMENT USE16
      BUF  DB  '2018@NJUPT2020'
      LEN  EQU $-BUF
DATA ENDS

CODE SEGMENT USE16
            ASSUME CS:CODE,DS:DATA
      START:
            MOV    AX,DATA
            MOV    DS,AX
            MOV    SI,0                 ;偏移地址
            LEA    BX,BUF
            MOV    CX,LEN               ;长度
            MOV    DL,0                 ;数字个数
      JUDGE:MOV    AL,[BX+SI]           ;判断是否为数字
            CMP    AL,30H               ;小于‘0’，跳过
            JC     NEXT
            CMP    AL,39H               ;大于‘9’，跳过
            JA     NEXT
            INC    DL                   ;是数字，统计结果+1
      NEXT: INC    SI                   ;判断下一字符
            LOOP   JUDGE
            MOV    BL,DL                ;将统计结果转至BL，下面开始将结果以二进制显示
            MOV    CX,8                 ;设置循环次数为8（BL的长度）
      RO:   MOV    DL,1                 ;默认输出为1
            SAL    BL,1                 ;将BL左移一位，移出的一位存于CF
            JC     PRT
            MOV    DL,0                 ;若CF不为1，置0
      PRT:  ADD    DL,30H               ;加30H变成ASCII码
            MOV    AH,2                 ;输出
            INT    21H
            LOOP   RO                   ;跳回左移，直至8位都左移完毕，结果主体部分也输出完毕
            MOV    DL,42H               ;最后再输出一个B
            MOV    AH,2
            INT    21H                  ;完美，收工！
                                    
            MOV    AH,4CH
            INT    21H
CODE ENDS
    END START