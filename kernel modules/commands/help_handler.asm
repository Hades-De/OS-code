help:
    xor edx, edx
    mov esi, handler - cmds
    shr esi, 2
    .loop:
        mov ebx, cmds
        add ebx, edx
        mov ecx, 4 -1
        xor eax, eax
        int 0x80
        mov eax, 2
        int 0x80
        add edx, 4
        dec esi
        cmp esi, 0
        jne .loop
    jmp return_kernel