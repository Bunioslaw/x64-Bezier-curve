section .text

global f

f:
    push ebp
    mov ebp, esp
    ; push ebx
    ; push esi
    ; push edi
    mov eax, [ebp+8]
    mov cl, [ebp+12]

get_to_end:
    mov ch, [eax]
    cmp ch, 0
    jz get_to_n_digit

    inc eax
    jmp get_to_end

next_left:
    dec eax
get_to_n_digit:
    mov ch, [eax]
    cmp ch, '0'
    jl next_left
    cmp ch, '9'
    jg next_left

    dec cl
    cmp cl, 0
    jg next_left

    mov edx, [ebp+8]
    mov cl, [ebp+12]
    dec eax

loop:
    inc eax
    mov ch, [eax]
    cmp ch, '0'
    jl loop
    cmp ch, '9'
    jg loop

    mov [edx], ch
    inc edx
    
    dec cl
    cmp cl, 0
    jg loop

    mov [edx], cl

end:
    ; pop edi
    ; pop esi
    ; pop ebx
    mov esp, ebp
    pop ebp
    ret