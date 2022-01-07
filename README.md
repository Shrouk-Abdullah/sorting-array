# sorting-array

# Project features
- Choosing of the two most common sorting algorthims (bubble and selection) sort.
- Number of vaules is variable and determined by the user.
- Handling input errors like - or + as input in array size.

# Language Used 
- x86 assembly language
- C++

# Bubble sort
Bubble sort is an internal exchange sort. It is considered one of the simplest methods to sort an array of objects.  It is also known as a sinking sort (because the smallest items "sink" to the bottom of the array). 
Instead of searching an array as a whole, the bubble sort works by comparing adjacent pairs of objects in the array.  If the objects are not in the correct ordered, they are swapped so that the largest of the two moves up.  This process continues until the largest of the objects, eventually "bubbles" up to the highest position in the array.  After this occurs, the search for the  next largest object begins.  The swapping continues until the whole array is in the correct order.
Advantage:   It's Simple.           
Disadvantages:  Very time-consuming, not recommended for long searches.

## Bubble sort algorithm:
![](https://github.com/Shrouk-Abdullah/sorting-array/blob/9737b3552316a6ef6f8fc28f14c7daafcda8bb04/bubble%20sort.png)

## Complexity:
time complxity:
- Average case :o(n^2)
- Worst case :o(n^2)
- best case : o(n)

space complxity:o(1)
 example

- First Pass: 
`( 5 1 4 2 8 ) –> ( 1 5 4 2 8 ), Here, algorithm compares the first two elements, and swaps since 5 > 1. 

( 1 5 4 2 8 ) –>  ( 1 4 5 2 8 ), Swap since 5 > 4 

( 1 4 5 2 8 ) –>  ( 1 4 2 5 8 ), Swap since 5 > 2 

( 1 4 2 5 8 ) –> ( 1 4 2 5 8 ), Now, since these elements are already in order (8 > 5), algorithm does not swap them.`

- Second Pass: 
`( 1 4 2 5 8 ) –> ( 1 4 2 5 8 )

( 1 4 2 5 8 ) –> ( 1 2 4 5 8 ), Swap since 4 > 2 

( 1 2 4 5 8 ) –> ( 1 2 4 5 8 ) 

( 1 2 4 5 8 ) –>  ( 1 2 4 5 8 )`
- Third Pass: 

`( 1 2 4 5 8 ) –> ( 1 2 4 5 8 ) 

( 1 2 4 5 8 ) –> ( 1 2 4 5 8 ) 

( 1 2 4 5 8 ) –> ( 1 2 4 5 8 ) 

( 1 2 4 5 8 ) –> ( 1 2 4 5 8 ) `



# selection sort

The selection sort algorithm sorts an array by repeatedly finding the minimum element (considering ascending order) from unsorted part and putting it at the beginning. The algorithm maintains two subarrays in a given array.
1) The subarray which is already sorted. 
2) Remaining subarray which is unsorted.
In every iteration of selection sort, the minimum element (considering ascending order) from the unsorted subarray is picked and moved to the sorted subarray.

## Selection sort algorithm:
![](https://github.com/Shrouk-Abdullah/sorting-array/blob/142979b99245c3a91cda1123e217ec8d581f3d1f/selection%20sort.png)

# Complexity:
time complxity:
- Average case :o(n^2)
- Worst case :o(n^2)
- Best case : o(n^2)

space complxity:o(1)
don't need to extra space. 

# Advantage :
- simple sorting algorithm.
- in_place algorithm.
- don't need to extra space. 

# Disadvantage :
- takes along time .

# example

- `arr[] = 64 25 12 22 11`

- ` Find the minimum element in arr[0...4]
and place it at beginning
11 25 12 22 64`

- ` Find the minimum element in arr[1...4]
 and place it at beginning of arr[1...4]
11 12 25 22 64`

- ` Find the minimum element in arr[2...4]
and place it at beginning of arr[2...4]
11 12 22 25 64`

- ` Find the minimum element in arr[3...4]
and place it at beginning of arr[3...4]
11 12 22 25 64 `

## Project Tools:
- emu8086

# Resources:
Reference :
Assembly language for x86 processors sixth edition
Youtube playlists:
https://www.youtube.com/watch?v=vtWKlgEi9js&list=PLPedo-T7QiNsIji329HyTzbKBuCAHwNFC

https://www.youtube.com/watch?v=QAJfNoVimjI&list=PLYgImg3VllLpg-3EL4HkHiqzqT8NpGyJ2

tutorial (12 parts):
http://jbwyatt.com/253/emu/asm_tutorial_01.html
http://jbwyatt.com/253/emu/asm_tutorial_02.html
http://jbwyatt.com/253/emu/asm_tutorial_03.html
http://jbwyatt.com/253/emu/asm_tutorial_04.html
http://jbwyatt.com/253/emu/asm_tutorial_05.html
http://jbwyatt.com/253/emu/asm_tutorial_06.html
http://jbwyatt.com/253/emu/asm_tutorial_07.html
http://jbwyatt.com/253/emu/asm_tutorial_08.html
http://jbwyatt.com/253/emu/asm_tutorial_09.html
http://jbwyatt.com/253/emu/asm_tutorial_10.html
http://jbwyatt.com/253/emu/asm_tutorial_11.html
http://jbwyatt.com/253/emu/asm_tutorial_12.html

# Bugs we faced 
- Input size was taking from 0 to 9 only (one digit)
- '-' or '+' signs was taken as array size without prompting errors.

