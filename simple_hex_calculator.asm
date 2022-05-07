data segment
    question db "Q. Write a program to perform calculator. The program should get input (number and operator) from user and perform ADD SUB MUL DIV operations. The result should be displayed to user.", 10, 13, 10, 10, 13, "$"
    message db "Enter Expression: $"
    h_str db "h$"
    gap db "   $"
    break db 10, 10, 13, "$"
    resultIs db "  =  $"
    invalidMsg db 10, 10, 13, "Invalid Operator", 10, 10, 13, "$"
    
    limit db 09h

    operand1 db 0h
    operand2 db 0h
    operator db 0h
    result db 0h    
    check db 0h
    
    add_key db 2Bh
    sub_key db 2Dh
    mul_key db 2Ah
    div_key db 2Fh
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
    
    printMsg question
    
    main:
    
    printMsg message
    
    call readInput
    mov operand1, al
    call readInput
    mov bl, al
    mov al, operand1
    mov cl, 10h
    mul cl
    add al, bl
    ;Final Operand 1 Set  
    mov operand1, al
    
    printMsg h_str
    printMsg gap
    
    call readInput
    add al, 30h
    mov operator, al
        
    printMsg gap
    
    call readInput
    mov operand2, al
    call readInput
    mov bl, al
    mov al, operand2
    mov cl, 10h
    mul cl
    add al, bl
    ;Final Operand 2 Set  
    mov operand2, al
    printMsg h_str
    
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
    mov ah, operand1
    mov al, operand2
    add al, ah
    mov result, al
    call printResult
    
    
    performSub:
    mov ah, operand1
    mov al, operand2
    sub ah, al
    mov result, ah
    call printResult
    
    performMul:
    mov ah, operand1
    mov al, operand2
    mul ah   
    mov result, al
    call printResult
    
    performDiv:
    mov ah, 0
    mov bl, operand2
    mov al, operand1
    div bl
    mov result, al
    call printResult
    
     
    readInput:
    mov ah, 01h
    int 21h
    sub al, 30h
    ret
    
    
    printResult:
    printMsg resultIs
    
    mov ax, 0
    mov al, result
    
    mov cl, 10h
    div cl       
    
    mov bl, al
    
    
    mov dx, 0
    mov bh, ah
    cmp bh, limit 
    jg adjustBH
    add bh, 30h
    jmp next
    
    adjustBH:
    add bh, 37h
    
    next:
    mov al, bl
    mov cl, 10h
    div cl
    
    mov bl, ah
    cmp bl, limit
    jg adjustBL
    add bl, 30h        
    jmp startPrint
    
    adjustBL:
    add bl, 37h
    
    startPrint:
    mov dl, bl    
    mov ah, 02h
    int 21h
    
   
    mov dl, bh
    mov ah, 02h
    int 21h
    
    printMsg h_str
    printMsg break
    
    jmp main
    
    invalidOperator:
    printMsg invalidMsg
    jmp main
    
    
code ends
end start
