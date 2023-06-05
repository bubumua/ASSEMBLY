DATA SECTION
;
RCKEEP DD 0             ;temporary place to keep things
;
CODE SECTION
;
START:
PUSH -11D               ;STD_OUTPUT_HANDLE
CALL GetStdHandle       ;get, in eax, handle to active screen buffer
PUSH 0,ADDR RCKEEP      ;RCKEEP receives output from API
PUSH 24D,'Hello World (from GoAsm)'    ;24=length of string
PUSH EAX                ;handle to active screen buffer
CALL WriteFile
XOR EAX,EAX             ;return zero
RET