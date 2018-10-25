BITS 16



; ------------------------------------------------------------------------------
; Main Section
main:
    mov si, message                     ; Put string position into SI
    call print_string                   ; Call our string-printing routine

.infinite:
    jmp .infinite                       ; Jump here - infinite loop!

    message db 'PotatOS 1.5 Kernel', 0



; ------------------------------------------------------------------------------
; Print Routine
print_string:                           ; Routine: output string in SI to screen
    mov ah, 0Eh                         ; int 10h 'print char' function

.repeat:
    lodsb                               ; Get character from string
    cmp al, 0
    je .done                            ; If char is zero, end of string
    int 10h                             ; Otherwise, print it
    jmp .repeat

.done:
    ret