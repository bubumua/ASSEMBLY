include \masm32\include\masm32rt.inc
include \masm32\include\windows.inc
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib            
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib


.data                                  ; initialised variables
    MyAppName db      "Masm32:", 0
              MyReal8 REAL8 123.456

.data?                                 ; non-initialised (i.e. zeroed) variables
    MyDword   dd      ?

.code
    start:
          invoke MessageBox, 0, chr$("A box, wow!"), addr MyAppName, MB_OK
          mov    eax, 123                                                     ; just an example – launch OllyDbg to see it in action
          exit
end start
