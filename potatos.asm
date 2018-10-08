BITS 16



main:
    mov ax, 07C0h                        ; Set up 4K stack space after this bootloader
    add ax, 512                          ; (4096 + 512) / 16 bytes per paragraph
    mov ss, ax
    mov sp, 4096

    mov ax, 07C0h                        ; Set data segment to where we're loaded
    mov ds, ax

    mov si, text_string                  ; Put string position into SI
    call print_string                    ; Call our string-printing routine

.infinite:
    jmp .infinite                        ; Jump here - infinite loop!

    text_string db 'PotatOS 1.1', 0



print_string:                            ; Routine: output string in SI to screen
    mov bl, 01h                          ; first color in the palette

.repeat
    mov ah, 09h                          ; int10 / 09 write character at cursor position
    mov cx, 01h

    lodsb                                ; Get character from string (source segment)
    cmp al, 0
    je .done                             ; If char is zero, end of string

    mov ah, 09h                          ; int 10h 'print char' function
    add bl, 01h                          ; change color
    int 10h                              ; Otherwise, print it

    mov ah, 03h                          ; int10 / 03 get cursor position
    int 10h

    mov ah, 02h                          ; int10 / 02 set cursor position
    add dl, 01h                          ; incrementing column 1
    int 10h

    jmp .repeat

.done:
    ret


    times 510-($-$$) db 0                ; Pad remainder of boot sector with 0s
    dw 0xAA55                            ; The standard PC boot signature
