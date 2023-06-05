;示例代码1.asm
;语法：GoASM
DATA SECTION
text     db 'Hello x64!', 0
caption  db 'My First x64 Application', 0
output   db 'A',0
 
CODE SECTION
START:

lea rdx, text
lea r8, output
xor r9d,r9d
xor rcx,rcx
sub rsp,28h
call MessageBoxA
add rsp,28h
ret