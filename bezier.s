section .data
    %define x0      xmm3
    %define y0      xmm4
    %define x1      xmm5    ;[RBP+48]
    %define y1      xmm6    ;[RBP+56]
    %define x2      xmm7    ;[RBP+64]
    %define y2      xmm8    ;[RBP+72]
    %define x3      xmm9    ;[RBP+80]
    %define y3      xmm10    ;[RBP+88]
    %define x4      xmm11   ;[RBP+96]
    %define y4      xmm12   ;[RBP+104]
    %define width   rdi
    %define bmp     rcx
    step dq 0.01
    one dq 1
    zero dq 0

section .text

global bezier

bezier:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    sub rsp, 128
    vmovdqu [rsp], xmm6
    vmovdqu [rsp+16], xmm7
    vmovdqu [rsp+32], xmm8
    vmovdqu [rsp+48], xmm9
    vmovdqu [rsp+64], xmm10
    vmovdqu [rsp+80], xmm11
    vmovdqu [rsp+96], xmm12
    vmovdqu [rsp+112], xmm13
    vmovdqu [rsp+128], xmm14
    vmovdqu [rsp+144], xmm15

    cvtsi2sd xmm3, r8
    cvtsi2sd xmm4, r9
    mov rax, [RBP+48]
    cvtsi2sd xmm5, rax
    mov rax, [RBP+56]
    cvtsi2sd xmm6, rax
    mov rax, [RBP+64]
    cvtsi2sd xmm7, rax
    mov rax, [RBP+72]
    cvtsi2sd xmm8, rax
    mov rax, [RBP+80]
    cvtsi2sd xmm9, rax
    mov rax, [RBP+88]
    cvtsi2sd xmm10, rax
    mov rax, [RBP+96]
    cvtsi2sd xmm11, rax
    mov rax, [RBP+104]
    cvtsi2sd xmm12, rax
    
    ; fninit
    mov rax, one
    movsd xmm0, qword [rax]     ; xmm0 = 1 - t

    mov rax, zero
    movsd xmm1, qword [rax]     ; xmm1 = t

    mov rax, step
    movsd xmm2, qword [rax]     ; xmm2 = step


main:
    ucomisd xmm0, qword [step]
    jb end

    movsd xmm13, xmm0       ; (1-t)
    mulsd x3, xmm13
    mulsd y3, xmm13

    mulsd xmm13, xmm0       ; (1-t)^2
    mulsd x2, xmm13
    mulsd y2, xmm13

    mulsd xmm13, xmm0       ; (1-t)^3
    mulsd x1, xmm13
    mulsd y1, xmm13

    mulsd xmm13, xmm0       ; (1-t)^4
    mulsd x0, xmm13
    mulsd y0, xmm13

    movsd xmm13, xmm1       ; t
    mulsd x1, xmm13
    mulsd y1, xmm13

    mulsd xmm13, xmm1       ; t^2
    mulsd x2, xmm13
    mulsd y2, xmm13

    mulsd xmm13, xmm1       ; t^3
    mulsd x3, xmm13
    mulsd y3, xmm13

    mulsd xmm13, xmm1       ; t^4
    mulsd x4, xmm13
    mulsd y4, xmm13

    mov rax, 4
    cvtsi2sd xmm13, rax
    mulsd x1, xmm13
    mulsd y1, xmm13
    mulsd x3, xmm13
    mulsd y3, xmm13

    mov rax, 6
    cvtsi2sd xmm13, rax
    mulsd x2, xmm13
    mulsd y2, xmm13

    movsd xmm13, x0
    addsd xmm13, x1
    addsd xmm13, x2
    addsd xmm13, x3
    addsd xmm13, x4

    movsd xmm14, y0
    addsd xmm14, y1
    addsd xmm14, y2
    addsd xmm14, y3
    addsd xmm14, y4

    cvttsd2si rdx, xmm13    ; x to draw

    cvttsd2si rbx, xmm14    ; y to draw

    mov r13, rdx
    ; add r12, rdx

    shl rdx, 2
    mov rax, width
    mul rbx
    shl rbx, 2
    add rdx, rbx
    shl rdx, 2
    add rdx, rcx
    mov dword[rdx], 0xff00ffff

    subsd xmm0, xmm2
    addsd xmm1, xmm2

    
    mov rax, r13
    jmp main

end:
    vmovdqu xmm6, [rsp]
    vmovdqu xmm7, [rsp+16]
    vmovdqu xmm8, [rsp+32]
    vmovdqu xmm9, [rsp+48]
    vmovdqu xmm10, [rsp+64]
    vmovdqu xmm11, [rsp+80]
    vmovdqu xmm12, [rsp+96]
    vmovdqu xmm13, [rsp+112]
    vmovdqu xmm14, [rsp+128]
    vmovdqu xmm15, [rsp+144]
    add rsp, 128

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
