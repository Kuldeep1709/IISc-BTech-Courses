#include <iostream>
#include <vector>
using namespace std;

void quickSort(vector<int> &arr, int l = 0, int r = -4){
	if(r == -4) r = arr.size()-1;
	if(l >= r) return;

	int p = arr[l];
	
	int i = l+1, j = r;
	while(i <= j){
		if(arr[i] < p) i++;
		else if(arr[j] >= p) j--;
		else{
			swap(arr[i], arr[j]);
			i++;
			j--;
		}
	}

	for(int x=l;x<j;x++) arr[x] = arr[x+1];

	arr[j] = p;

	quickSort(arr, l, j-1);
	quickSort(arr, j+1, r);
}

int main(){
	cout << "Enter the size of array : ";
	int n; cin>>n;

	cout << "Enter the elements : ";

	vector<int> arr(n);
	for(int i=0;i<n;i++) cin>>arr[i];

	quickSort(arr);

	cout << "Sorted Array : ";

	for(int x: arr) cout << x << " ";
	cout << "\n";

	return 0;
}
