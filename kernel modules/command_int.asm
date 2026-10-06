[org 0x10ee00]
[bits 32]
init:; command buffer input and output the handler
    pop ebp
    pop eax
    pop ebx
    mov dword [command_buffer], eax
    mov dword [esi_CB_stor], ebx
    mov eax, handle_enter
    push eax
    push ebp
    ret

    hex_convert:
        xor eax, eax
        xor edx, edx
        .next:
            mov dl, [esi]
            cmp dl, ','
            je .done
            cmp dl, 0x00
            je .done
            cmp dl, 0x66
            jg .done
            cmp dl, 0x61
            jge .letter
            sub dl, '0'
            shl eax, 4
            add eax, edx 
            inc esi
            jmp .next
        .letter:
            xor edi, edi
            sub dl, 0x61
            mov edi, hex_table
            add edi, edx
            mov dl, [edi]
            shl eax, 4
            add eax, edx
            inc esi
            jmp .next
            
        .done:
            ret

%include "./commands/dump_handler.asm"
%include "./commands/clear_handler.asm"
%include "./commands/valloc_handler.asm"
%include "./commands/vfree_handler.asm"
%include "./commands/look_handler.asm"
%include "./commands/help_handler.asm"
%include "./commands/poke_handler.asm"
        handle_enter:
            xor ebx, ebx
            xor ecx, ecx
            ;loop for commands
            .loop_find_command:
                mov edi, cmds
                add edi, ebx
                mov esi, [command_buffer]
                mov ecx, 4 ; only checks the base. if i want to add args, i need to code it like that
                cld
                repe cmpsb
                ;if equal, its the command, parse further
                jne .skip ;ebx contains the offset for the command
                jmp found_cmd
                .skip:
                cmp ebx, command_timeout
                jge no_command
                add ebx, 4
                jmp .loop_find_command
                no_command:
                    mov ecx, Dump_regs-NCM -1
                    mov ebx, NCM
                    xor eax, eax
                    int 0x80
                    mov eax, 0x02
                    int 0x80
                return_kernel:
                    mov ecx, [esi_CB_stor]
                    mov edx, [command_buffer]
                    xor esi, esi
                    .loop_clr_SB_buffer:
                        cmp dword[ecx], 0
                        je .done
                        mov dword [edx+esi], 0x00
                        dec dword [ecx]
                        inc esi
                        jmp .loop_clr_SB_buffer
                    .done:
                        mov ecx, [esi_CB_stor]
                        mov dword [ecx], 0x00
                        ret

                found_cmd:
                    mov eax, handler
                    add eax, ebx
                    jmp [eax]

NCM db "No command found!"
Dump_regs db 0
esi_CB_stor dd 0x00
command_buffer dd 0x00
command_timeout equ 256
cmds:
    db "dump"
    db "clr" ,0x00
    db "vget"
    db 'vdel'
    db 'look'
    db 'help'
    db 'poke'

handler:
dd dump
dd clear
dd vget
dd vdel
dd look
dd help
dd poke

hex_table:
db 0x0a
db 0x0b
db 0x0c
db 0x0d
db 0x0e
db 0x0f

times 1024 - ($ - $$) db 0