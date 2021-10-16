%include "io.mac"

section .data
    pos dd 0

    ;; needle index
    n_ind dd 0

    ;; haystack index
    h_ind dd 0

section .text
    global my_strstr
    extern printf

my_strstr:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len
    ;; DO NOT MODIFY

    ;; TO DO: Implement my_strstr

    ; (re)initialise the position index for haystack
    mov [pos], dword 0

    ;; needle_len <> haystack_len
    cmp edx, ecx
    jg noStr

getIndex:
    mov [n_ind], dword 0
    mov eax, [pos]
    mov [h_ind], eax

checkSubstr:
    push ecx                            ; haystack_len

    mov ecx, [h_ind]
    mov al, byte [esi + ecx]

    mov ecx, [n_ind]
    mov ah, byte [ebx + ecx]

    pop ecx                             ; haystack_len

    ;; compare the characters
    cmp al, ah
    jne anotherIndex

    ;; if they are equal, keep checking
    inc dword [h_ind]
    inc dword [n_ind]

    cmp [n_ind], edx
    jl checkSubstr

    ;; it gets here --> FOUND a substring at [pos]
    mov ecx, [pos]
    jmp out

anotherIndex:
    add [pos], dword 1

    ;; check if there can by another substring verified
    add [pos], edx
    cmp [pos], ecx
    jg noStr

    ;; continue
    sub [pos], edx
    jmp getIndex


out:
    mov [edi], ecx
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

noStr:
    inc ecx
    jmp out
