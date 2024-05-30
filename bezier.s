section .data
    %define x0      xmm3
    %define y0      xmm4
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
    step: dd 0.0001
    one: dd 1.0
    zero: dd 0.0

section .text

global bezier

bezier:
    push rbp
    mov rbp, rsp

    sub rsp, 128
    vmovups [rsp], xmm6
    vmovups [rsp+16], xmm7
    vmovups [rsp+32], xmm8
    vmovups [rsp+48], xmm9
    vmovups [rsp+64], xmm10
    vmovups [rsp+80], xmm11
    vmovups [rsp+96], xmm12

    finit
    mov rax, one
    movss xmm0, dword [rax]     ; xmm0 = 1 - t

    mov rax, zero
    movss xmm1, dword [rax]     ; xmm1 = t

    mov rax, step
    movss xmm2, dword [rax]     ; xmm2 = step

main:
    ucomiss xmm0, xmm2
    jbe end

    cvtsi2ss x0, r8
    cvtsi2ss y0, r9
    cvtsi2ss x1, dword [RBP+48]
    cvtsi2ss y1, dword [RBP+56]
    cvtsi2ss x2, dword [RBP+64]
    cvtsi2ss y2, dword [RBP+72]
    cvtsi2ss x3, dword [RBP+80]
    cvtsi2ss y3, dword [RBP+88]
    cvtsi2ss x4, dword [RBP+96]
    cvtsi2ss y4, dword [RBP+104]

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

    mov eax, 4
    cvtsi2ss xmm13, eax
    mulss x1, xmm13
    mulss y1, xmm13
    mulss x3, xmm13
    mulss y3, xmm13

    mov eax, 6
    cvtsi2ss xmm13, eax
    mulss x2, xmm13
    mulss y2, xmm13

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

    subss xmm0, xmm2
    addss xmm1, xmm2

    cvttss2si r10, xmm13    ; x to draw

    cvttss2si r11, xmm14    ; y to draw
    
    imul r11, width
    add r11, r10
    shl r11, 2
    add r11, bmp
    mov dword [r11], 0xff000000

    jmp main

end:
    vmovups xmm6, [rsp]
    vmovups xmm7, [rsp+16]
    vmovups xmm8, [rsp+32]
    vmovups xmm9, [rsp+48]
    vmovups xmm10, [rsp+64]
    vmovups xmm11, [rsp+80]
    vmovups xmm12, [rsp+96]

    add rsp, 128

    mov rsp, rbp
    pop rbp
    ret
