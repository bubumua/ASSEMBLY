Init_game macro op1,op2,op3,op4,op5,op6   ;��Ļ��ʼ��
    mov cx,00h
    mov dh,op1
    mov dl,op2
op6:mov ah,02h
    mov bh,00h
    int 10h
    push cx
    mov ah,0ah
    mov al,op3
    mov bh,00h
    mov cx,01h
    int 10h
    pop cx
    inc cx
    inc op4
    cmp cx,op5
    jne op6
endm
clear_screen macro op1,op2,op3,op4 ;�����궨��
    mov ah,06h
    mov al,00h
    mov bh,07h
    mov ch,op1
    mov cl,op2
    mov dh,op3
    mov dl,op4
    int 10h
    mov ah,02h
    mov bh,00h
    mov dh,00h
    mov dl,00h
    int 10h
endm

cursor  macro op1,op2  ;�ù��궨��
   mov ah,02h
   mov bh,00h
   mov dh,op1
   mov dl,op2
   int 10h
endm
menu  macro op1,op2,op3 ;�˵���ʾ�궨��
   mov ah,02h
   mov bh,00h
   mov dh,op1
   mov dl,op2
   int 10h
   mov ah,09h
   lea dx,op3
   int 21h
endm

display1 macro op1
push si
xor si,si
mov si,5
display1_next:
      cursor 24d,op1
      mov ah,09h
      mov bh,00h
      mov al,08h
      mov bl,00001001b
      mov cx,01h
      int 10h
      add op1,01d
      dec si
      jnz display1_next
      pop si
      sub op1,01d
endm

display10 macro op1
push si
xor si,si
mov si,5
display10_next:
      cursor 24d,op1
      mov ah,09h
      mov bh,00h
      mov al,08h
      mov bl,00001001b
      mov cx,01h
      int 10h
      add op1,01d
      dec si
      jnz display10_next
      pop si
      sub op1,01d
endm

display11 macro op1
push si
xor si,si
mov si,5
display11_next:
      cursor 24d,op1
      mov ah,09h
      mov bh,00h
      mov al,08h
      mov bl,00001001b
      mov cx,01h
      int 10h
      add op1,01d
      dec si
      jnz display11_next
      pop si
      sub op1,01d
endm

display2 macro op1,op2
cursor op1,op2
mov ah,09h
mov bh,00h
mov al,0dbh
mov bl,10001010b
mov cx,01h
int 10h
endm

hidden  macro       ; ���������궨�塣�ڵ�ǰ���λ��д�ո�
      mov ah,09h
      mov al,20h
      mov bl,00h
      mov bh,00h
      mov cx,01h
      int 10h
endm


data segment
meg   db "WELCOME TO PLAY$"
meg1  db "press Enter key to continue.......$"
meg2  db "press q key to exit!$"
meg3  db "your score is:$"
meg4  db "press Enter key to replay.......$"
meg5  db "press any key to exit!$"
meg6  db "please choose speed(1:easy 2:medium 3:hard):$"
meg7  db "chose the wrong speed,please choose again!$"
line db ?
ploth db ?
plotl db ?
steph   db  -1
stepl   db  -1
stepll  db  -1
stephh  db  -1
gameover db 0
hang db 0
lie db 0
bianliang db 0
num db 0
choose_speed db 0
speed dw 0
speed_wrong db 0
data ends

stack segment para stack 'stack'
      db 64 dup(0)
stack ends
code  segment
      main proc far
           assume cs:code,ds:data,ss:stack
start:   mov ax,data
         mov ds,ax
         clear_screen 00d,00d,24d,79d           ;����
         menu 05d,15d,meg              ;�˵���Ϣ�ĺ����
         menu 07h,15d,meg1
         menu 09d,15d,meg2
         mov ah,01h              ;�Ӽ������������ַ�
         int 21h
         cmp al,0dh  ;�س���ʼ
         je gamebegin
         jmp exit
gamebegin:clear_screen 00d,00d,24d,79d           ;����
         mov ah,0bh
         mov bh,0
         mov bl,1
         int 10h
	 mov choose_speed,32h
	 mov speed,0500h
	 mov speed_wrong,0
	 menu 07h,08d,meg6
	 mov ah,1
	 int 21h
	 mov choose_speed,al
	 call c_speed
	 cmp speed_wrong,1
	 jz  gamebegin
	 clear_screen 00d,00d,24d,79d
         Init_game 00d,00d,0feh,dl,80d,nextsign1     ;��Ļ��ʼ��
	 mov line,38d
	 display10 line
         mov ploth,23d
         mov plotl,40d
	 mov num,0
input:        cmp gameover,1       ; �ж���Ϸ������־
              jz  quit
              mov ah,1
              int 16h               ; ���Ƿ��м��룬�޾�ִ���ƶ�С��
                                    ; ZF =0 , �����м���
              jnz  iii
              call ball_move
              mov dx,speed           ;��ʱ(start)
              delay: mov cx,0ffffh
              again: loop again
              dec dx
              jnz delay           ;��ʱ(end)
	      cursor ploth,plotl
	      hidden
              jmp input           ; �ƶ��������ѭ��
iii:          mov ah,0
              int 16h               ; ��������
              cmp al,'q'            ;��q���˳�
              jz exit
              cmp al,'a'            ;��a������
              jz lll
              cmp al,'d'            ;��d������
              jz rrr
              jmp input            ; ����������ѭ��
lll:          call ban_left
              jmp input
rrr:          call ban_right
              jmp  input
quit:         call score
              menu 09h,15d,meg4
              menu 11d,15d,meg5
              mov ah,01h              ;�Ӽ������������ַ�
              int 21h
	      cmp al,0dh  ;�س���ʼ
              je  wunai
exit:         mov ah,4ch             ;����������
              int 21h
wunai:        mov gameover,0
              jmp gamebegin
main endp

ban_left proc
	call line_hidden
	sub line,01d
        cmp line,0                     ;��������Ƿ�Խ�磬ҪԽ��;ܾ�����
	jl haha
	jmp ban_left_draw
haha:
        add line,01d
ban_left_draw:
        display1 line
        ret
ban_left endp

ban_right proc
	call line_hidden
	add line,01d
	cmp line,75d
	ja hehe
	jmp ban_right_draw
hehe:
        sub line,01d
ban_right_draw:
        display11 line
        ret
ban_right endp

line_hidden proc
       push si
       xor si,si
       mov si,5
line_hidden_next:
       cursor 24d,line
       hidden
       sub line,01d
       dec si
       jnz line_hidden_next
       pop si
       add line,01d
       ret
line_hidden endp


ball_move proc
              mov al,steph
	      mov stephh,al
              mov al,stepl
	      mov stepll,al
              cmp plotl,00d                    ;С���Ƿ�����ڣ��Ǿ͵�����
              jz step1_0
              mov bl, ploth
              mov cl, plotl
              sub cl,01d
	      cursor bl,cl
              mov ah,8
	      mov bh,00h
              int 10h
step1_0:      cmp plotl,00d
              jz step1
              cmp al,0feh                        ;С���Ƿ�����ש�飬�Ǿ͵�����
              jz step11
see1:
              cmp plotl,79d                   ;С���Ƿ������ڣ��Ǿ͵�����
              jz step2_0
	      cmp plotl,00d
	      jz see2
              mov bl, ploth
              mov cl, plotl
              add cl,01d
	      cursor bl,cl
              mov ah,8
	      mov bh,00h
              int 10h
step2_0:      cmp plotl,79d
              jz step2
              cmp al,0feh                      ;С���Ƿ�����ש�飬�Ǿ͵�����
              jz step22
see2:
              cmp ploth,00d                      ;С���Ƿ�������
              jz step3
              mov bl,ploth
              mov cl,plotl
              sub bl,01d
	      cursor bl,cl
              mov ah,8
	      mov bh,00h
              int 10h
              cmp al,0feh                       ;С���Ƿ�����ש��
              jz step33
	      cmp stephh,1d
	      jz see3
              cmp stepll,1d
              jz r_u
	      jmp l_u
see3:         cmp ploth,23d                 ;С�򳬹�����н����ٲ�
	      jz step4
	      jmp go

step1:
              mov stepl,01d
              jmp see1
step11:
              add num,1
              mov stepl,01d                  ;����ש�����
              hidden                       ;�����������쳣״̬
              jmp see1
step2:
              mov stepl,-1d
              jmp see2
step22:
              add num,1
              mov stepl,-1d                 ;����ש�����
              hidden                       ;�����������쳣״̬
              jmp see2
step3:
              mov steph,1d
              jmp see3
step33:
              add num,1
              mov steph,1d                  ;����ש�����
              hidden                       ;�����������쳣״̬
	      jmp see3
step4:
              call arbitration
	      jmp go
r_u:          cmp plotl,79d
              jz see3
              mov bl,ploth
              mov cl,plotl
	      sub bl,01d
	      add cl,01d
	      cursor bl,cl
	      mov ah,8
	      mov bh,00h
              int 10h
              cmp al,0feh
	      jz step44
	      jmp see3
l_u:          cmp plotl,00d
              jz l_u_0
	      jmp l_u_1
l_u_0:        jmp see3
l_u_1:        mov bl,ploth
              mov cl,plotl
	      sub bl,01d
	      sub cl,01d
	      cursor bl,cl
	      mov ah,8
	      mov bh,00h
              int 10h
              cmp al,0feh
	      jz step55
	      jmp see3
step44:       add num,1
              mov steph,1d
              mov stepl,-1d
              hidden
	      jmp see3
step55:       add num,1
              mov steph,1d
              mov stepl,1d
	      hidden
	      jmp see3
go:                                        ;С���ƶ�
	mov bl,ploth
	add bl,steph
	mov ploth,bl
	mov bl,plotl
	add bl,stepl
	mov plotl,bl
	display2 ploth,plotl
	ret
ball_move endp

arbitration proc
        mov gameover,1
        mov al,ploth
	mov hang,al
	mov al,plotl
	mov lie,al
	cmp stepl,1
	jz down_r
	cmp lie,00d
	jz arbitration_exit1
	add hang,01d
	cursor hang,lie
	mov ah,8
	mov bh,00h
	int 10h
	cmp al,08h
	jz l_down_hit
	sub lie,01d
	cursor hang,lie
	mov ah,8
	mov bh,00h
	int 10h
	cmp al,08h
	jz l_left_hit
	mov gameover,1d
arbitration_exit1:jmp arbitration_exit
l_down_hit:
        mov gameover,0
        mov steph,-1d
	mov stepl,-1d
	jmp arbitration_exit
l_left_hit:
        cmp stepl,00d
	jz l_left_hit_0
        jmp l_left_hit_1
l_left_hit_0:jmp arbitration_exit
l_left_hit_1:mov gameover,0
        mov steph,-1d
	mov stepl,1d
	jmp arbitration_exit
down_r:
        add hang,01d
	cursor hang,lie
	mov ah,8
	mov bh,00h
	int 10h
	cmp al,08h
	jz r_down_hit
	cmp lie,79d
	jz arbitration_exit
	add lie,01d
	cursor hang,lie
	mov ah,8
	mov bh,00h
	int 10h
	cmp al,08h
	jz r_right_hit
	mov gameover,1
	jmp arbitration_exit
r_down_hit:
        mov gameover,0
        mov steph,-1d
	mov stepl,1d
	jmp arbitration_exit
r_right_hit:
        cmp stepl,79d
	jz arbitration_exit
        mov gameover,0
        mov steph,-1d
	mov stepl,-1d
	jmp arbitration_exit
arbitration_exit:
        ret
arbitration endp

score proc
        clear_screen 00d,00d,24d,79d           ;����
        menu 07h,15d,meg3
        xor dx,dx
        xor ah,ah
        mov al,num
        mov bl,0ah
	div bl
        push ax
	add al,30h
	mov dl,al
	mov ah,2
	int 21h
	pop ax
	add ah,30h
	mov dl,ah
	mov ah,2
	int 21h
	mov dl,0ah
	mov ah,2
	int 21h
ret
score endp

c_speed proc
        cmp choose_speed,31h
	jz c_1
	cmp choose_speed,32h
	jz c_2
	cmp choose_speed,33h
	jz c_3
        call wrong
	jmp c_speed_exit
c_1:    mov speed,0800h
        jmp c_speed_exit
c_2:    mov speed,0500h
        jmp c_speed_exit
c_3:    mov speed,0200h
        jmp c_speed_exit
c_speed_exit:
        ret
c_speed endp

wrong proc
      mov speed_wrong,1
      menu 09d,15d,meg7
      mov dx,5000h           ;��ʱ(start)
      wrong_delay: mov cx,0ffffh
      wrong_again: loop wrong_again
      dec dx
      jnz wrong_delay           ;��ʱ(end)
      ret
wrong endp

code ends
end start
