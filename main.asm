  .MODEL SMALL
 .STACK 100H
 .DATA
 
    Msg1  DW  ,0AH,0DH,'Please enter size of array :$'
    Msg2  DW  ,0AH,0DH,'Please enter the Array elements:$'  
    Msg3  DW  ,0AH,0DH,'Only positive integer is acceptable $'
    Msg4  DW  'Please choose type of sort, 1: for Bubble sort or 2: for Selection sort:$'  
    Msg5  DW  'Please choose between 1: for Bubble sort or 2: for Selection sort:',0AH,0DH,'$'
    Msg6  DW  ,0AH,0DH,'Your sorted array is:$'
    Arr DW 255 DUP(?)    
 
 .CODE
 
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
    push bx                ; store bx in the stack to use it       
   
    READ_SORT_NUMBER:
 
     mov CX,0              ;making ax,bx,cx=0     
     mov BX,0                
     mov AX,0                   
     
     Mov AH,1                       ;taking input from the user supposed to be 1 or 2 
     INT 21h                     
     
     cmp    al, '-'                 ;check for -ve sign at input
     JE NEGATIVE_INPUT                
     
     cmp al,'+'                     ;check for +ve sign at input
     jE POSITIVE_INPUT                     
     jmp INPUT_ENTER                         
              
    NEGATIVE_INPUT:                 ;if input is -ve jump to error   
     INC CL                      
     JMP BEEB_ERROR                  
   
    POSITIVE_INPUT:                 ;if input is +ve jump to error    
     INC CL                   
     JMP BEEB_ERROR                
                 
    INPUT_ENTER:                    ;taking input from user supposed to be enter  
     MOV BL,AL                      ;saving al in bl, which contains the input number
     MOV AH, 1                 
     INT 21H                    

    SKIP_INPUT0:                    ; if user pressed enter
     CMP AL, 0DH                
     JE END_INPUT0                  ; jump to end input(input is added successfully without errors)

 
    MOVE_BACK0:                     ; code will jump here only if user pressed any button except enter
     MOV AH, 2                         
     MOV DL, 20H                
     INT 21H                        ;erase the last input
     MOV DL, 8H                  
     INT 21H                      
     XOR DX, DX                  
     DEC CL                        
     JMP INPUT_ENTER                       

                                    ;this is used to store multi digit 
     PUSH AX                        ;store ax in stack to use it
     MOV AX, 10                     ;ax=10
     MUL BX                         ;bx=bx*10
     MOV BX, AX                     ;bx=ax
     POP AX                         ;restore ax
     ADD BX, AX                     ;bx=ax+bx
     JS BEEB_ERROR                  ;if sign flag = 1 , jump to error
     JMP INPUT_ENTER                ;else jump to to input enter to take input from the user        
                         
    BEEB_ERROR:                      
     MOV AH, 2                      ; make a beeb
     MOV DL, 7H                     
     INT 21H                     
     
    CLEAR_CHAR:                      
     MOV DL, 8H                     ;delete last input
     INT 21H                        
     MOV DL, 20H                    
     INT 21H                   
     MOV DL, 8H                   
     INT 21H                 
    LOOP CLEAR_CHAR                 ;while cl is not 0 delete one more char 
    JMP READ_SORT_NUMBER            ;jmp read sort number to take input again from the user      
       
   END_INPUT0:               
   
   CHECK_FOR_BUBBLE:                 
    CMP BL,31h                      ;if bl=1 , go to bubble
    JE BUBBLE_SORT              
    JNE CHECK_FOR_SELECTION         ;if not , go to check for selection 

   CHECK_FOR_SELECTION:            
    CMP BL,32h                      ;if bl=2 , go to selection
    JE SELECTION_SORT            
    LEA DX, Msg5                    ;print msg 5 to tell user to enter 1 or 2
    MOV AH, 9                     
    INT 21H                    
    MOV CX,1                   
    Jne BEEB_ERROR                  ;if bl is not equal to 1 or 2, jump back to beeb error
    
   BUBBLE_SORT:
    POP BX                        
    MOV AX, SI               
    MOV CX, BX                 
    PUSH BX                      
    CMP CX,1                
    JLE  Skip_Dec               
    DEC CX                      
   
   OUTER_LOOP:                  
    MOV BX, CX                
    MOV SI, AX                 
    MOV DI, AX                
    INC DI
    INC DI                      
     INNER_LOOP:                 
       MOV DX, [SI]               
       CMP DX, [DI]            
       JNG SKIP_EXCHANGE       
       XCHG DX, [DI]             
       MOV [SI], DX            
     SKIP_EXCHANGE:             
      INC SI 
      INC SI                      
      INC DI
      INC DI                    
      DEC BX                   
     JNZ INNER_LOOP              
    LOOP OUTER_LOOP            
   
    Skip_dec:                   
     jmp ENDSORT               

    SELECTION_SORT:
     POP BX                         
     CMP BX, 1                  
     PUSH BX                                       
     JLE SKIP_SORTING       
     PUSH BX                       
     DEC BX                     
     MOV CX, BX              
     MOV AX, SI              
     
     OUTER_LOOP2:              
      MOV BX, CX                 
      MOV SI, AX                  
      MOV DI, AX                 
      MOV DX, [DI]               

      INNER_LOOP2:               
       INC SI                     
       INC SI                     
       CMP [SI], DX              
       JNG SKIP2                 
       MOV DI, SI                 
       MOV DX, [DI]              
       SKIP2:                 
       DEC BX                 
     JNZ INNER_LOOP2             
     MOV DX, [SI]             
     XCHG DX, [DI]              
     MOV [SI], DX              
    LOOP OUTER_LOOP2            
   
    SKIP_SORTING:                  
     ENDSORT:                                                  
      LEA DX, Msg6            
      MOV AH, 9             
      INT 21H           
      LEA SI, Arr            
      POP BX                     
      CALL PRINT_ARRAY           
      MOV AH, 4CH               
      INT 21H
      MOV AH, 4CH               
      INT 21H
      RET 
  CONDITION ENDP
  
;-------------------DECIMALFORM FUNCTION-------------------------------------------------------------
DECIMALFORM PROC      
    
   PUSH BX                       
   PUSH CX                        
   PUSH DX                        
   JMP ReadInput                   
  
   SkipBackspace:                         
   
   MOV AH, 2                    
   MOV DL, 20H                   
   INT 21H           
   
   ReadInput:                       

   XOR BX, BX                   
   XOR CX, CX                     
   XOR DX, DX                  
   MOV AH, 01H                    
   INT 21H                        
   CMP AL, "-"                    
   JE Negative                      
   CMP AL, "+"                    
   JE Positive                  
   JMP SpecialInput               
   
   Negative:                         
   
   MOV CH, 1                    
   INC CL                         
   JMP Input                   
   
   Positive:                           
   
   MOV CH, 2                      
   INC CL                     
   
   Input:                                 
   
   MOV AH, 01h                    
   INT 21H                    
     
   SpecialInput:                
     
   CMP AL, 0DH              
   JE EndNumber              
   CMP AL, 8H              
   JNE CheckCharacter          
   CMP CH, 0                    
   JNE Remove_negative_sign     
   CMP CL, 0                   
   JE SkipBackspace          
   JMP DeleteCharacter            
     
   Remove_negative_sign:        
     
   CMP CH, 1                  
   JNE Remove_positive_sign     
   CMP CL, 1                
   JE DeleteSign   
             
   Remove_positive_sign: 
            
   CMP CL, 1                    
   JE DeleteSign       
   JMP DeleteCharacter              
     
   DeleteSign:                              
     
   MOV AH, 2                
   MOV DL, 20H                
   INT 21H                    
   MOV DL, 8H                
   INT 21H                    
   JMP ReadInput         
                                         
   DeleteCharacter:                  
     
     MOV AX, BX                   
     MOV BX, 10                   
     DIV BX                       
     MOV BX, AX                   
     MOV AH, 2                    
     MOV DL, 20H               
     INT 21H                     
     MOV DL, 8H                   
     INT 21H                      
     XOR DX, DX                  
     DEC CL                       
     JMP Input                   
     
    CheckCharacter:               
     
     INC CL                       
     CMP AL, 30H                
     JL Error                    
     CMP AL, 39H               
     JG Error              
     AND AX, 000FH                
     PUSH AX  
     MOV AX, 10                   
     MUL BX                      
     MOV BX, AX                  
     POP AX                       
     ADD BX,AX                                          
     JS Error                   
     JMP Input  
                        
   Error:
                          
   MOV AH, 02h                     
   MOV DL, 7H                     
   INT 21H                       
   XOR CH, CH                                
   
   DeleteNumber:                            
   
     MOV DL, 8H                  
     INT 21H                      
     MOV DL, 20H                 
     INT 21H                      
     MOV DL, 8H                   
     INT 21H                     
     LOOP DeleteNumber                   
     JMP readinput                    
   
   EndNumber:                 
   
   CMP CH, 1                      
   JNE Exit                      
   NEG BX                         
   Exit:                        
   MOV AX, BX                     
   POP DX                       
   POP CX                         
   POP BX                         
   RET  
   DECIMALFORM ENDP
;----------------------------------Array_Size_plus-------------------------------;
 Array_SizeP PROC
   PUSH BX                        
   PUSH CX                        
   PUSH DX                        
   JMP ReadInput1                     
   SKIP_BACKSPACE1:              
   MOV AH, 2                      
   MOV DL, 20H                    
   INT 21H                        
   ReadInput1:                        
   XOR BX, BX                     
   XOR CX, CX                     
   XOR DX, DX                     
   MOV AH, 1                      
   INT 21H                        
   CMP AL, "-"                    
   INC CL
   JE printError                     
   CMP AL, "+"                    
   JE Positive1                      
   JMP SpecialInput1                
   Positive1:                        
   MOV CH, 2                      
   INC CL                         
   INPUT1:                       
     MOV AH, 1                    
     INT 21H                      
     SpecialInput1:                
     CMP AL, 0DH                  
     JE END_INPUT1 ;<-----
     CMP AL, 8H    
     JNE NOT_BACKSPACE
     CMP CH, 0                    
     JNE Remove_negative_sign1      
     CMP CL, 0                    
     JE SKIP_BACKSPACE1         
     JMP DeleteCharacter1  
     CMP CL, 1                    
     JE REMOVE_PLUS1   
     Remove_negative_sign1:         
     CMP CL, 1                    
     JE REMOVE_PLUS1             
     JMP DeleteCharacter1              
     REMOVE_PLUS1: 
      MOV AH, 2                  
      MOV DL, 20H                
       INT 21H                    
       MOV DL, 8H                 
       INT 21H                    
       JMP ReadInput                 
                                  
     DeleteCharacter1: 
     MOV AX, BX                   
     MOV BX, 10                   
     DIV BX                       
     MOV BX, AX                   
     MOV AH, 2                    
     MOV DL, 20H                  
     INT 21H                      
     MOV DL, 8H                   
     INT 21H                      
     XOR DX, DX                   
     DEC CL                       
     JMP INPUT1                  
     NOT_BACKSPACE:   
     INC CL                       
     CMP AL, 30H                  
     JL BEEB_ERROR1    
     CMP AL, 39H                  
     JG BEEB_ERROR1                   
     AND AX, 000FH 
     PUSH AX                      
     MOV AX, 10                   
     MUL BX                       
     MOV BX, AX                   
     POP AX                       
     ADD BX, AX                   
     JS BEEB_ERROR1                   
   JMP INPUT1                    
   BEEB_ERROR1: 
   MOV AH, 2                      
   MOV DL, 7H                     
   INT 21H                        
   XOR CH, CH                     
    printError:                      
   LEA DX, Msg3 
   MOV AH, 9
   INT 21H
  RET
   
   CLEAR1:                        
     MOV DL, 8H                    
     INT 21H                       
     MOV DL, 20H                   
     INT 21H                       
     MOV DL, 8H                    
     INT 21H                       
   LOOP CLEAR1                    
   JMP ReadInput                      
   END_INPUT1:                   
   CMP CH, 1                      
  JNE EXIT1                     
 NEG BX                         
   EXIT1:                        
   MOV AX, BX                     
   POP DX                         
   POP CX                         
   POP BX                         
   RET                            
   Array_SizeP ENDP     
