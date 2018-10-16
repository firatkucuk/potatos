BITS 16



; ------------------------------------------------------------------------------
start:
    jmp main                            ; jump over BIOS Parameter Block
    nop                                 ; No Operation Instruction for 3 bytes
                                        ; adjustment


; ------------------------------------------------------------------------------
; OEM System Name

db 'POTATOS1'



; ------------------------------------------------------------------------------
; BIOS Parameter Block

dw 0x0200                                ; Bytes per Sector 200h (512)
db 0x01                                  ; Sector(s) per Cluster
dw 0x0001                                ; Reserved sector count
db 0x02                                  ; Number of FATs
dw 0x00E0                                ; Max Root Directory entries
dw 0x0B40                                ; Number of sectors (2880x512=1.44MB)
db 0xF0                                  ; Media Descriptor F0 for 1.44 Floppy
dw 0x0009                                ; Sectors per FAT
dw 0x0012                                ; Sectors per Track
dw 0x0002                                ; Sides (or Heads)
db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0          ; Reserved area
db 0x29                                  ; Extended BPB Signature
dd 0x12345678                            ; Volume serial number
db 'POTATOS', 0x20, 0x20, 0x20, 0x20     ; Volume LABEL (11 Bytes)
db 'FAT12', 0x20, 0x20, 0x20             ; File System ID (8 Bytes)



; ------------------------------------------------------------------------------
main:
    mov ax, 0x07C0                       ; Set data segment to where we're loaded
    mov ds, ax

    mov ah, 12h
    int 13

    jb .error_message

    mov si, message_ok                     ; Put string position into SI
    call print_string                   ; Call our string-printing routine
.ok:
    jmp .ok

.error_message:
    mov si, message                     ; Put string position into SI
    call print_string                   ; Call our string-printing routine

.infinite:
    jmp .infinite                       ; Jump here - infinite loop!

    message db 'This is my cool new OS!', 0
    message_ok db 'OK', 0


print_string:            ; Routine: output string in SI to screen
    mov ah, 0Eh        ; int 10h 'print char' function

.repeat:
    lodsb            ; Get character from string
    cmp al, 0
    je .done        ; If char is zero, end of string
    int 10h            ; Otherwise, print it
    jmp .repeat

.done:
    ret

.exit:
    nop

    times 510-($-$$) db 0    ; Pad remainder of boot sector with 0s
    dw 0xAA55        ; The standard PC boot signature

;     mov ax, 07C0h                        ; Set up 4K stack space after this bootloader
;     add ax, 512                          ; (4096 + 512) / 16 bytes per paragraph
;     mov ss, ax
;     mov sp, 4096

;     mov ax, 07C0h                        ; Set data segment to where we're loaded
;     mov ds, ax

;     mov ah, 0                            ; Set video mode function for int 10h
;     mov al, 12h                          ; Video graphics mode 640x480 16-color
;     int 10h

;     mov si, text_string                  ; Put string position into SI
;     call print_string                    ; Call our string-printing routine

; .next_line:
;     mov si, prompt
;     call print_string
; .infinite:
;     mov ah, 0                            ; Character input service for kbd int.
;     int 16h                              ; Keyboard interrupt puts key in al

;     cmp al, `\r`                         ; Check for carriage return (enter key)
;     je .next_line

;     mov ah, 0Eh
;     add bl, 01h                          ; change color
;     int 0x10

;     jmp .infinite                        ; Jump here - infinite loop!

;     text_string db 'PotatOS 1.3', 0
;     prompt db `\r`, `\n`, ' $ ', 0       ; "$ " on the start of a new line



; print_string:                            ; Routine: output string in SI to screen
;     mov bl, 01h                          ; first color in the palette

; .repeat
;     lodsb                                ; Get character from string (source segment)
;     cmp al, 0
;     je .done                             ; If char is zero, end of string

;     mov ah, 0Eh                          ; int 10h 'print char' function TTY mode
;     add bl, 01h                          ; change color
;     int 10h                              ; Otherwise, print it

;     jmp .repeat

; .done:
;     ret


;     times 510-($-$$) db 0                ; Pad remainder of boot sector with 0s
;     dw 0xAA55                            ; The standard PC boot signature
