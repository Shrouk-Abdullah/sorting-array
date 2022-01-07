# sorting-array
# selection sort

The selection sort algorithm sorts an array by repeatedly finding the minimum element (considering ascending order) from unsorted part and putting it at the beginning. The algorithm maintains two subarrays in a given array.
1) The subarray which is already sorted. 
2) Remaining subarray which is unsorted.
In every iteration of selection sort, the minimum element (considering ascending order) from the unsorted subarray is picked and moved to the sorted subarray.

# Bubble sort
Bubble sort is an internal exchange sort. It is considered one of the simplest methods to sort an array of objects.  It is also known as a sinking sort (because the smallest items "sink" to the bottom of the array). 
Instead of searching an array as a whole, the bubble sort works by comparing adjacent pairs of objects in the array.  If the objects are not in the correct ordered, they are swapped so that the largest of the two moves up.  This process continues until the largest of the objects, eventually "bubbles" up to the highest position in the array.  After this occurs, the search for the  next largest object begins.  The swapping continues until the whole array is in the correct order.
Advantage:   It's Simple.           
Disadvantages:  Very time-consuming, not recommended for long searches.
## Bubble sort algorithm:
![](https://github.com/Shrouk-Abdullah/sorting-array/blob/9737b3552316a6ef6f8fc28f14c7daafcda8bb04/bubble%20sort.png)

# Complexity:
time complxity:
- Average case :o(n^2)
- Worst case :o(n^2)


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
