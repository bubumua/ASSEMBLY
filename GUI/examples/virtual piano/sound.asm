.386
.model flat,stdcall
option casemap:none

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
include		\masm32\include\windows.inc
include		\masm32\include\gdi32.inc
includelib	\masm32\lib\gdi32.lib
include		\masm32\include\user32.inc
includelib	\masm32\lib\user32.lib
include		\masm32\include\kernel32.inc
includelib	\masm32\lib\kernel32.lib
include		\masm32\include\winmm.inc
includelib	\masm32\lib\winmm.lib
include		\masm32\include\comctl32.inc
includelib	\masm32\lib\comctl32.lib

;��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;��KeyShow���ܣ���ʾ�����ٵļ�������ʱ�ļ�ͼƬ
;����˵����IDB_KEY��λͼ����xΪ��ʾͼƬ�ĺ����꣬yΪ������
KeyShow macro IDB_KEY,x,y			
	invoke LoadBitmap,hInstance,IDB_KEY
	mov hBmpKey,eax
	invoke CreateCompatibleDC,@hDc
	mov @hMemDC,eax
	invoke SelectObject,@hMemDC,hBmpKey
	invoke GetClientRect,hWnd,addr @stRect
	invoke	BitBlt,@hDc,x,y,@stRect.right,@stRect.bottom,@hMemDC,0,0,SRCCOPY
	invoke DeleteDC,@hMemDC
endm
; Equ ��ֵ����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

ICO_1		equ		1000h
IDB_BACK1       equ		1001h
IDB_BACK2	equ		1002h
IDB_KEY1        equ		1003h
IDB_KEY2        equ		1004h
IDB_KEY3        equ		1005h
IDI_APP    	equ		1006h
IDM_APP		equ		2000h
IDM_HELP	equ		2001h
IDM_ABOUT	equ		2002h
IDM_CHANGE	equ		2003h
IDM_PIANO	equ		2004h
IDM_GUITAR	equ		2005h
IDD_ABOUT	equ		4000h
IDD_HELP	equ		4001h
.data
	ClassName db "SimpleWinClass",0
	AppName  db "SimpleVirtualPiano",0
	Change dd 00C0H
.data?
	hInstance HINSTANCE ?
	hWinMain	dd		?
	hDcBack		dd		?
	hBmpBack1	dd		?
	hBmpBack2	dd		?
	hBmpKey		dd		?
	hMenu		dd		?

	hdc		HDC		?
	midiFlag	BYTE		?
	midiPu		DWORD		?
	midiYu		DWORD		?
	midiPlayFlag	BYTE		?
	X		DWORD		?
	Y		DWORD		?
	;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>����
	keyboard1 BYTE  ?
	keyboard2 BYTE  ?
	keyboard3 BYTE  ?
	keyboard4 BYTE  ?
	keyboard5 BYTE  ?
	keyboard6 BYTE  ?
	keyboard7 BYTE  ?
	keyboard8 BYTE  ?
	keyboard9 BYTE  ?
	keyboard0 BYTE  ?
	keyboard_ BYTE  ?
	keyboardEqual BYTE  ?
	keyboardQ BYTE  ?
	keyboardW BYTE  ?
	keyboardE BYTE  ?
	keyboardR BYTE  ?
	keyboardT BYTE  ?
	keyboardY BYTE  ?
	keyboardU BYTE  ?
	keyboardI BYTE  ?
	keyboardO BYTE  ?
	keyboardP BYTE  ?
	keyboardLBracket BYTE  ?
	keyboardRBracket BYTE  ?
	keyboardBias BYTE  ?
	keyboardA BYTE  ?
	keyboardS BYTE  ?
	keyboardD BYTE  ?
	keyboardF BYTE  ?
	keyboardG BYTE  ?
	keyboardH BYTE  ?
	keyboardJ BYTE  ?
	keyboardK BYTE  ?
	keyboardL BYTE  ?
	keyboardSemi BYTE  ?
	keyboardPoint BYTE  ?
	keyboardZ BYTE  ?
	keyboardX BYTE  ?
	keyboardC BYTE  ?
	keyboardV BYTE  ?
	keyboardB BYTE  ?
	keyboardN BYTE  ?
	keyboardM BYTE  ?
	keyboardComma BYTE  ?
	keyboardFullPoint BYTE  ?
	keyboardBacklash BYTE  ?


.const
	szCursorFile	db	'1.ani',0

.code

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD			;WinMain�Ĺ����Ǳ�ϵͳ���ã���Ϊһ��32λӦ�ó������ڵ㡣WinMain������ʼ��Ӧ�ó�����ʾ�����ڣ�����һ����Ϣ����һ����ѭ�������ѭ����Ӧ�ó���ִ�е����ಿ�ֵĶ������ƽṹ
												;����hInst��Ӧ�ó���ǰʵ���ľ����hPrevlnstance��Ӧ�ó������ǰʵ���ľ����CmdLine��ָ��Ӧ�ó��������е��ַ�����ָ�룬������ִ���ļ�����CmdShow��ָ�����������ʾ��
	LOCAL wc:WNDCLASSEX					;ע�ᴰ���� 
	LOCAL msg:MSG
	LOCAL hWnd:HWND
	mov   wc.cbSize,SIZEOF WNDCLASSEX			;�ṹ���ֽ���
	mov   wc.style, CS_HREDRAW or CS_VREDRAW		;����
	mov   wc.lpfnWndProc, OFFSET WndProc			;���ڹ��̵�λ�� ��dispatchmessage�����еĴ�����Ϣ��������
	mov   wc.cbClsExtra,NULL				
	mov   wc.cbWndExtra,NULL
	push  hInst						
	pop   wc.hInstance
	mov   wc.hbrBackground,COLOR_WINDOW+1			;����ɫ��ʹ����ɫֵʱ��windows�涨��������ɫֵ�ϼ�1
	mov   wc.lpszMenuName,NULL				;���ڲ˵�
	mov   wc.lpszClassName,OFFSET ClassName			;�����ַ����ĵ�ַ


	invoke	LoadIcon,wc.hInstance,ICO_1			;ͼ��
	.if eax
	mov   wc.hIconSm,eax
	mov   wc.hIcon,eax
	.endif



	invoke LoadCursorFromFile,addr szCursorFile			;���
	.if eax
	    mov wc.hCursor,eax
	.endif

	
	invoke RegisterClassEx, addr wc
	invoke LoadMenu,hInstance,IDM_APP					; ���ز˵�
	mov hMenu,eax
	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\    ;invoke CreateWindowEx,dwExStyle(NULL),lpClassName(ClassName),lpWindowName(appname),
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\			    ;dwStyle(WS_OVERLAPPEDWINDOW),                                                               
           CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,hMenu,\    ;x,y,nWidth,nHeight,hWndParent,hMenu,
           hInst,NULL						    ;hInstance,lpParam
	mov   hWnd,eax						        ;�������ں�eax�д��ص��Ǵ��ھ��
	INVOKE ShowWindow, hWnd,SW_SHOWNORMAL				;SW_SHOWNORMAL����ʾ������ڣ��ظ�������С����ʼ��ʱ�����������
	INVOKE UpdateWindow, hWnd					;��ShowWindow���ƿͻ�����ʵ���Ͼ����򴰿ڷ�����һ��WM_PAINT��Ϣ�����ˣ�һ�����㴰��������������ʾ
        invoke midiOutOpen,ADDR hdc,-1,NULL,NULL,NULL			;������midiOutOpen��һ��������ָ��HMIDIOUT��ָ�룬�����պ�������MIDI���������MIDI�������
        mov   midiYu,0h							;�ڶ����������豸ID��Ҫʹ����ʵ��MIDI�豸�����������Χ�����Ǵ�0��С��UINTmidiOutGetNumDevs(VOID);���ص���ֵ����������ʹ��MIDIMAPPER������MMSYSTEM.H�ж���Ϊ-1��
        mov   midiPlayFlag,1h						;MMRESULTmidiOutOpen(LPHMIDIOUTlphmo,UINT uDeviceID,DWORD dwCallback,DWORD dwCallbackInstance,DWORD dwFlags );
	.WHILE TRUE							;��Ϣѭ��
                INVOKE GetMessage, ADDR msg,NULL,0,0			;GetMessage����Ϣ���л�ȡ��Ϣ�����MSG�ṹ�����أ�����ȡ����ϢΪWM_QUIT��eax�ķ���ֵΪ0���򷵻ط���ֵ
                .BREAK .IF (!eax)
                INVOKE TranslateMessage, ADDR msg
                INVOKE DispatchMessage, ADDR msg
	.ENDW
	mov     eax,msg.wParam
	ret
WinMain endp


;-------------------------------------------------------------------------------
; �����ڡ��Ի������
;���������ھ��HWND,��Ϣ uMsg,��������Ϣ����wParam, lParam
;-------------------------------------------------------------------------------
AboutDlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .if	uMsg == WM_CLOSE
        invoke EndDialog, hWnd, NULL
    .elseif	uMsg == WM_INITDIALOG
        invoke	LoadIcon, hInstance, IDI_APP
        invoke	SendMessage, hWnd, WM_SETICON, ICON_BIG, eax
    .elseif uMsg == WM_COMMAND
        mov	eax, wParam
        .if	ax == IDOK
            invoke	EndDialog, hWnd, NULL
        .endif
    .else
        mov	eax, FALSE
        ret
    .endif
    
    xor lParam, 0h
    mov	eax, TRUE
    ret
AboutDlgProc endp
;-------------------------------------------------------------------------------
; ���������Ի������
;���������ھ��HWND,��Ϣ uMsg,��������Ϣ����wParam, lParam
;-------------------------------------------------------------------------------
HelpDlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .if	uMsg == WM_CLOSE
        invoke EndDialog, hWnd, NULL
    .elseif	uMsg == WM_INITDIALOG
        invoke	LoadIcon, hInstance, IDI_APP
        invoke	SendMessage, hWnd, WM_SETICON, ICON_BIG, eax
    .elseif uMsg == WM_COMMAND
        mov	eax, wParam
        .if	ax == IDOK
            invoke	EndDialog, hWnd, NULL
        .endif
    .else
        mov	eax, FALSE
        ret
    .endif
    
    xor lParam, 0h
    mov	eax, TRUE
    ret
HelpDlgProc endp







;-------------------------------------------------------------------------------
; ���ڹ���
;���������ھ��HWND,��Ϣ uMsg,��������Ϣ����wParam, lParam
;-------------------------------------------------------------------------------

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM			
		local	 @stPs:PAINTSTRUCT
		local    @hMemDC:HDC
		local    @stRect:RECT
		local	 @hDc:HDC  
		local    @playf:WORD
			
	.IF uMsg==WM_DESTROY								;�رճ���
		invoke DeleteObject,hBmpBack1
		invoke DeleteObject,hBmpBack2
		invoke DeleteObject,hBmpKey
                invoke midiOutClose,hdc							;������
		invoke PostQuitMessage,NULL						;PostQuitMessage����Ϣѭ������WM_QUIT��Ϣ���˳���Ϣѭ��
                    
	.ELSEIF uMsg==WM_CREATE
		invoke LoadBitmap,hInstance,IDB_BACK1
		mov hBmpBack1,eax
		invoke LoadBitmap,hInstance,IDB_BACK2
		mov hBmpBack2,eax

	 .ELSEIF uMsg == WM_COMMAND							;����˵��� ������ټ�������Ӵ��ڰ�ť�������������ť����WM_COMMAND��Ϣ
	
		mov eax, wParam								;wParam �������ֽڣ�֪ͨ�룬wParam �����ֽڣ�����ID
		   
		.if ax == IDM_ABOUT							;ID�ǹ���
		    invoke DialogBoxParam, hInstance, offset IDD_ABOUT, hWnd, \
			   offset AboutDlgProc, NULL                  
		.endif
		.if ax == IDM_HELP							;ID�ǰ���
		    invoke DialogBoxParam, hInstance, offset IDD_HELP, hWnd, \
			   offset HelpDlgProc, NULL                  
		.endif
		.if ax == IDM_PIANO							;ID��PIANO
		    mov Change,00C0h          
		.endif
		.if ax == IDM_GUITAR							;ID��GUITAR
		    mov Change,19C0h          
		.endif


	 .ELSEIF uMsg==WM_PAINT						;���ƿͻ���
 
		invoke	BeginPaint,hWnd,addr @stPs

		mov	@hDc,eax
		invoke CreateCompatibleDC,@hDc
		mov @hMemDC,eax
		invoke SelectObject,@hMemDC,hBmpBack1
		invoke	GetClientRect,hWnd,addr @stRect
		invoke BitBlt,@hDc,130,30,@stRect.right,@stRect.bottom,@hMemDC,0,0,SRCCOPY
		invoke SelectObject,@hMemDC,hBmpBack2
		invoke	GetClientRect,hWnd,addr @stRect
		invoke BitBlt,@hDc,250,150,@stRect.right,@stRect.bottom,@hMemDC,0,0,SRCCOPY	
		invoke DeleteDC,@hMemDC

;;;;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>�԰��µĸ��ټ�������ʾ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;���̵�����
		.IF(keyboard1)
			KeyShow  IDB_KEY1,564,40    
		.ENDIF

		.IF(keyboard2)
			KeyShow IDB_KEY2,578,40      
		.ENDIF

		.IF(keyboard3)
			KeyShow IDB_KEY3,592,40      
		.ENDIF
		.IF(keyboard4)
			KeyShow IDB_KEY1,606,40      
		.ENDIF
		.IF(keyboard5)
			KeyShow IDB_KEY2,620,40     
		.ENDIF
		.IF(keyboard6)
			KeyShow IDB_KEY2,634,40      
		.ENDIF
		.IF(keyboard7)
			KeyShow IDB_KEY3,648,40      
		.ENDIF
		.IF(keyboard8)
			KeyShow IDB_KEY1,662,40      
		.ENDIF
		.IF(keyboard9)
			KeyShow IDB_KEY2,676,40      
		.ENDIF
		.IF(keyboard0)
			KeyShow IDB_KEY3,690,40      
		.ENDIF
		.IF(keyboard_)
			KeyShow IDB_KEY1,704,40      
		.ENDIF
		.IF(keyboardEqual)
			KeyShow IDB_KEY2,718,40      
		.ENDIF
	;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>���̵�����
		.IF(keyboardQ)
			KeyShow IDB_KEY1,466,40      
		.ENDIF
		.IF(keyboardW)
			KeyShow IDB_KEY2,480,40      
		.ENDIF
		.IF(keyboardE)
			KeyShow IDB_KEY3,494,40      
		.ENDIF
		.IF(keyboardR)
			KeyShow IDB_KEY1,508,40      
		.ENDIF
		.IF(keyboardT)
			KeyShow IDB_KEY2,522,40      
		.ENDIF
		.IF(keyboardY)
			KeyShow IDB_KEY2,536,40      
		.ENDIF
		.IF(keyboardU)
			KeyShow IDB_KEY3,550,40      
		.ENDIF
		.IF(keyboardI)
			KeyShow IDB_KEY1,564,40      
		.ENDIF
		.IF(keyboardO)
			KeyShow IDB_KEY2,578,40      
		.ENDIF
		.IF(keyboardP)
			KeyShow IDB_KEY3,592,40      
		.ENDIF
		.IF(keyboardLBracket)
			KeyShow IDB_KEY1,606,40      
		.ENDIF
		.IF(keyboardRBracket)
			KeyShow IDB_KEY2,620,40      
		.ENDIF
		.IF(keyboardBias)
			KeyShow IDB_KEY2,634,40      
		.ENDIF
	;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>���̵ڶ���
		.IF(keyboardA)
			KeyShow IDB_KEY1,368,40      
		.ENDIF
		.IF(keyboardS)
			KeyShow IDB_KEY2,382,40      
		.ENDIF
		.IF(keyboardD)
			KeyShow IDB_KEY3,396,40      
		.ENDIF
		.IF(keyboardF)
			KeyShow IDB_KEY1,410,40      
		.ENDIF
		.IF(keyboardG)
			KeyShow IDB_KEY2,424,40      
		.ENDIF
		.IF(keyboardH)
			KeyShow IDB_KEY2,438,40      
		.ENDIF
		.IF(keyboardJ)
			KeyShow IDB_KEY3,452,40      
		.ENDIF
		.IF(keyboardK)
			KeyShow IDB_KEY1,466,40      
		.ENDIF
		.IF(keyboardL)
			KeyShow IDB_KEY2,480,40      
		.ENDIF
		.IF(keyboardSemi)
			KeyShow IDB_KEY3,494,40      
		.ENDIF
		.IF(keyboardPoint)
			KeyShow IDB_KEY1,508,40      
		.ENDIF
	;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>��һ��
		.IF(keyboardZ)
			KeyShow IDB_KEY1,270,40      
		.ENDIF
		.IF(keyboardX)
			KeyShow IDB_KEY2,284,40      
		.ENDIF
		.IF(keyboardC)
			KeyShow IDB_KEY3,298,40      
		.ENDIF
		.IF(keyboardV)
			KeyShow IDB_KEY1,312,40      
		.ENDIF
		.IF(keyboardB)
			KeyShow IDB_KEY2,326,40      
		.ENDIF
		.IF(keyboardN)
			KeyShow IDB_KEY2,340,40      
		.ENDIF
		.IF(keyboardM)
			KeyShow IDB_KEY3,354,40      
		.ENDIF
		.IF(keyboardComma)
			KeyShow IDB_KEY1,368,40      
		.ENDIF
		.IF(keyboardFullPoint)
			KeyShow IDB_KEY2,382,40      
		.ENDIF
		.IF(keyboardBacklash)
			KeyShow IDB_KEY3,396,40      
		.ENDIF


		invoke	EndPaint,hWnd,addr @stPs


	.ELSEIF uMsg==WM_CHAR
		mov @playf,0h
	        push wParam
	        pop midiPu
;===============ESC���Ĺ���================
               .if midiPu==WM_DEVMODECHANGE					;1bh
			invoke midiOutClose,hdc
			invoke	PostQuitMessage,NULL				;PostQuitMessage����Ϣѭ������WM_QUIT��Ϣ���˳���Ϣѭ��
	       .endif
;----------------------------------------


;==================================================================�԰��µļ����ϵļ����д���ʹ���Ӧ�����ϵĸ���������      
;=====================================�����ţ�1-7:1-7+   1-5+��890-=��
		.if midiPu==31h				;keyboard 1  tone1+	1	
		mov midiPu,3ch+12
		mov @playf,1
		mov keyboard1,1

		
		
		.elseif midiPu==32h			;keyboard 2  tone2+	2
		mov midiPu,3eh+12
		mov @playf,1
		mov keyboard2,1

		.elseif midiPu==33h			;keyboard 3  tone3+	3
		mov midiPu,40h+12
		mov @playf,1
		mov keyboard3,1
		.elseif midiPu==34h			;keyboard 4  tone4+	4
		mov midiPu,41h+12
		mov @playf,1
		mov keyboard4,1
		.elseif midiPu==35h			;keyboard 5  tone5+	5
		mov midiPu,43h+12
		mov @playf,1
		mov keyboard5,1
		.elseif midiPu==36h			;keyboard 6  tone6+	6
		mov midiPu,45h+12
		mov @playf,1
		mov keyboard6,1
		.elseif midiPu==37h			;keyboard 7  tone7+	7
		mov midiPu,47h+12
		mov @playf,1
		mov keyboard7,1

		.elseif midiPu==38h				;keyboard 1  tone1++
		mov midiPu,3ch+24
		mov @playf,1
		mov keyboard8,1
		.elseif midiPu==39h			;keyboard 2  tone2++
		mov midiPu,3eh+24
		mov @playf,1
		mov keyboard9,1
		.elseif midiPu==30h			;keyboard 3  tone3++
		mov midiPu,40h+24
		mov @playf,1
		mov keyboard0,1
		.elseif midiPu==2Dh			;keyboard 4  tone4++
		mov midiPu,41h+24
		mov @playf,1
		mov keyboard_,1
		.elseif midiPu==3Dh			;keyboard 5  tone5++
		mov midiPu,43h+24
		mov @playf,1
		mov keyboardEqual,1



	;======================================��һ�� ��ͣ�1-7��z-m�� �εͣ�1-3 ��. /��
		.elseif midiPu==7Ah			;keyboard z  tone1--
		mov midiPu,3ch-24
		mov @playf,1
		mov keyboardZ,1
		.elseif midiPu==78h			;keyboard x  tone2--
		mov midiPu,3eh-24
		mov @playf,1
		mov keyboardX,1
		.elseif midiPu==63h			;keyboard c  tone3--
		mov midiPu,40h-24
		mov @playf,1
		mov keyboardC,1
		.elseif midiPu==76h			;keyboard v  tone4--
		mov midiPu,41h-24
		mov @playf,1
		mov keyboardV,1
		.elseif midiPu==62h			;keyboard b  tone5--
		mov midiPu,43h-24
		mov @playf,1
		mov keyboardB,1
		.elseif midiPu==6Eh			;keyboard n  tone6--
		mov midiPu,45h-24
		mov @playf,1
		mov keyboardN,1
		.elseif midiPu==6Dh			;keyboard m  tone7--
		mov midiPu,47h-24
		mov @playf,1
		mov keyboardM,1
		.elseif midiPu==2Ch			;keyboard ,  tone1-
		mov midiPu,3ch-12
		mov @playf,1
		mov keyboardComma,1
		.elseif midiPu==2Eh			;keyboard .  tone2-
		mov midiPu,3eh-12
		mov @playf,1
		mov keyboardFullPoint,1
		.elseif midiPu==2Fh			;keyboard /  tone3-
		mov midiPu,40h-12
		mov @playf,1
		mov keyboardBacklash,1

;=================================�ڶ���  �εͣ�1-7��a-j�� ������1-4��k l������

		.elseif midiPu==61h			;keyboard a  tone1-
		mov midiPu,3ch-12
		mov @playf,1
		mov keyboardA,1
		.elseif midiPu==73h			;keyboard s  tone2-
		mov midiPu,3eh-12
		mov @playf,1
		mov keyboardS,1
		.elseif midiPu==64h			;keyboard d  tone3-
		mov midiPu,40h-12
		mov @playf,1
		mov keyboardD,1
		.elseif midiPu==66h			;keyboard f  tone4-
		mov midiPu,41h-12
		mov @playf,1
		mov keyboardF,1
		.elseif midiPu==67h			;keyboard g  tone5-
		mov midiPu,43h-12
		mov @playf,1
		mov keyboardG,1
		.elseif midiPu==68h			;keyboard h  tone6-
		mov midiPu,45h-12
		mov @playf,1
		mov keyboardH,1
		.elseif midiPu==6Ah			;keyboard j  tone7-
		mov midiPu,47h-12
		mov @playf,1
		mov keyboardJ,1

		.elseif midiPu==6Bh			;keyboard k  tone1
		mov midiPu,3ch
		mov @playf,1
		mov keyboardK,1
		.elseif midiPu==6Ch			;keyboard l  tone2
		mov midiPu,3eh
		mov @playf,1
		mov keyboardL,1
		.elseif midiPu==3Bh			;keyboard ;  tone3
		mov midiPu,40h
		mov @playf,1
		mov keyboardSemi,1
		.elseif midiPu==27h			;keyboard '  tone4
		mov midiPu,41h
		mov @playf,1
		mov keyboardPoint,1

	;========================================�����ţ�����1-7��q-u�� ������1-6��iop[]\��
		.elseif midiPu==71h			;keyboard q  tone1
		mov midiPu,3ch
		mov @playf,1
		mov keyboardQ,1
		.elseif midiPu==77h			;keyboard w  tone2
		mov midiPu,3eh
		mov @playf,1
		mov keyboardW,1
		.elseif midiPu==65h			;keyboard e  tone3
		mov midiPu,40h
		mov @playf,1
		mov keyboardE,1
		.elseif midiPu==72h			;keyboard r  tone4
		mov midiPu,41h
		mov @playf,1
		mov keyboardR,1
		.elseif midiPu==74h			;keyboard t  tone5
		mov midiPu,43h
		mov @playf,1
		mov keyboardT,1
		.elseif midiPu==79h			;keyboard y  tone6
		mov midiPu,45h
		mov @playf,1
		mov keyboardY,1
		.elseif midiPu==75h			;keyboard u  tone7
		mov midiPu,47h
		mov @playf,1
		mov keyboardU,1

		.elseif midiPu==69h			;keyboard i  tone1+
		mov midiPu,3ch+12
		mov @playf,1
		mov keyboardI,1
		.elseif midiPu==6Fh			;keyboard o  tone2+
		mov midiPu,3eh+12
		mov @playf,1
		mov keyboardO,1
		.elseif midiPu==70h			;keyboard p  tone3+
		mov midiPu,40h+12
		mov @playf,1
		mov keyboardP,1
		.elseif midiPu==5Bh			;keyboard [  tone4+
		mov midiPu,41h+12
		mov @playf,1
		mov keyboardLBracket,1
		.elseif midiPu==5Dh			;keyboard ]  tone5+
		mov midiPu,43h+12
		mov @playf,1
		mov keyboardRBracket,1
		.elseif midiPu==5Ch			;keyboard \  tone6+
		mov midiPu,45h+12
		mov @playf,1
		mov keyboardBias,1
		.endif
        ;-------------------------------------------




		.if @playf==1
			invoke InvalidateRect, hWnd, NULL,FALSE						;���ڿͻ���������»���
            
			mov cl,8
			shl midiPu,cl		;(flip) * &H100)
			and midiPu,0ff00h
			add midiPu,680090h	; &H90 + (volume * &H10000) + channel		    
			.if midiPlayFlag==1h
            ;================���������Ĵ���====================== 
	    
			invoke midiOutShortMsg,hdc,Change
			invoke midiOutShortMsg,hdc,midiPu						;midiOutShortMsg(midiout, &H90 + ((flip) * &H100) + (volume * &H10000) + channel) ����
													;ע�⣺ʹ�������������ϵ���midioutclose�ر��豸��				

			.endif
                .endif
            ;-------------------�����������------------------------



	.ELSEIF uMsg==WM_KEYUP										;�����ϵļ�̧���򽫰�����־���㣬����ʹ���µ��ټ�ͼƬ����ʾ		
		mov keyboard1,0h
		mov keyboard2,0h
		mov keyboard3,0h
		mov keyboard4,0h
		mov keyboard5,0h
		mov keyboard6,0h
		mov keyboard7,0h
		mov keyboard8,0h
		mov keyboard9,0h
		mov keyboard0,0h
		mov keyboard_,0h
		mov keyboardEqual,0h
		mov keyboardQ,0h
		mov keyboardW,0h
		mov keyboardE,0h
		mov keyboardR,0h
		mov keyboardT,0h
		mov keyboardY,0h
		mov keyboardU,0h
		mov keyboardI,0h
		mov keyboardO,0h
		mov keyboardP,0h
		mov keyboardLBracket,0h
		mov keyboardRBracket,0h
		mov keyboardBias,0h
		mov keyboardA,0h
		mov keyboardS,0h
		mov keyboardD,0h
		mov keyboardF,0h
		mov keyboardG,0h
		mov keyboardH,0h
		mov keyboardJ,0h
		mov keyboardK,0h
		mov keyboardL,0h
		mov keyboardSemi,0h
		mov keyboardPoint,0h
		mov keyboardZ,0h
		mov keyboardX,0h
		mov keyboardC,0h
		mov keyboardV,0h
		mov keyboardB,0h
		mov keyboardN,0h
		mov keyboardM,0h
		mov keyboardComma,0h
		mov keyboardFullPoint,0h
		mov keyboardBacklash,0h
		invoke InvalidateRect, hWnd, NULL, FALSE			;���ڿͻ���������»���

	.ELSE

		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		;DefWindowProc���������Ĭ�ϵĴ��ڴ����������ú�������ȱʡ�Ĵ��ڹ�����ΪӦ�ó���û�д������κδ�����Ϣ�ṩȱʡ�Ĵ���
		ret
	.ENDIF
	xor    eax,eax
	ret
WndProc endp
start:
	invoke GetModuleHandle, NULL								;�õ�Ӧ�ó���ľ��
	mov    hInstance,eax	
	invoke WinMain, hInstance,NULL,NULL,SW_SHOWDEFAULT
	invoke ExitProcess,eax      
end start