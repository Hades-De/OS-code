vdel:
    mov eax, [command_buffer]
    mov esi, [eax+6]
    ;now esi holds the first arg
    cmp byte [eax+6], "x"
    je handle_vfree
    int 0x01
    jmp no_command

    handle_vfree:
            mov esi, [command_buffer]
            add esi, 7
            call hex_convert
            ;push eax ; the loc is now on the stack
            mov ebx, [command_buffer]
            mov edx, [ebx +17]
            movzx ecx, dl
            cmp cl, 0
            jle no_command
            sub cl, '0'
            mov ebx, eax
            ;now with both set
            mov eax, 0x0d
            int 0x80
            mov eax, 0x02
            int 0x80
            jmp return_kernel