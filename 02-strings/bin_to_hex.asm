%include "io.mac"

section .data
    ;; nibble - offset - *bin_sequence
    ct dd 0

    ;; current index of hexa_value
    hex_ind dd 0

section .text
    global bin_to_hex
    extern printf

bin_to_hex:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length
    ;; DO NOT MODIFY

    ;; TODO: Implement bin to hex

    ;; group each 4 bits starting from the end --> find length % 4
    mov eax, ecx
    mov bl, 4
    div bl

    xor ebx, ebx
    mov bl, ah                    ; remainder

    ;; (re)initialise
    xor eax, eax
    mov [ct], dword 0
    mov [hex_ind], dword 0

    push ecx                      ; length

    ;; check if there are any "incomplete" nibbles (< 4 bits)
    xor ecx, ecx
    cmp ecx, ebx
    jl getBits

parseNibbles:
    ;; starting index for "complete" nibbles
    mov [ct], ebx

    pop ecx                       ; length
    cmp ecx, [ct]
    jg calcHexa

end:
    ;; append '\n' (!!)
    mov ebx, 10
    mov eax, [hex_ind]
    mov byte [edx + eax], bl

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

;; parse 4 bits at a time and convert to hex
calcHexa:
    push ecx                      ; length

    ;; MSB is parsed first
    mov ecx, 8
    mov ebx, dword [ct]           ; offset for reading

    ;; parse 4 bits -> 4 characters
    mov eax, dword [esi + ebx]

    ;; reset ebx
    xor ebx, ebx

;; calculate the value of the nibble
getNibble:
    cmp al, '1'
    je addPow

backNibble:
    shr ecx, 1
    shr eax, 8                    ; parse the next bit of the nibble
    test ecx, ecx
    jnz getNibble

    ;; the 4-bit number is parsed
    
    pop ecx                       ; length

    ;; get the value of ebx - 0..9 / A..F
    cmp ebx, 9

    ;; ebx - A..F
    jg getLetter

    ;; ebx - 0..9
    add ebx, 0x30                 ; '0' - 0x30

;; write the the character in hex
printHexa:
    mov eax, [hex_ind]
    mov byte [edx + eax], bl

    add [ct], dword 4
    add [hex_ind], dword 1
    cmp ecx, [ct]
    jg calcHexa

    jmp end

getLetter:
    sub ebx, 10
    add ebx, 0x41                 ; 'A' - 0x41
    jmp printHexa
    

addPow:
    add ebx, ecx
    jmp backNibble

;; ---- calculate the first "incomplete" nibble ----
getBits:
    push ebx                      ; remainder - 1/2/3
    mov ebx, eax

    mov al, byte [esi + ecx]
    shl ebx, 1

    cmp al, '1'
    je addOne

back:
    mov eax, ebx

    inc ecx
    pop ebx
    cmp ecx, ebx
    jl getBits

    ;; eax - 0..9
    add eax, 0x30                  ; convert to char
    mov byte [edx], al
    add [hex_ind], dword 1         ; the first index of hexa_value is set

    ;; parse the rest of the bits
    jmp parseNibbles

addOne:
    add ebx, 1
    jmp back
