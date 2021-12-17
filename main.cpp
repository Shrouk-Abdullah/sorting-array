#include <bits/stdc++.h>
using namespace std;
void printArray(int array[], int size);
int n,x,arr[100];
int main() {
cout<<"Enter number of elements to be sorted"<<endl;
cin>>n;
cout<<"Enter elements separated by space and click enter when you finish"<<endl;
for(int i=0;i<n;i++)cin>>arr[i];
cout<<"choose sorting algorithm; enter 0 for bubble sorting or 1 selection sorting"<<endl;
cin>>x;
if(x==0){
    for (int i = 0; i < n-1; i++){
            for (int j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1]){
                    int temp = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = temp;
            }
    }

  printArray(arr,n);
}

else if(x==1){

  for (int j = 0; j < n - 1; j++) {
    int min_idx = j;
    for (int i = j + 1; i < n; i++) {
      if (arr[i] < arr[min_idx])
        min_idx = i;
    }
    int temp = arr[min_idx];
    arr[min_idx] = arr[j];
    arr[j]= temp;
  }
  printArray(arr,n);
}


}


// print array
void printArray(int arr[], int n) {
  for (int i = 0; i < n; ++i) {
    cout <<arr[i]<<" ";
  }
  cout <<endl;
}
