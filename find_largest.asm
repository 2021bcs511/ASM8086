data segment
    numbers dw 00h, 00h, 00h, 00h, 00h
    highest db 00h
    prompt db "Enter Numbers seprated by space: $"
    message db "Largest is: $"
    break_line db 10, 10, 13, "$"
    
    tempOperand dw 00h    
    max_operand_len db 03h
    maxWarn db 'Max Digit Limit Reached', 10, 10, 13,  '$'
    returnCode db 20h
    tmp_len db 0h
    
    removeWrt db 08h, 08h, 08h, 08h, 20h, 20h, 20h, 20h, 08h, 08h, 08h, 08h, '$'
    
    counter db 0h
    
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
    printMsg prompt
    
    mov counter, 05h    
    lea bp, numbers
    
    readFive:
    cmp counter, 0h
    je findLargest
    
    mov cl, 03h
    mov tmp_len, 0h
    lea si, tempOperand
    call readInput
    
    cmp dx, 00FFh
    jg invalidInput
    
    sub counter, 1h
    mov [bp], dl
    inc bp
    jmp readFive
    
    
    
    readInput:
    cmp tmp_len, cl
    jg max_reached
    mov ah, 01h
    int 21h
    
    lea di, tempOperand
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
    lea di, tempOperand    
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
    
    
    invalidInput:
    printMsg removeWrt
    jmp readFive
    
    
    findLargest:
    lea si, numbers    
    mov cl, 05h 
    
    find:
    cmp cl, 0h
    je printResult
    mov ah, 0h
    mov al, [si]
    
    
    mov dl, highest
    
    cmp highest, al
    js replace
    other:
    inc si
    sub cl, 1h
    jmp find
    
    replace:
    mov highest, al
    jmp other
    
    printResult:    
    printMsg break_line
    printMsg message
    
    mov ax, 0h
    mov al, highest
    mov cl, 0Ah
    mov bh, 02h
    
    setPrint:
    cmp al, 0h
    je startPrint    
    div cl
    mov bl, al    
    mov al, 0h
    mov al, ah
    mov ah, 0h
    push ax
    mov al, bl    
    jmp setPrint
    
    startPrint:
    cmp bh, 0h
    je reset
    pop dx
    add dl, 30h
    mov ah, 02h
    int 21h
    sub bh, 1h
    jmp startPrint
        
    reset:
    printMsg break_line
    jmp main
    
code ends
end start
