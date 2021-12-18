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
