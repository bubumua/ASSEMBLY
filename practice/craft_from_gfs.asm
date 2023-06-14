;****************************************************************************************************
;�ļ���:snake.asm  
;
;����:Geniusdot
;
;�汾��:1.0
;
;*****************************************************************************************************
DATA SEGMENT
dw 0,0
snk db 1
blk db 32
food db 3
tal1 db 4
tal2 db 2
adrs db 5
len db ?
pst db ?
addrs dw ?
frow db ?
fcol db ?
hwrt db ?
gmov db 'game over press r to restart press q to quit $'
score1 db 'score :$'
score2 db ?
score0 db 1
zero db 48
writer db 'Developer: Geniusdot   $'
email db 'e-mail: geniusdot@gmail.com$'
msg1 db 'The way to play the game:$'
way db ' press w to up ,press s to down,press a to left,press d to right$'
msg db 'Press any key(except a,s,d,w) to start$'
DATA ENDS

STACK SEGMENT stack
  db 200 dup(0)
STACK ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:STACK
start:
mov ax,data
mov ds,ax

mov ax,0
mov es,ax

mov frow,10
mov fcol,6
mov dh,10 
mov dl,26
mov ah,2
mov bh,0
int 10h
mov ah,9
lea dx,msg1
int 21h
mov dh,11
mov dl,7
mov ah,2
mov bh,0
int 10h
mov ah,9
lea dx,way
int 21h
mov dh,12
mov dl,20
mov ah,2
mov bh,0
int 10h
mov ah,9
lea dx,msg
int 21h
mov ah,0
int 16h

mov ah,6
mov al,0
mov ch,0
mov cl,0
mov dh,24
mov dl,79
mov bh,10
int 10h
mov dh,0
mov dl,0
mov ah,2
mov bh,0
int 10h
mov ah,9
lea dx,score1
int 21h
mov dl,15
mov ah,2
mov bh,0
int 10h
mov ah,9
lea dx,writer
int 21h
mov ah,9
lea dx,email
int 21h
mov score2,48

push es:[9*4]                                                   ;��ԭint9��ڵ�ַ����
pop ds:[0]
push es:[9*4+2]
pop ds:[2]

mov word ptr es:[9*4],offset int9                    ;�����ж�������
mov es:[9*4+2],cs


jmp aa

write macro  row,col,cnt                                 ;�궨��������ǰ��괦����ַ�
  push bx
  push cx
  push dx
  mov dh,row
  mov dl,col
  mov ah,2
  mov bh,0
  int 10h
  mov ah,9
  mov bl,11
  mov cx,1
  lea di,cnt    ;50
  mov al,[di]
  int 10h
  pop dx
  pop cx
  pop bx
endm

readh macro row,col                                         ;�궨�����ڶ�����ǰ��괦�ַ�           
push dx
push ax
push bx
mov dh,row
mov dl,col
mov ah,2
mov bh,0
int 10h
mov ah,08h
int 10h
mov pst,al
pop bx
pop ax
pop dx
endm

wnear macro                                                   ;�궨��ֻ����readcg���е�readcg�������ж϶����������ô˺�
local wnext1
local wnext2
local wnext3
local wnext4
push dx
dec dh
readh dh,dl
cmp pst,1
jne wnext1
write dh,dl,tal2
jmp wnext4
wnext1:
inc dh
dec dl
readh dh,dl
cmp pst,1
jne wnext2
write dh,dl,tal2
jmp wnext4
wnext2:
inc dh
inc dl
readh dh,dl
cmp pst,1
jne wnext3
write dh,dl,tal2
jmp wnext4
wnext3:
dec dh
inc dl
readh dh,dl
cmp pst,1
jne wnext4
write dh,dl,tal2
wnext4:
pop dx
endm


readcg macro row,col                                    ;�궨�����ڸı��жϳ������ַ�
local tnup,tnup1,tnup2,tnlf,tnlf1,tnlf2,tndn,tndn1,tndn2,tnrt,tnrt1,tnrt2,goout
push bx
push ax
push dx
write dh,dl,tal1
dec row
readh dh,dl
cmp pst,4
jne tnup1
jmp tnup2
tnup1:
jmp near ptr tnup
tnup2:
write dh,dl,blk
inc dh
inc dh
readh dh,dl
cmp pst,1
jne tnup
write dh,dl,tal2
jmp near ptr goout
tnup:
pop dx
push dx
dec col
readh dh,dl
cmp pst,4
jne tnlf1
jmp tnlf2
tnlf1:
jmp near ptr tnlf
tnlf2:
write dh,dl,blk
inc dl
inc dl
readh dh,dl
cmp pst,1
jne tnlf
write dh,dl,tal2
jmp near ptr goout
tnlf:
pop dx
push dx
inc row
readh dh,dl
cmp pst,4
jne tndn1
jmp tndn2
tndn1:
jmp near ptr tndn
tndn2:
write dh,dl,blk
dec dh
dec dh
readh dh,dl
cmp pst,1
jne tndn
write dh,dl,tal2
jmp near ptr goout
tndn:
pop dx
push dx
inc col
readh dh,dl
cmp pst,4
jne tnrt1
jmp tnrt2
tnrt1:
jmp near ptr tnrt
tnrt2:
write dh,dl,blk
dec dl
dec dl
readh dh,dl
cmp pst,1
jne tnrt
write dh,dl,tal2
jmp near ptr goout
tnrt:
pop dx
push dx
wnear
goout:
pop dx
pop ax
pop bx
endm



addone:                                             ;�˱�Ź����ǽ���������һ
push dx
inc score2
mov dh,1
mov dl,0
mov cx,23
cmpad1:
push cx
mov cx,79
cmpad2:
readh dh,dl
cmp pst,2
jne nextad3
jmp nextad4
nextad3:
jmp near ptr nextad
nextad4:
write dh,dl,snk
dec dh
readh dh,dl
cmp pst,4
jne natup
write dh,dl,tal2
dec dh
write dh,dl,tal1
jmp outo
natup:
inc dh
dec dl
readh dh,dl
cmp pst,4
jne natlf
write dh,dl,tal2
dec dl
write dh,dl,tal1
jmp outo
natlf:
inc dh
inc dl
readh dh,dl
cmp pst,4
jne natdn
write dh,dl,tal2
inc dh
write dh,dl,tal1
jmp outo
natdn:
dec dh
inc dl
readh dh,dl
cmp pst,4
jne natrt
write dh,dl,tal2
inc dl
write dh,dl,tal1
natrt:
outo:
pop cx
jmp near ptr endad
nextad:
inc dl
jmp nextad2
chgad2:
jmp near ptr cmpad2
nextad2:
loop chgad2
sub dl,79
inc dh
pop cx
jmp nextad1
chgad1:
jmp near ptr cmpad1
nextad1:
loop chgad1
endad:
pop dx
jmp near ptr crtf



aa:                                                      ;���⿪ʼ������ԭʼ����
mov addrs,offset turnright
mov dh,10
mov dl,1
mov cx,3
write dh,dl,tal1
inc dl
write dh,dl,tal2
wrt: 
inc dl
write dh,dl,snk
loop wrt
mov len,6
mov ax,0
jmp wrt1

ovflw:                                           ;�������ڻ�����ת������Ϸ����
mov ah,6
mov al,0
mov ch,0
mov cl,0
mov dh,24
mov dl,79
mov bh,7
int 10h
mov dh,17
mov dl,17
mov ah,2
mov bh,0
int 10h
mov ah,9
lea dx,gmov
int 21h
mov ax,0        ;�ָ�int9�ж�
mov es,ax
push ds:[0]
pop es:[9*4]
push ds:[2]
pop es:[9*4+2]
stop:
mov ah,0
int 16h
cmp al,'r'
je aa1
jmp aa2
aa1:
jmp near ptr start
aa2:
cmp al,'q'
jne stop
jmp near ptr exit

wrt1:                                                          ;�˴������߹��̵�����ѭ��
call dly
push dx
inc dh
cmp dh,25
je ovflw
inc dl
cmp dl,80
je ovflw
pop dx
push dx
dec dh
cmp dh,0
je ovflw
dec dl
cmp dl,-1
je ovflw
pop dx
push dx
lea ax,turnright
cmp addrs,ax
jne tonxt2
inc dl
readh dh,dl
cmp pst,1
je tonxt1
cmp pst,2
je tonxt1
cmp pst,4
je tonxt1
jmp tonxt2
tonxt1:
jmp ovflw
tonxt2:
pop dx
push dx
lea ax,turnup
cmp addrs,ax
jne tonxt4
dec dh
readh dh,dl
cmp pst,1
je tonxt3
cmp pst,2
je tonxt3
cmp pst,4
je tonxt3
jmp tonxt4
tonxt3:
jmp ovflw
tonxt4:
pop dx
push dx
lea ax,turndown
cmp addrs,ax
jne tonxt6
inc dh
readh dh,dl
cmp pst,1
je tonxt5
cmp pst,2
je tonxt5
cmp pst,4
je tonxt5
jmp tonxt6
tonxt5:
jmp ovflw
tonxt6:
pop dx
push dx
lea ax,turnback
cmp addrs,ax
jne tonxt8
dec dl
readh dh,dl
cmp pst,1
je tonxt7
cmp pst,2
je tonxt7
cmp pst,4
je tonxt7
jmp tonxt8
tonxt7:
jmp ovflw
tonxt8:
pop dx
jmp nexta
crtf1:
jmp near ptr addone
crtf:
call rand1
call rand2
inc frow
mov ah,frow
mov al,fcol
push dx
mov dh,1
mov dl,0
push cx
mov cx,23
check1:
push cx
mov cx,79
check2:
readh dh,dl
cmp pst,1
je nextn
cmp pst,2
je nextn
cmp pst,4
je nextn
jmp nextnn
nextn:
cmp ax,dx
je crtf
nextnn:
inc dl
loop check2
inc dh
sub dl,79
pop cx
loop check1
pop cx
pop dx
write frow,fcol,food
nexta:
mov ah,frow
mov al,fcol
cmp ax,dx
je crtf12
jmp crtf13
crtf12:
jmp near ptr crtf1
crtf13:
push dx
cmp score2,58
jl normal
mov score2,49
inc score0
normal:
mov dh,0
mov dl,8
write dh,dl,score2
add dl,score0
write dh,dl,zero
pop dx
cmp adrs,17
je jmp1
cmp adrs,145
je jmp1
cmp adrs,31
je jmp2
cmp adrs,159
je jmp2
cmp adrs,32
je jmp3
cmp adrs,160
je jmp3
cmp adrs,30
je jmp4
cmp adrs,158
je jmp4
jmp addrs
jmp1:
lea ax, turndown
cmp ax,addrs
je jmp2
mov addrs,offset turnup
jmp near ptr turnup
jmp2:
lea ax,turnup
cmp ax,addrs
je jmp1
mov addrs,offset turndown
jmp near ptr turndown
jmp3:
lea ax,turnback
cmp ax,addrs
je jmp4
mov addrs,offset turnright
jmp near ptr turnright
jmp4:
lea ax,turnright
cmp ax,addrs
je jmp3
mov addrs,offset turnback
jmp near ptr turnback


turnright:                                                          ;�˴�ʵ����������
push dx
mov dh,1
mov dl,0
mov cx,23
cmpr1:
push cx
mov cx,79
cmpr2:
readh dh,dl
cmp pst,2
je nextr4
jmp near ptr nextr
nextr4:
readcg dh,dl
pop cx
jmp near ptr endr
nextr:
inc dl
jmp nextr2
chgr2:
jmp near ptr cmpr2
nextr2:
loop chgr2
sub dl,79
inc dh
pop cx
jmp nextr1
chgr1:
jmp near ptr cmpr1
nextr1:
loop chgr1
endr:
pop dx
inc dl
write dh,dl,snk
jmp near ptr wrt1



turnup:                                                   ;�˴�ʵ����������
push dx
mov dh,1
mov dl,0
mov cx,23
cmpu1:
push cx
mov cx,79
cmpu2:
readh dh,dl
cmp pst,2
jne nextu3
jmp nextu4
nextu3:
jmp near ptr nextu
nextu4:
readcg dh,dl
pop cx
jmp near ptr endu
nextu:
inc dl
jmp nextu2
chgu2:
jmp near ptr cmpu2
nextu2:
loop chgu2
sub dl,79
inc dh
pop cx
jmp nextu1
chgu1:
jmp near ptr cmpu1
nextu1:
loop chgu1
endu:
pop dx
dec dh
write dh,dl,snk
jmp near ptr wrt1



turndown:                                          ;�˴�ʵ����������
push dx
mov dh,1
mov dl,0
mov cx,23
cmpd1:
push cx
mov cx,79
cmpd2:
readh dh,dl
cmp pst,2
jne nextd3
jmp nextd4
nextd3:
jmp near ptr nextd
nextd4:
readcg dh,dl
pop cx
jmp near ptr endd
nextd:
inc dl
jmp nextd2
chgd2:
jmp near ptr cmpd2
nextd2:
loop chgd2
sub dl,79
inc dh
pop cx
jmp nextd1
chgd1:
jmp near ptr cmpd1
nextd1:
loop chgd1
endd:
pop dx
inc dh
write dh,dl,snk
jmp near ptr wrt1



turnback:                                    ;�˴�ʵ����������
push dx
mov dh,1
mov dl,0
mov cx,23
cmpb1:
push cx
mov cx,79
cmpb2:
readh dh,dl
cmp pst,2
jne nextb3
jmp nextb4
nextb3:
jmp near ptr nextb
nextb4:
readcg dh,dl
pop cx
jmp near ptr endb
nextb:
inc dl
jmp nextb2
chgb2:
jmp near ptr cmpb2
nextb2:
loop chgb2
sub dl,79
inc dh
pop cx
jmp nextb1
chgb1:
jmp near ptr cmpb1
nextb1:
loop chgb1
endb:
pop dx
dec dl
write dh,dl,snk
jmp near ptr wrt1


exit:


mov ax,0        ;�ָ�int9�ж�
mov es,ax
push ds:[0]
pop es:[9*4]
push ds:[2]
pop es:[9*4+2]


mov ah,4ch
int 21h

int9:                                    ;���ĺ���жϷ������
push ax

in al,60h

mov adrs,al

mov al,20h
out 20h,al
pop ax
iret


DLY PROC    near             ;��ʱ�ӳ���
       PUSH CX
       PUSH DX
       MOV  DX,10000
DL1:   MOV  CX,9801
DL2:   LOOP DL2
       DEC  DX
       JNZ  DL1
       POP  DX
       POP  CX
       RET
DLY    ENDP
RAND1  PROC
      PUSH CX
      PUSH DX
      PUSH AX
      STI
      MOV AH,0             ;��ʱ�Ӽ�����ֵ
      INT 1AH
      MOV AX,DX            ;���6λ
      AND AH,3
      MOV DL,23         ;��23������0~23����
      DIV DL
      MOV frow,AH            ;������frow�����������
      POP AX
      POP DX
      POP CX
      RET
RAND1  ENDP
RAND2  PROC
      PUSH CX
      PUSH DX
      PUSH AX
      STI
      MOV AH,0             ;��ʱ�Ӽ�����ֵ
      INT 1AH
      MOV AX,DX            ;���6λ
      AND AH,3
      MOV DL,79           ;��79������0~79����
      DIV DL
      MOV fcol,AH            ;������fcol�����������
      POP AX
      POP DX
      POP CX
      RET
RAND2  ENDP
CODE ENDS
   END start


