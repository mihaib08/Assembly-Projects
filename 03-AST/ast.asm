section .data
    delim db " ", 10, 0

section .bss
    root resd 1

section .rodata
    ;; sizeof(struct Node)
    size dd 12

section .text

extern check_atoi
extern print_tree_inorder
extern print_tree_preorder
extern evaluate_tree

extern strtok
extern strlen
extern strcpy

extern calloc
extern malloc

global create_tree
global iocla_atoi

iocla_atoi:
    push ebp
    mov ebp, esp

    push ebx
    ;; keep the number sign
    mov ebx, 1

    mov ecx, [ebp + 8]
    xor edx, edx
    xor eax, eax

    ;; check if the number is < 0
    ;; [ecx] == '-'
    mov dl, [ecx]
    cmp dl, '-'
    jne compute_number

mark_sign:
    ;; number < 0
    mov ebx, -1
    inc ecx

compute_number:
    mov dl, [ecx]
    cmp dl, 0
    je out

    ;; add the next digit to eax
    imul eax, 10
    sub edx, '0'
    add eax, edx

    inc ecx
    jmp compute_number

out:
    ;; get the sign
    imul eax, ebx

    pop ebx
    leave
    ret


get_tree_values:
    push ebp
    mov ebp, esp

    push delim
    push eax
    call strtok
    add esp, 8

    push eax
    call strlen

    ;; store the length in ecx
    mov ecx, eax

    ;; malloc a string of length ecx
    push ecx
    call malloc
    add esp, 4

    ;; dest
    mov ecx, eax
    ;; src - word to be written in *data
    mov edx, [esp]

    push edx
    push ecx
    call strcpy
    add esp, 8

    ;; get the address of the current node
    mov edx, [ebp + 8]
    ;; store the string
    mov [edx], eax

    ;; check if *data is a number >= 0
    cmp byte [eax], '0'
    jge is_number

    ;; check if *data is a number < 0
    cmp byte [eax], '-'
    je check_sign_number

get_node:
    ;; calloc the - left - node
    push dword [size]
    push dword 1
    call calloc
    add esp, 8

    mov ecx, [ebp + 8]
    mov [ecx + 4], eax

    mov edx, eax

    ;; get the string back
    pop eax

    ;; jump over the written sign
    add eax, 2

    ;; get the values of the left_subtree
    push edx
    call get_tree_values
    add esp, 4

    ;; push the current string
    push eax

    ;; calloc the - right - node
    push dword [size]
    push dword 1
    call calloc
    add esp, 8

    mov ecx, [ebp + 8]
    mov [ecx + 8], eax

    mov edx, eax

    ;; get the string back
    pop eax

    ;; get the values of the right_subtree
    push edx
    call get_tree_values
    add esp, 4

back:
    leave
    ret

is_number:
    push eax
    call strlen

    ;; store the length
    mov ecx, eax

    pop eax

    ;; get the string back
    pop eax

    ;; jump over the written number
    add eax, ecx
    inc eax

    jmp back

check_sign_number:
    push eax
    call strlen

    ;; store the length
    mov ecx, eax

    pop eax

    cmp ecx, 1
    je get_node

    ;; if greater --> number
    ;; get the string back
    pop eax

    ;; jump over the written number
    add eax, ecx
    inc eax

    jmp back

create_tree:
    enter 0, 0
    xor eax, eax

    push dword [size]
    push dword 1
    call calloc
    add esp, 8
    
    ;; get the first address
    mov [root], eax

    mov edx, eax

    ;; store the string in eax
    mov eax, [ebp + 8]

    cmp dword [eax], 0
    je null_tree

    ;; address where to store the current node
    push edx
    call get_tree_values
    add esp, 4

    mov eax, [root]

return:
    leave
    ret

null_tree:
    xor eax, eax
    jmp return
