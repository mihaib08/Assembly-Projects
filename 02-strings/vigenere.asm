%include "io.mac"

section .data
   ;; index - plaintext
   plain_ind dd 0

   ;; index - key
   key_ind dd 0

   ;; key_position in the alphabet
   pos dd 0

section .text
    global vigenere
    extern printf

vigenere:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len
    ;; DO NOT MODIFY

    ;; TODO: Implement the Vigenere cipher

    ;; (re)initialise
    xor eax, eax
    mov [plain_ind], dword 0
    mov [key_ind], dword 0

    test ecx, ecx
    jnz encode

encode:
    ;; Plaintext
    push ecx                      ; plaintext_len
    mov ecx, [plain_ind]
    mov al, [esi + ecx]

    ;; Key
    push ebx                      ; key_len
    mov ebx, [key_ind]
    mov ah, [edi + ebx]

    ;; get the alphabet position of the current key
    sub ah, 'A'
    mov [pos], ah
    xor ah, ah

    ;; check if al - letter
    cmp al, 'A'
    jb notLetter
    cmp al, 'Z'
    ja testSmall

    ;; al - BIG letter
    add eax, [pos]
    cmp eax, 'Z'
    jg getBigLetter

    jmp modify

getBigLetter:
    sub eax, 26
    cmp eax, 'Z'
    jg getBigLetter

modify:
    mov [edx + ecx], byte al
    inc dword [plain_ind]
    inc dword [key_ind]

    ;; ------------- POP
    pop ebx                       ; key_len
    pop ecx                       ; plaintext_len

    cmp ebx, [key_ind]
    je recycleKey

back:
    cmp ecx, [plain_ind]
    jne encode

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

testSmall:
    cmp al, 'a'
    jb notLetter
    cmp al, 'z'
    ja notLetter

    ;; al - SMALL letter
    add eax, [pos]
    cmp eax, 'z'
    jg getSmallLetter

    jmp modify

getSmallLetter:
    sub eax, 26
    cmp eax, 'z'
    jg getSmallLetter

    jmp modify


notLetter:
    ;; key_ind stays the same
    dec dword [key_ind]

    jmp modify

;; reinitialise the key_ind
recycleKey:
    mov [key_ind], dword 0
    jmp back
