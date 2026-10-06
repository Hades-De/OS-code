look:
    mov eax, [command_buffer]
    mov esi, [eax+6]
    ;now esi holds the first arg
    cmp byte [eax+6], "x"
    je look_main
    int 0x01
    jmp no_command

    look_main:
        mov esi, [command_buffer]
        add esi, 7
        call hex_convert
        mov ebx, eax
        mov eax, 0x08
        int 0x80
        mov eax, 0x02
        int 0x80
        jmp return_kernel