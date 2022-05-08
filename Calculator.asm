data segment
    operand_one dw 0h, 0h, 0h, 0h 0h, 0h
    max_operand_len db 05h
    maxWarn db 'Max Digit Limit Reached', 10, 10, 13,  '$'
    returnCode db 20h
    tmp_len db 0h
    limit db 09h
    
    
    hex_operand_one dw 0000h
    hex_operand_two dw 0000h
    result dw 0000h 
    
    
    operator db 0h
    
    
    add_key db 2Bh
    sub_key db 2Dh
    mul_key db 2Ah
    div_key db 2Fh 
    
    h_str db "h$"
    gap db "   $"
    break db 10, 10, 13, "$"
    resultIs db "  =  $"
    message db "Enter Expression: $ "
    invalidMsg db 10, 10, 13, "Invalid Operator", 10, 10, 13, "$"
    
data ends 

macro printMsg msg 
    mov ah, 09h
    mov dx, offset msg
    int 21h
endm

code segment 
    assume ds:data, cs:code
    start:
    
    mov ax, data
    mov ds, ax
    
    main:
    printMsg message
    ;Read Operand one
    lea si, operand_one
    mov cl, max_operand_len 
    mov tmp_len, 0h
    call readInput
    mov hex_operand_one, dx
    
    ;Read Operator
    call readOperator                 
    
    ;Read Operand Two
    lea si, operand_one
    mov cl, max_operand_len 
    mov tmp_len, 0h
    call readInput
    mov hex_operand_two, dx
    
    
    mov al, operator
    
    cmp al, add_key
    je performAdd
    
    cmp al, sub_key
    je performSub
    
    cmp al, mul_key
    je performMul
    
    cmp al, div_key
    je performDiv
    
    jmp invalidOperator
        
    performAdd:
    mov ax, hex_operand_one 
    mov bx, hex_operand_two
    add ax, bx
    mov result, ax
    jmp printResult
    
    performSub:
    mov ax, hex_operand_one 
    mov bx, hex_operand_two
    sub ax, bx
    mov result, ax
    jmp printResult
    
    performMul:
    mov ax, hex_operand_one 
    mov bx, hex_operand_two
    mul bx
    mov result, ax
    jmp printResult
    
    performDiv:
    mov ax, hex_operand_one 
    mov bx, hex_operand_two
    cmp bh, 0h
    je div2
    div bx
    mov ah, 0h
    mov result, ax
    jmp printResult  
    div2:
    div bl
    mov ah, 0h
    mov result, ax
    jmp printResult
    
    readInput:
    cmp tmp_len, cl
    je max_reached
    mov ah, 01h
    int 21h
    
    lea di, operand_one
    cmp al, returnCode    
    je convertToHex
        
    sub al, 30h    
    mov [si], 0h
    mov [si + 1], al
    
    inc si
    inc si
    inc tmp_len
    jmp readInput
    
    max_reached:
    printMsg maxWarn
    jmp main
    
    convertToHex:
    mov ch, 1h
    mov cl, tmp_len ;Increasing DI
    mov bl, tmp_len ;Merging Digits
    sub cl, 1h
    inc di
    jmp diToEnd
    
    startHexConvert:    
    cmp tmp_len, 0h
    je performMerge
    mov al, [di]
    mul ch
    mov [di], ax
    mov al, ch
    mov cl, 0Ah
    mul cl
    mov ch, al    
    dec di
    dec di
    sub tmp_len, 1h
    jmp startHexConvert
    
    diToEnd:
    cmp cl, 0h
    je startHexConvert
    inc di
    inc di
    sub cl, 1h
    jmp diToEnd
    
    
    
    performMerge:
    lea di, operand_one    
    inc di
    mov ax, [di]    
    sub bl, 1h
    mov cx, 0h
    jmp startMerge
    
    startMerge:
    cmp bl, 0h
    je returnHexNum
    mov cx, [di + 2]
    add ax, cx
    inc di
    inc di
    sub bl, 1h
    jmp startMerge
    
    returnHexNum:
    mov dx, ax
    ret
    
    
    readOperator:
    mov ah, 01h
    int 21h
    mov operator, al
    printMsg gap
    ret
    
    printResult:
    printMsg resultIs
    mov ax, result
    mov cl, 0Ah
    mov ch, 0h
    
    setDigits:
    cmp al, 0h
    je printDigits
    div cl    
    mov bl, al
    mov al, ah
    mov ah, 0h
    push ax
    mov al, bl
    add ch, 1h
    jmp setDigits
    
    printDigits:
    cmp ch, 0h
    je endPrinting
    pop dx
    add dl, 30h
    mov ah, 02h
    int 21h
    sub ch, 1h
    jmp printDigits
     
    endPrinting: 
    printMsg break
    jmp main
    
    invalidOperator:
    printMsg invalidMsg
    jmp main 
     
code ends  
end start