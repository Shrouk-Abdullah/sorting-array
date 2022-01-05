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