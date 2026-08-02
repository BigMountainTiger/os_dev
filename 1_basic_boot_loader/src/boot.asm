[org 0x7C00]          ; Tell assembler where bootloader loads

    mov ah, 0x0E      ; BIOS teletype output function
    mov si, msg       ; Point SI to our string

print_char:
    lodsb             ; Load next byte from SI into AL
    cmp al, 0         ; Check if string terminator (0)
    je hang           ; If zero, jump to hang
    int 0x10          ; Call BIOS video interrupt
    jmp print_char    ; Loop for next character

hang:
    cli               ; Clear interrupts
    hlt               ; Halt the processor
    jmp hang          ; Safety loop if wake occurs

msg:
    db "Hello from a custom amd64 bootloader!", 0

    times 510 - ($ - $$) db 0  ; Pad the rest of the 512 bytes with zeros
    dw 0xAA55                  ; Standard PC boot signature
