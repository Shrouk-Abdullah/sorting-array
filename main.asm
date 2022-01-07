  .MODEL SMALL
 .STACK 100H
 .DATA
 
    Msg1  DW  ,0AH,0DH,'Please enter size of array :$'        ;define output messages
    Msg2  DW  ,0AH,0DH,'Please enter the Array elements:$'  
    Msg3  DW  ,0AH,0DH,'Only positive integer is acceptable $'
    Msg4  DW  'Please choose type of sort, 1: for Bubble sort or 2: for Selection sort:$'  
    Msg5  DW  'Please choose between 1: for Bubble sort or 2: for Selection sort:',0AH,0DH,'$'
    Msg6  DW  ,0AH,0DH,'Your sorted array is:$'
    Arr DW 255 DUP(?)                 ; define array with size 255 and random values
 
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
     XOR DX, DX                      ; set the value of DX = 0
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
;this function reads a decimal number
DECIMALFORM PROC      
    
   PUSH BX                        ;push BX into stack                     
   PUSH CX                        ;push CX into stack   
   PUSH DX                        ;push DX into stack   
   JMP ReadInput                   
  
   SkipBackspace:                         
   
   MOV AH, 02H                    ;set AH=02H
   MOV DL, 20H                    ;set DL=20H, ascii code of ' '
   INT 21H                        ;interrupt 21H prints a character
   
   ReadInput:                       

   XOR BX, BX                     ;BX=0
   XOR CX, CX                     ;CX=0
   XOR DX, DX                     ;DX=0
   MOV AH, 01H                    ; set AH=01H
   INT 21H                        ; reads a character
   CMP AL, "-"                    
   JE Negative                    ; if AL="-" jump to Negative label  
   CMP AL, "+"                    
   JE Positive                    ;if AL="+" jump to Positive label
   JMP SpecialInput               ; jump to SpecialInput label
   
   Negative:                         
   
   MOV CH, 1                      ; set CH=1
   INC CL                         ;increment CL, CL=CL+1
   JMP Input                      ; jump to label input
   
   Positive:                           
   
   MOV CH, 2                      ;set CH=2
   INC CL                         ; increment CL
   
   Input:                                 
   
   MOV AH, 01H                    ; set AH=01H                    
   INT 21H                        ; read a character
     
   SpecialInput:                
     
   CMP AL, 0DH                    ; 0DH is the carriage return character, (if it's the end of number)
   JE EndNumber                   ; jump to label EndNumber
   CMP AL, 08H                     ; compare AL with zero
   JNE CheckCharacter             ;if AL!=0, jump to CheckCharacter
   CMP CH, 0                      ; compare CH with 0
   JNE Remove_negative_sign       ; if CH not equal 0, jump to Remove_negativ_sign label
   CMP CL, 0                      ; compare CL with 0
   JE SkipBackspace               ; if CL=0,jump SkipBackspace label
   JMP DeleteCharacter            ; jump to DeleteCharacter label
     
   Remove_negative_sign:        
     
   CMP CH, 1                      ; compare CH with 1
   JNE Remove_positive_sign       ; if CH not equal 1, jump to Remove_positive_sign
   CMP CL, 1                      ;compare CL with 1
   JE DeleteSign                  ; jump to DeleteSign if CL equal 1
             
   Remove_positive_sign: 
            
   CMP CL, 1                      ;compare CL with 1  
   JE DeleteSign                  ; if CL=1 jump to DeleteSign label
   JMP DeleteCharacter            ; jump DeleteCharacter label  
     
   DeleteSign:                              
     
   MOV AH, 02H                    ;set AH=2H
   MOV DL, 20H                    ;set DL=' ' 
   INT 21H                        ;interrupt 21H to print a character
   MOV DL, 08H                    ;set DL= backspace 
   INT 21H                        ; print a character
   JMP ReadInput                  ; jump to ReadInput label
                                         
   DeleteCharacter:                  
     
     MOV AX, BX                   ;move value of BX into AX  
     MOV BX, 10                   ; set BX=10
     DIV BX                       ; AX=AX/BX
     MOV BX, AX                   ; move value of AX in BX
     MOV AH, 02H                  ; set AX=2H  
     MOV DL, 20H                  ; set DL=' '
     INT 21H                      ; print a character
     MOV DL, 8H                   ; set DL= backspace
     INT 21H                      ; print a character
     XOR DX, DX                   ; clear DX
     DEC CL                       ; decrement CL, CL=CL-1
     JMP Input                    ; jump to Input label
     
    CheckCharacter:               
     
     INC CL                       ;increment CL
     CMP AL, 30H                  ; compare AL with 0
     JL Error                     ; jump Error label if AL<0
     CMP AL, 39H                  ; compare AL with 9
     JG Error                     ; jump to Error label if AL>9
     AND AX, 000FH                ; convert ascii to decimal
     PUSH AX                      ; push AX into stack
     MOV AX, 10                   ; set AX=10
     MUL BX                       ; AX=AX*BX
     MOV BX, AX                   ; BX=AX
     POP AX                       ; pop value from stack into AX
     ADD BX,AX                    ; BX=BX+AX                                     
     JMP Input                    ; jump to label Input
                        
   Error:
                          
   MOV AH, 02H                    ;set AH=2H
   MOV DL, 7H                     ; sounds of bell
   INT 21H                         
   XOR CH, CH                     ; clear CH          
   
   DeleteNumber:                            
   
     MOV DL, 08H                  ;set DL=backspace
     INT 21H                      ; print a character
     MOV DL, 20H                  ;set DL=' '
     INT 21H                      ;print a character
     MOV DL, 08H                  ; set DL=backspace 
     INT 21H                      ; print a character
     LOOP DeleteNumber            ; Loop till CX=0       
     JMP ReadInput                ; jump to ReadInput label    
   
   EndNumber:                 
   
   CMP CH, 1                      ;compare CH=1
   JNE Exit                       ;jump to Exit label if CH!=1
   NEG BX                         ;negate BX, make it in its two's complement form 
   Exit:                        
   MOV AX, BX                     ;AX=BX
   POP DX                         ;pop a value from srack into DX register
   POP CX                         ;pop a value from srack into CX register
   POP BX                         ;pop a value from srack into BX register
   RET  
   DECIMALFORM ENDP
;----------------------------------Array_Size_plus-------------------------------;
 Array_SizeP PROC
   PUSH BX                        ;push bx,cx,dx to stack
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
   
   ;--------------------------------  SIGNED  --------------------------------;
   
SIGNED PROC
   PUSH BX                        
   PUSH CX                        
   PUSH DX                        

   CMP AX, 0                      
   JGE START                     

   PUSH AX                        

   MOV AH, 2                      
   MOV DL, "-"                    
   INT 21H                        

   POP AX                         

   NEG AX                         

   START:                        

   XOR CX, CX                     
   MOV BX, 10                     

   OUTPUT:                       
     XOR DX, DX                   
     DIV BX                       
     PUSH DX                      
     INC CX                       
     OR AX, AX                    
   JNE OUTPUT                    

   MOV AH, 2                      

   DISPLAY:                      
     POP DX                       
     OR DL, 30H                   
     INT 21H                      
   LOOP DISPLAY                  
   
   POP DX                         
   POP CX                         
   POP BX                         

   RET                            
 SIGNED ENDP
;-----------------------------  READ_ARRAY  -------------------------------;
 ;this function read the elements in an array
  ;   SI=offset  of the array
   ;  BX=size of the array
   ;input ( SI and  BX )
   
 READ_ARRAY PROC
 
   PUSH AX                        ;push AX into stack 
   PUSH CX                        ;push CX into stack
   PUSH DX                        ;push DX into stack
   
   MOV CX, BX                    ;PUT value of BX in CX
   READARRAY:                    ;LOOP &  READARRAY is a label
     CALL DECIMALFORM            ; call function DECIMALFORM 
     MOV [SI], AX                ; set [SI]=AX
     ADD SI, 2                   ; set SI=SI+2
     MOV DL, 0AH                 
     MOV AH, 2                   ; set output function 
     INT 21H                     ; print a character
   LOOP READARRAY                ; if(CX!=0), jump to label READARRAY
   POP DX                        ; pop a value from STACK into DX
   POP CX                        ; pop a value from STACK into CX
   POP AX                        ; pop a value from STACK into AX
   RET                           ; return  
   READ_ARRAY ENDP               ; End function
;----------------------------------PRINT_ARRAY------------------------------ 
 ;this function print the elements of a given array
 ;   SI=offset  of the array
   ;  BX=size of the array
   ;input ( SI and  BX )
 
PRINT_ARRAY PROC
  
   PUSH AX                       ;push AX into stack 
   PUSH CX                       ;push CX into stack 
   PUSH DX                       ;push DX into stack 
   MOV CX, BX                    ;PUT value of BX in CX
   PRINTARRAY:                   ;LOOP &  PRINTARRAY is a label
     XOR AH, AH                  ; clear AH,AH=0
     MOV AX, [SI]                ; set AL=[SI]
     CALL SIGNED                 ; call function SIGNED 
     MOV AH, 2                   ;set AH=2
     MOV DL, 20H                 ;set DL=20H, ascii code of ' '                
     INT 21H                     ;interrupt 21H prints a character     

      INC SI                       ; set SI=SI+1
     INC SI                        ; set SI=SI+1
   LOOP PRINTARRAY               ; if(CX!=0), jump to label PRINTARRAY

   POP DX                        ; pop a value from STACK into DX
   POP CX                        ; pop a value from STACK into CX
   POP AX                        ; pop a value from STACK into AX
   RET                           ; return
 PRINT_ARRAY ENDP                ; End function
;--------------------------------------------------------------------------  

 END MAIN
