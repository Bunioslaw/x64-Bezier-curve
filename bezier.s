section .text

global bezier

bezier:
    push rbp
    mov rbp, rsp
    mov rax, rdi

begin:
    mov cl, [rax]
    test cl, cl
    jz end
    add cl, 1
    mov [rax], cl
    inc rax
    jmp begin

end:
    mov rsp, rbp
    pop rbp
    ret
