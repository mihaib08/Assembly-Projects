%include "io.mac"

section .text
    global otp
    extern printf

otp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY

    ;; TODO: Implement the One Time Pad cipher

    ;; (re)initialise the index
    xor ebx, ebx

    test ecx, ecx
    jnz encode

encode:
    mov al, [esi + ebx]
    mov ah, [edi + ebx]

    xor al, ah
    mov [edx + ebx], byte al
    inc ebx
    cmp ebx, ecx
    jnz encode

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
