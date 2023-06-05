.386
.model flat, stdcall
option casemap :none   ; case sensitive
include         E:\masm32\include\windows.inc
include         E:\masm32\include\kernel32.inc
include         E:\masm32\include\user32.inc
includelib      E:\masm32\lib\kernel32.lib
.data
    szCaption db 'Win32汇编例子',0
    szText    db 'Win32汇编，Simple and powerful!',0
.code
    start:
          invoke MessageBox,NULL,addr szText,addr szCaption,MB_OK
          invoke ExitProcess,NULL
end     start
