BITS 16



main:
    mov ax, 07C0h                        ; Set up 4K stack space after this bootloader
    add ax, 512                          ; (4096 + 512) / 16 bytes per paragraph
    mov ss, ax
    mov sp, 4096

    mov ax, 07C0h                        ; Set data segment to where we're loaded
    mov ds, ax

    mov ah, 0                            ; Set video mode function for int 10h
    mov al, 12h                          ; Video graphics mode 640x480 16-color
    int 10h

    mov si, text_string                  ; Put string position into SI
    call print_string                    ; Call our string-printing routine

.next_line:
    mov si, prompt
    call print_string
.infinite:
    mov ah, 0                            ; Character input service for kbd int.
    int 16h                              ; Keyboard interrupt puts key in al

    cmp al, `\r`                         ; Check for carriage return (enter key)
    je .next_line

    mov ah, 0Eh
    add bl, 01h                          ; change color
    int 0x10

    jmp .infinite                        ; Jump here - infinite loop!

    text_string db 'PotatOS 1.3', 0
    prompt db `\r`, `\n`, ' $ ', 0       ; "$ " on the start of a new line



print_string:                            ; Routine: output string in SI to screen
    mov bl, 01h                          ; first color in the palette

.repeat
    lodsb                                ; Get character from string (source segment)
    cmp al, 0
    je .done                             ; If char is zero, end of string

    mov ah, 0Eh                          ; int 10h 'print char' function TTY mode
    add bl, 01h                          ; change color
    int 10h                              ; Otherwise, print it

    jmp .repeat

.done:
    ret


    times 510-($-$$) db 0                ; Pad remainder of boot sector with 0s
    dw 0xAA55                            ; The standard PC boot signature
