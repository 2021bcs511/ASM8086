data segment 
    array db 5h, 7h, 2h, 3h
    size db 4h
data ends
code segment
    assume ds:data, cs:code
    start:
    mov ax, data
    mov ds, ax
    
    lea si, array
    inc si    
    mov ch, 1
          
    forloop:
    cmp ch, size
    je setPrint
    
    mov dl, [si]
    mov cl, ch
    sub cl, 1h
    
    mov di, si
    dec di
    
    
    checkloop:
    cmp cl, 0
    jl laststep
    
    mov al, [di]
    mov ah, [si]
    cmp al, ah
    jg swap
    
    jmp laststep
    
    swap:
    mov [di], ah
    mov [si], al
    dec di
    dec si
    dec cl
    jmp checkloop
    
    laststep:
    inc ch
    mov bl, ch
    lea si, array
    jmp setsi
    
    setsi:
    cmp bl, 0h
    je forloop
    inc si
    dec bl
    jmp setsi
    
    setPrint:
    mov cl, size
    lea si, array
    mov dx, 0
    jmp printArray
    
    printArray:
    mov ah, 02
    mov dl, [si]
    add dl, 30h
    inc si
    sub cl, 1h
    int 21h
    jnz printArray
    
    hlt    
code ends
end start
