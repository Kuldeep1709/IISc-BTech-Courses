#include <iostream>
#include <vector>
using namespace std;

void bubbleSort(vector<int> &arr){
	int n = arr.size();
	for(int i = n; i > 0; i--){
		for(int j=1;j<i;j++){
			if(arr[j] < arr[j-1]){
				swap(arr[j], arr[j-1]);
			}
		}
	}
}

int main(){
	cout << "Enter the size of array : ";
	int n; cin>>n;

	cout << "Enter the elements : ";

	vector<int> arr(n);
	for(int i=0;i<n;i++) cin>>arr[i];

	bubbleSort(arr);

	cout << "Sorted Array : ";

	for(int x: arr) cout << x << " ";
	cout << "\n";

	return 0;
}
