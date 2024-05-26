section .text

global f

f:
    push rbp
    mov rbp, rsp
    mov rcx, [rbp+16]  ; Załaduj wskaźnik do ciągu znaków z argumentu funkcji

begin:
    mov al, [rcx]
    test al, al
    jz end
    add al, 1
    mov [rcx], al
    inc rcx
    jmp begin

end:
    mov rsp, rbp
    pop rbp
    ret
