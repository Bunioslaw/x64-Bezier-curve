section .data
    %define x0      xmm3    ;r8
    %define y0      xmm4    ;r9
    %define x1      xmm5    ;[RBP+48]
    %define y1      xmm6    ;[RBP+56]
    %define x2      xmm7    ;[RBP+64]
    %define y2      xmm8    ;[RBP+72]
    %define x3      xmm9    ;[RBP+80]
    %define y3      xmm10   ;[RBP+88]
    %define x4      xmm11   ;[RBP+96]
    %define y4      xmm12   ;[RBP+104]
    %define width   rdx
    %define bmp     rcx
    step: dd 0.00001
    one: dd 1.0
    zero: dd 0.0

section .text

global bezier

bezier:
    ; save nonvolatile registers
    push rbp
    mov rbp, rsp
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    
    sub rsp, 160
    movdqu [rsp], xmm6
    movdqu [rsp+16], xmm7
    movdqu [rsp+32], xmm8
    movdqu [rsp+48], xmm9
    movdqu [rsp+64], xmm10
    movdqu [rsp+80], xmm11
    movdqu [rsp+96], xmm12
    movdqu [rsp+112], xmm13
    movdqu [rsp+128], xmm14
    movdqu [rsp+144], xmm15

    ; initialize floats
    mov rax, one
    movss xmm0, dword [rax]     ; xmm0 = 1 - t

    mov rax, zero
    movss xmm1, dword [rax]     ; xmm1 = t

    mov rax, step
    movss xmm2, dword [rax]     ; xmm2 = step

    ; store points in regs
    mov esi, [RBP+48]
    mov edi, [RBP+56]
    mov r10d, [RBP+64]
    mov r11d, [RBP+72]
    mov r12d, [RBP+80]
    mov r13d, [RBP+88]
    mov r14d, [RBP+96]
    mov r15d, [RBP+104]

main:
    ; end if (1-t) < step
    ucomiss xmm0, xmm2
    jb end

    ; initialize points
    cvtsi2ss x0, r8
    cvtsi2ss y0, r9
    cvtsi2ss x1, esi
    cvtsi2ss y1, edi
    cvtsi2ss x2, r10d
    cvtsi2ss y2, r11d
    cvtsi2ss x3, r12d
    cvtsi2ss y3, r13d
    cvtsi2ss x4, r14d
    cvtsi2ss y4, r15d

    ; start calculations
    movss xmm13, xmm0       ; (1-t)
    mulss x3, xmm13
    mulss y3, xmm13

    mulss xmm13, xmm0       ; (1-t)^2
    mulss x2, xmm13
    mulss y2, xmm13

    mulss xmm13, xmm0       ; (1-t)^3
    mulss x1, xmm13
    mulss y1, xmm13

    mulss xmm13, xmm0       ; (1-t)^4
    mulss x0, xmm13
    mulss y0, xmm13

    movss xmm13, xmm1       ; t
    mulss x1, xmm13
    mulss y1, xmm13

    mulss xmm13, xmm1       ; t^2
    mulss x2, xmm13
    mulss y2, xmm13

    mulss xmm13, xmm1       ; t^3
    mulss x3, xmm13
    mulss y3, xmm13

    mulss xmm13, xmm1       ; t^4
    mulss x4, xmm13
    mulss y4, xmm13

    mov rax, 4
    cvtsi2ss xmm13, rax
    mulss x1, xmm13
    mulss y1, xmm13
    mulss x3, xmm13
    mulss y3, xmm13

    mov rax, 6
    cvtsi2ss xmm13, rax
    mulss x2, xmm13
    mulss y2, xmm13

    ; sum up points
    movss xmm13, x0
    addss xmm13, x1
    addss xmm13, x2
    addss xmm13, x3
    addss xmm13, x4

    movss xmm14, y0
    addss xmm14, y1
    addss xmm14, y2
    addss xmm14, y3
    addss xmm14, y4

    ; convert to integers
    cvttss2si rax, xmm13    ; x to draw
    cvttss2si rbx, xmm14    ; y to draw
    
    ; calculate address in memory
    imul rbx, width
    add rbx, rax
    shl rbx, 2
    add rbx, bmp
    mov dword [rbx], 0xff000000

    ; update t and (1-t)
    subss xmm0, xmm2
    addss xmm1, xmm2

    jmp main

end:
    ; restore registers
    movdqu xmm6, [rsp]
    movdqu xmm7, [rsp+16]
    movdqu xmm8, [rsp+32]
    movdqu xmm9, [rsp+48]
    movdqu xmm10, [rsp+64]
    movdqu xmm11, [rsp+80]
    movdqu xmm12, [rsp+96]
    movdqu xmm13, [rsp+112]
    movdqu xmm14, [rsp+128]
    movdqu xmm15, [rsp+144]
    add rsp, 160
    
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
