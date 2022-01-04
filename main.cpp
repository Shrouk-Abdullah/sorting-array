#include <bits/stdc++.h>
using namespace std;
void swapping(int &a, int &b) {
   int temp;
   temp = a;
   a = b;
   b = temp;
}
void display(int *array, int size) {
   for(int i = 0; i<size; i++)
      cout << array[i] << " ";
   cout << endl;
void printArray(int array[], int size);
int n,x,arr[100];
   
void selectionSort(int *array, int size) {
   int i, j, imin;
   for(i = 0; i<size-1; i++) {
      imin = i;   //get index of minimum data
      for(j = i+1; j<size; j++)
         if(array[j] < array[imin])
            imin = j;
         //placing in correct position
         swap(array[i], array[imin]);
   }
int main() {
cout<<"Enter number of elements to be sorted"<<endl;
cin>>n;                                                                 //scanning number of elements of array
cout<<"Enter elements separated by space and click enter when you finish"<<endl;
for(int i=0;i<n;i++)cin>>arr[i];
cout<<"choose sorting algorithm; enter 0 for bubble sorting or 1 selection sorting"<<endl;
cin>>x;                                                                 //user chooses sorting algorithm
if(x==0){                                                               //bubble sort algorithm
    for (int i = 0; i < n-1; i++){
            for (int j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1]){                                     //comparing between current element and next element to check swapping
                    int temp = arr[j];                                  //defining temp 
                    arr[j] = arr[j+1];                                  //swapping between elements
                    arr[j+1] = temp;
            }
    }

  printArray(arr,n);                                                    //calling print array function
}

else if(x==1){                                                          //selection sort algorithm

  for (int j = 0; j < n - 1; j++) {                                     
    int min_idx = j;                                                    
    for (int i = j + 1; i < n; i++) {
      if (arr[i] < arr[min_idx])                                       //comparing between current element and next element to check swapping
        min_idx = i;
    }
    int temp = arr[min_idx];                                           //defining temp
    arr[min_idx] = arr[j];                                             //swapping between elements
    arr[j]= temp;
  }
  printArray(arr,n);
}


}


                                                              // print array function
void printArray(int arr[], int n) {                           
  for (int i = 0; i < n; ++i) {                              
    cout <<arr[i]<<" ";                                       //printing current element in the array
  }
  cout <<endl;                                                // new line
}
