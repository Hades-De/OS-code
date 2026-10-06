poke:
    mov eax, [command_buffer]
    mov esi, [eax+6]
    ;now esi holds the first arg
    cmp byte [eax+6], "x"
    je poke_main
    int 0x01
    jmp no_command
        poke_main:
            mov esi, [command_buffer]
            add esi, 7
            call hex_convert
            mov dword [arg1], eax
            add esi, 3
            cmp byte [esi], 'x'
            jne no_command
            inc esi
            call hex_convert
            mov esi, [arg1]
            mov dword [esi], eax
            mov eax, 0x02
            int 0x80
            jmp return_kernel

            


;vars
arg1 dd 0x00