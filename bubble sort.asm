
org 100h 

.data
data db 02h, 04h , 05h, 04h , 09h , 01h
len equ ($-data)
index1 dw ?
index2 dw ?
lastIndex dw ?    

.code
mov cx , len
sub cx , 0001h

mov index1 , 0000h

loop1:
    mov bx , index1
    mov al , [data+bx]  
    
    add bx , 0001h
    mov index2 , bx
    
    mov dx, len
    sub dx , bx
    
    mov lastIndex , dx
    
    loop2:
         mov bx , index2
         mov ah ,[data+bx]
         
         cmp al , ah
         jg swap
         jmp not_swap
         swap:
            mov bx , index1
            mov [data+bx] , ah
            
            mov bx , index2
            mov [data+bx] , al
            
            mov al , ah  
            
         not_swap:
            mov bx , lastIndex
            sub bx , 0001h
            mov lastIndex , bx
            
            cmp bx , 0000h
            jle end 
            
            mov bx , index2
            add bx , 0001h
            mov index2 , bx
            jmp loop2
            
    end:
        mov bx , index1
        add bx , 0001h
        mov index1 , bx
        loop loop1
        
        
lea si , data
mov cx ,len

printArray:
       mov dl , [si]
       add dl , 48
       mov ah , 02h
       int 21h
       
       mov dl , 32
       mov ah , 02h
       int 21h
       
       inc si
       loop printArray






