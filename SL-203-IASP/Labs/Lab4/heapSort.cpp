#include <iostream>
#include <vector>
using namespace std;

void heapify(vector<int> &arr, int idx, int n){
	int maxi = idx;
	int left = 2*idx + 1;
	int right = 2*idx + 2;

	if(left < n && arr[left] > arr[maxi]) maxi = left;
	if(right < n && arr[right] > arr[maxi]) maxi = right;

	if(maxi != idx){
		swap(arr[idx], arr[maxi]);
		heapify(arr, maxi, n);
	}
}

void heapSort(vector<int> &arr){
	int n = arr.size();
	for(int i=n/2-1;i>=0;i--) heapify(arr, i, n);

	for(int i=n-1;i>=0;i--){
		swap(arr[0], arr[i]);
		heapify(arr, 0, i);
	}
}

int main(){
	cout << "Enter the size of array : ";
	int n; cin>>n;

	cout << "Enter the elements : ";

	vector<int> arr(n);
	for(int i=0;i<n;i++) cin>>arr[i];

	heapSort(arr);

	cout << "Sorted Array : ";

	for(int x: arr) cout << x << " ";
	cout << "\n";

	return 0;
}
