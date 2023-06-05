datas segment
          buf db'Hello, World!$'
datas ends

stacks segment stack
           db 200 dup(0)
stacks ends

codes segment
          assume cs:codes,ds:datas,ss:stacks
    start:
          mov    ax,datas
          mov    ds,ax

          mov    dx,seg buf
          lea    dx,buf
          mov    ah,09h
          int    21h

          mov    ah,4ch
          int    21h
codes ends
end start