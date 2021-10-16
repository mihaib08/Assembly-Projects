%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY

    ;; TODO: Implement the caesar cipher

    xor eax, eax

    ;; a..z / A..Z --> 26 letters => key is the same as (key % 26)
    cmp edi, 25
    jg getKey

start:
    test ecx, ecx
    jnz encode

encode:
    mov al, [esi + ecx - 1]
    
    ;; check al - letter
    cmp al, 'A'
    jb notLetter

    cmp al, 'Z'
    ja testSmall

    ;; al - A..Z
    add eax, edi
    cmp eax, 'Z'
    jg getBigLetter

    jmp modify

getBigLetter:
    sub eax, 26
    cmp eax, 'Z'
    jg getBigLetter

;; write the encrypted character
modify:
    mov [edx + ecx - 1], byte al
    dec ecx
    test ecx, ecx
    jnz encode

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

testSmall:
    ;; already checked al - A..Z
    cmp al, 'a'
    jb notLetter
    cmp al, 'z'
    ja notLetter

    add eax, edi
    cmp eax, 'z'
    jg getSmallLetter

    jmp modify

getSmallLetter:
    sub eax, 26
    cmp eax, 'z'
    jg getSmallLetter

    jmp modify


;; not a letter -> no change
notLetter:
    jmp modify

;; (key % 26)
getKey:
    sub edi, 26
    cmp edi, 25
    jg getKey

    jmp start
