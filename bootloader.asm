; Basically this bootloader will be loaded to 0x00007C00 Address when PC
; boots up.

BITS 16



; ------------------------------------------------------------------------------
; CONSTANTS

%define BOOTLOADER_START_SEGMENT        0x07C0
%define KERNEL_LOAD_SEGMENT             0x07E0



; ------------------------------------------------------------------------------
; Start Section
start:
    jmp main                            ; jump over BIOS Parameter Block
    nop                                 ; No Operation Instruction for 3 bytes
                                        ; adjustment


; ------------------------------------------------------------------------------
; OEM System Name
; This section is required for DOS Compatible FAT-12 MBR

db 'POTATOS1'



; ------------------------------------------------------------------------------
; BIOS Parameter Block

dw 0x0200                               ; Bytes per Sector 200h (512)
db 0x01                                 ; Sector(s) per Cluster
dw 0x0001                               ; Reserved sector count
db 0x02                                 ; Number of FATs
dw 0x00E0                               ; Max Root Directory entries
dw 0x0B40                               ; Number of sectors (2880x512=1.44MB)
db 0xF0                                 ; Media Descriptor F0 for 1.44 Floppy
dw 0x0009                               ; Sectors per FAT
dw 0x0012                               ; Sectors per Track
dw 0x0002                               ; Sides (or Heads)
db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0         ; Reserved area
db 0x29                                 ; Extended BPB Signature
dd 0x12345678                           ; Volume serial number
db 'POTATOS', 0x20, 0x20, 0x20, 0x20    ; Volume LABEL (11 Bytes)
db 'FAT12', 0x20, 0x20, 0x20            ; File System ID (8 Bytes)



; ------------------------------------------------------------------------------
; Main Section

main:
    ; Set data segment to where we're loaded so we can use lodsb instruction and
    ; variables without any modification
    mov ax, BOOTLOADER_START_SEGMENT
    mov ds, ax

    ; Let's read disk sectors into memory
    mov ax, KERNEL_LOAD_SEGMENT         ; Kernel start segment
    mov es, ax
    mov bx, 0x0000                      ; Offset
    mov ah, 0x02                        ; INT 13h / AH = 02h
    mov al, 0x01                        ; Number of sectors to be read
    mov dl, 0x00                        ; Drive number
    mov ch, 0x00                        ; Cylinder number
    mov dh, 0x01                        ; Head number
    mov cl, 0x11                        ; Sector number
    int 0x13

    jc .error_message                   ; jump if clear flag set

    mov ax, KERNEL_LOAD_SEGMENT         ; Set data segment to where we're loaded
    mov ds, ax

    jmp 0x200                          ; Diff between 7E00 - 7C00
                                       ; Jump to the kernel 

.error_message:
    mov si, error_text                  ; Put string position into SI
    call print_string                   ; Call our string-printing routine

.infinite:
    jmp .infinite                       ; Jump here - infinite loop!

    error_text db 'Cannot load kernel', 0



; print string routine
; ------------------------------------------------------------------------------
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

    times 510-($-$$) db 0               ; Pad remainder of boot sector with 0s
    dw 0xAA55                           ; The standard PC boot signature
