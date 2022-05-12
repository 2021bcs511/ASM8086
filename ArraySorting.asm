data segment
    A dw 3215h, 1100h, 1122h, 3225h, 1211h, 1670h, 4215h, 2711h, 2216h, 7711h
    B dw 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h

    T dw 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h, 0000h

    len db 0Ah
    break db 10, 13, '$'
    endH db 'h$'
    beforeMsg db 'Array A:$'
    afterMsg db 'Array B:$'
    zero db '00$'
    j db 0h
    digit_one db 0h
    digit_two db 0h
    gap db '  $'
data ends

macro printMsg msg
  mov dx, offset msg
  mov ah, 09h
  int 21h
endm

macro printDigit digit
  mov dl, digit
  add dl, 30h
  mov ah, 02h
  int 21h
endm

code segment
 assume ds:data, cs:code
 start:
 mov ax, data
 mov ds, ax
  
 lea si, A
 lea di, T
 mov cl, len
 ;Copying Array into Temp Array
 call copy
 
 ;Preparing for Bubble Sort
 next:
 mov dh, len
 lea si, T
 
 bubbleSort:
 dec dh
 cmp dh, 0h
 je exit
 
 lea si, T
 mov cl, len
 mov j, cl
 mov al, dh
 mov j, al
 dec j
 
 mov dl, j
 mov j, 0h
 
 innerLoop:
 cmp dl, 0h
 je bubbleSort

 mov al, [si]
 mov ah, [si + 1]
 
 mov bl, [si + 2]
 mov bh, [si + 3]

 cmp ax, bx
 jg swap

 jmp endLoop

 swap:
 mov [si + 2], al 
 mov [si + 3], ah
 
 mov [si], bl
 mov [si + 1], bh
 jmp endLoop

 endLoop: 
 dec dl
 inc si
 inc si
 jmp innerLoop
 
 exit:
 lea si, T
 lea di, B
 mov cl, len
 call copy
 
 printMsg beforeMsg
 lea si, A
 mov cl, 0Ah
 mov ch, 10h
 call printArray
 
 printMsg break
 
 printMsg afterMsg
 lea si, B
 mov cl, 0Ah
 mov ch, 10h
 call printArray
 
 hlt 
 
 printArray:
 printMsg gap
 cmp cl, 0h
 je done
 mov dl, [si + 1] 
 cmp dl, 0h   
 je printZero
 
 mov al, dl
 div ch
 mov digit_two, ah
 div ch
 mov digit_one, ah
 printDigit digit_one
 printDigit digit_two
 
 nextDigit: 
 mov dl, [si] 
 cmp dl, 0h   
 je printZero2
 
 mov al, dl
 div ch
 mov digit_two, ah
 div ch
 mov digit_one, ah
 printDigit digit_one
 printDigit digit_two
 
 nextNum:
 printMsg endH
 sub cl, 1h
 inc si
 inc si
 jmp printArray
 
 printZero:
 printMsg zero
 jmp nextDigit
 
 printZero2:
 printMsg zero
 jmp nextNum
 
 done:
 ret
 
 copy:
 cmp cl, 0h
 je done
 mov al, [si]
 mov ah, [si + 1]
 mov [di], al
 mov [di + 1], ah
 inc si
 inc si
 inc di
 inc di
 dec cl
 jmp copy
 
code ends
end start