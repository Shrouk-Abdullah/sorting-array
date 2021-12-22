org 100h 
.data
data1 db 02h, 04h , 05h, 06h , 09h , 01h   , 06h
len equ ($-data1) 
.code 
lea si , data1        ; -> offset of array
mov bx, len           ;  -> for nums of elements
cmp bx, 1              ; -> if len ==  1 -> end sorting
jle ennd
ennd:
     endp            
dec bx                   ; cX=5   cx-> len -1
mov cx, bx                     ; cx=bx   cx -> last element  = bx = 5
mov ax, si                     ; ax=si       ax ->first elemnt   ax=0
outer_loop:                   ; loop label
     mov bx, cx                   ;  bx=cx  ->  bx=5
     mov si, ax                   ; si=ax  -> si =0
     mov di, ax                   ;  di=ax    -> di=0=si
     mov dl, [di]                   ; dl=[di]   -> dl = 02

  inner_loop:                 ; loop label
       inc si                     ;  si=si+1 -> si=1,2,4,5,6
       cmp [si], dl               ; compare [si] with dl  ->array[1]=4 , dl =02   ,, array[2] =5] ,dl = 02 ,,array[6] = 01 ,dl=02
       jng skip                  ; jump to label @skip if array [6]<=2   -> if 1<=2
       mov di, si                 ;  di=si   -> di=1 ,6
       mov dl, [di]    
      ; call printArray            ; set dl=[di]   ->dl =array[1] =4
       skip:                     ; jump label               
       dec bx                     ;  bx=bx-1          -> bx=4
       jnz inner_loop              ; jump to label inner_loop if bx!=0    return to innerloop with bx=4
     mov dl, [si]                 ;  dl=[si]  dl =array[6] = 01
     XCHG DL, [DI]                ;  dl=[di] , [di]=dl  -> dl = array[6]=2   ,  
     mov [si], dl               ;  [si]=dl      array[6] = 2
     loop outer_loop               ; jump to label outer_loop while cx!=0
