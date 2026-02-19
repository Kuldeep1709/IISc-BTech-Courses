#include <iostream>
#include <vector>
using namespace std;

void insertionSort(vector<int> &arr){
	int n = arr.size();
	for(int i=1;i<n;i++){
		int j = i;
		while(j > 0){
			if(arr[j] < arr[j-1]) swap(arr[j], arr[j-1]);
			else break;
			j--;
		}
	}
}

int main(){
	cout << "Enter the size of array : ";
	int n; cin>>n;

	cout << "Enter the elements : ";

	vector<int> arr(n);
	for(int i=0;i<n;i++) cin>>arr[i];

	insertionSort(arr);

	cout << "Sorted Array : ";

	for(int x: arr) cout << x << " ";
	cout << "\n";

	return 0;
}
