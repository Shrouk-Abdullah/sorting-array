  MAIN PROC
  
     MOV AX, @DATA                
     MOV DS, AX                  
     LEA DX, Msg1               
     MOV AH, 9                  
     INT 21H                      
    
     LEA SI, Arr                 
                                
     NULL:        
     
     CALL Array_SizeP           
     AND AX, 00FFH               
     MOV BX,AX                    
     CMP BX,0                     
     je NotAcceptable            
     
     LEA DX, Msg2                
     MOV AH, 9                   
     INT 21H                      
     
     CALL READ_ARRAY            
     
     LEA DX, Msg4                
     MOV AH, 9                    
     INT 21H                      
    
     LEA SI,Arr                  
     CALL CONDITION               
 
     NotAcceptable:  
     
     MOV AH, 02h                 
     MOV DL, 7H                  
     INT 21H                     
     LEA DX, Msg1                 
     MOV AH, 9                   
     INT 21H                      
     jmp Null                      
     
     MOV AH, 4CH                  
     INT 21H                                  
 
  MAIN ENDP
;-------------------CONDITION function-----------------------------------
   CONDITION PROC 
    push bx                       
   
    READ_SORT_NUMBER:
 
     mov CX,0                   
     mov BX,0                
     mov AX,0                   
     
     Mov AH,1                     
     INT 21h                     
     
     cmp    al, '-'             
     JE NEGATIVE_INPUT                
     
     cmp al,'+'                   
     jE POSITIVE_INPUT                     
     jmp INPUT_ENTER                         
              
    NEGATIVE_INPUT:                    
     INC CL                      
     JMP BEEB_ERROR                  
   
    POSITIVE_INPUT:                  
     INC CL                   
     JMP BEEB_ERROR                
                 
    INPUT_ENTER:                    
     MOV BL,AL                   
     MOV AH, 1                 
     INT 21H                    

    SKIP_INPUT0:                
     CMP AL, 0DH                
     JE END_INPUT0                

 
    MOVE_BACK0:                  
     MOV AH, 2                    
     MOV DL, 20H                
     INT 21H                     
     MOV DL, 8H                  
     INT 21H                      
     XOR DX, DX                  
     DEC CL                     
     JMP INPUT_ENTER                       

     
     PUSH AX                      
     MOV AX, 10                   
     MUL BX                       
     MOV BX, AX                   
     POP AX                   
     ADD BX, AX                 
     JS BEEB_ERROR                
     JMP INPUT_ENTER                        
                         
    BEEB_ERROR:                      
     MOV AH, 2                    
     MOV DL, 7H               
     INT 21H                     
     
    CLEAR_CHAR:                      
     MOV DL, 8H                   
     INT 21H                    
     MOV DL, 20H                
     INT 21H                   
     MOV DL, 8H                   
     INT 21H                 
    LOOP CLEAR_CHAR                  
    JMP READ_SORT_NUMBER                  
       
   END_INPUT0:               
   
   CHECK_FOR_BUBBLE:                 
    CMP BL,31h                 
    JE BUBBLE_SORT              
    JNE CHECK_FOR_SELECTION          

   CHECK_FOR_SELECTION:             
    CMP BL,32h                 
    JE SELECTION_SORT            
    LEA DX, Msg5             
    MOV AH, 9                     
    INT 21H                    
    MOV CX,1                   
    Jne BEEB_ERROR                         
