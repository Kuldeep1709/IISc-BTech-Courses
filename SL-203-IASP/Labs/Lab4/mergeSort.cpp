#include <iostream>
#include <vector>
using namespace std;

vector<int> helper(vector<int> &arr, int l, int r){
	if(l == r) return {arr[l]};
	else if(l > r) return {};
	
	int m = l + (r-l)/2;

	vector<int> left = helper(arr, l, m);
	vector<int> right = helper(arr, m+1, r);

	vector<int> ans;
	int i = 0, j = 0;
	int p = left.size(), q = right.size();

	while(i < p && j < q){
		if(left[i] < right[j]){
			ans.push_back(left[i]);
			i++;
		}
		else{
			ans.push_back(right[j]);
			j++;
		}
	}

	while(i < p) ans.push_back(left[i++]);
	while(j < q) ans.push_back(right[j++]);

	return ans;
}

void mergeSort(vector<int> &arr){
	arr = helper(arr, 0, arr.size()-1);
}

int main(){
	cout << "Enter the size of array : ";
	int n; cin>>n;

	cout << "Enter the elements : ";

	vector<int> arr(n);
	for(int i=0;i<n;i++) cin>>arr[i];

	mergeSort(arr);

	cout << "Sorted Array : ";

	for(int x: arr) cout << x << " ";
	cout << "\n";

	return 0;
}
