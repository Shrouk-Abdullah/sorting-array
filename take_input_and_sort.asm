.model small
    .stack 100h
    .data 
        msg1 db "Enter array size in range 0:255 and press enter: $",0Ah,0dh
        msg2 db "please enter array elements in range 0:255 and press enter$"   
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        array DB 100 dup (0) 
        TOTAL DB 0
        VALUE DB 0 
        readNum db 0  
        sz db 0    
    .code  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        main proc  
              mov ax,@data
              mov DS,ax  
              
              mov dx,offset msg1
              mov ah,09h           ;; print the message
              int 21h   
              
              call newline
                           
              mov cx,0
              call arr_sz 
              
              call newline
                 
              mov dx,offset msg2
              mov ah,09h           ;; print the message
              int 21h   
              
              call newline
            
              mov dl,13
              mov ah,02h         ;;shit cursor to start of line
              int 21h
            
                
              call input_arr
              mov ah,4ch
              int 21h              

        endp 
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   

 
    proc newline
       mov dl,10      ;;print newline
       mov ah,02h
       int 21h 
       
       mov dl,13
       mov ah,02h
       int 21h
       ret
    endp
    


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        proc arr_sz  
            mov TOTAL,0
            mov VALUE,0
            mov al,0
            mov bl,0       
            call input
            mov al,TOTAL
            mov sz,al   
            ret
        endp
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        proc input_arr    
         lea si,array 
         mov cx,0
         mov cl,sz
         loopx:
         mov TOTAL,0
         mov VALUE,0
         mov al,0
         mov bl,0  
         call input
         mov al,TOTAL
         mov [si],al 
         inc si   
         
         loop loopx: 
         mov dl,10
         mov ah,02h
         int 21h   
         
         mov dl,13
         mov ah,02h
         int 21h
         ret
        endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
proc input  
    READ: 
    MOV AH, 1
    INT 21H
    
    CMP AL, 13
    JE ENDOFNUMBER
    
    MOV VALUE, AL
    SUB VALUE, 48
    
    MOV AL, TOTAL
    MOV BL, 10
    MUL BL
    
    ADD AL, VALUE
    
    MOV TOTAL, AL
    
    JMP READ

    ENDOFNUMBER:
             mov dl,10
         mov ah,02h
         int 21h   
         
         mov dl,13
         mov ah,02h
         int 21h     
ret
endp 



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

END
