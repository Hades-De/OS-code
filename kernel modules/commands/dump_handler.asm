dump:
    mov eax, 0x06
    int 0x80
    mov eax, 0x02
    int 0x80
    jmp return_kernel