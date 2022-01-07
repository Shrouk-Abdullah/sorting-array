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
     LEA DX, Msg1             ; print first message of the program  
     MOV AH, 9                  
     INT 21H                      
    
     LEA SI, Arr              ; si = address of array   
                                
     NULL:        
     
     CALL Array_SizeP         ; call array size function to take input array size  
     AND AX, 00FFH            ; ah=0   
     MOV BX,AX                     
     CMP BX,0                     
     je NotAcceptable         ; if array size = 0, jump to label not acceptable   
     
     LEA DX, Msg2                
     MOV AH, 9                   
     INT 21H                      
     
     CALL READ_ARRAY          ; call read array function to read elements of the array  
     
     LEA DX, Msg4                
     MOV AH, 9                    
     INT 21H                      
    
     LEA SI,Arr               ; si carries array address before calling condition function   
     CALL CONDITION           ; calling condition function to check for type of sort    
 
     NotAcceptable:  
     
     MOV AH, 02h              ; raise beeb error   
     MOV DL, 7H                  
     INT 21H                     
     LEA DX, Msg1             ; print the first message again    
     MOV AH, 9                   
     INT 21H                      
     jmp Null                 ; go back to read the array size again     
     
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
    POP BX                          ;get bx from stak which contains array size
    MOV AX, SI                      ;ax=si (address of the array)
    MOV CX, BX                      ;cx=bx
    PUSH BX                         ;store bx again to the stack to use it in nested loop
    CMP CX,1                        ;check cx=1
    JLE  Skip_Dec                   ;if cx=1 , skip sorting
    DEC CX                          ;cx=cx-1
   
   OUTER_LOOP:                      ;loop1
    MOV BX, CX                      ; bx=cx
    MOV SI, AX                      ; si = address of first element in array
    MOV DI, AX                      ; di = address of first element in array
    INC DI
    INC DI                          ; di = di + 2 ------ di = second element in array
     INNER_LOOP:                    ;loop2
       MOV DX, [SI]                 ;dx=first element
       CMP DX, [DI]                 ;compare between first element and second element
       JNG SKIP_EXCHANGE            ;if it is sorted , skip exchange
       XCHG DX, [DI]                ;if not, exchange
       MOV [SI], DX            
     SKIP_EXCHANGE:             
      INC SI                        ;si=si+2 ----- poit on the next element in array
      INC SI                      
      INC DI
      INC DI                        ;di=di+2 ----- poit on the next element in array
      DEC BX                        ;bx=bx-1 ----- to loop less next time
     JNZ INNER_LOOP              
    LOOP OUTER_LOOP            
   
    Skip_dec:                   
     jmp ENDSORT               

    SELECTION_SORT:
     POP BX                       ; return bx from the stack (containing array size)  
     CMP BX, 1                    ;compare bx to 1
     PUSH BX                      ; push bx to stack                 
     JLE SKIP_SORTING             ; if bx <=1 , skip sorting
     PUSH BX                      ; push bx to the stack to use it in nested loop  
     DEC BX                       ; bx=bx-1 
     MOV CX, BX                   ; cx=bx
     MOV AX, SI                   ; ax=si
     
     OUTER_LOOP2:              
      MOV BX, CX                  ; bx=cx (loop counter)
      MOV SI, AX                  ; si = address of first element in array
      MOV DI, AX                  ; di = address of first element in array
      MOV DX, [DI]                ; dx = first element in array

      INNER_LOOP2:               
       INC SI                     ; si points to next element in array
       INC SI                     
       CMP [SI], DX               ; compare element value of si to dx
       JNG SKIP2                  ; if it is not sorted,skip the iterator change
       MOV DI, SI                 ; di = si (smaller element)
       MOV DX, [DI]               
       SKIP2:                 
       DEC BX                     ; decrease counter of the inner loop
     JNZ INNER_LOOP2              ; if bx != 0 , repeat the inner loop
     MOV DX, [SI]                 ; when inner loop ends temp (dx) = si
     XCHG DX, [DI]                ; swap dx with the di (smallest element)
     MOV [SI], DX                 ; make si (the last element) equal di(the smallest element)
    LOOP OUTER_LOOP2            
   
    SKIP_SORTING:                  
     ENDSORT:                                                  
      LEA DX, Msg6                ;print msg 6 to tell the user his array
      MOV AH, 9             
      INT 21H           
      LEA SI, Arr                 ;si = address of array
      POP BX                      ; pop bx from the stack (array size)
      CALL PRINT_ARRAY            ; call print array to prit the array
      MOV AH, 4CH                 ;terminate the program
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
;-----------------------------  READ_ARRAY  -------------------------------;
 
 READ_ARRAY PROC
 
   PUSH AX                       
   PUSH CX                        
   PUSH DX                        
   
   MOV CX, BX                    
   READARRAY:                    
     CALL DECIMALFORM            
     MOV [SI], AX                
     ADD SI, 2                   
     MOV DL, 0AH                 
     MOV AH, 2                    
     INT 21H                      
   LOOP READARRAY                
   POP DX                        
   POP CX                        
   POP AX                         
   RET                            
   READ_ARRAY ENDP
;----------------------------------PRINT_ARRAY------------------------------ 
 PRINT_ARRAY PROC
  
   PUSH AX                         
   PUSH CX                        
   PUSH DX                        
   MOV CX, BX                     
   PRINTARRAY:                    
     XOR AH, AH                   
     MOV AX, [SI]                 
     CALL OUTDEC                  
     MOV AH, 2                    
     MOV DL, 20H                  
     INT 21H                      

     INC SI                      
     INC SI
   LOOP PRINTARRAY                

   POP DX                         
   POP CX                         
   POP AX                        
   RET                           
 PRINT_ARRAY ENDP
;--------------------------------------------------------------------------  


