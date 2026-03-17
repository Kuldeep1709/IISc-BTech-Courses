#include <bits/stdc++.h>
using namespace std;

int knapsack(const vector<int> &weight, const vector<int> &profit, int n, int w, int idx){
	if(idx == n || w <= 0) return 0;
		
	int ans = knapsack(weight, profit, n, w, idx+1);

	if(weight[idx] <= w)
		ans = max(ans, profit[idx] + knapsack(weight, profit, n, w-weight[idx], idx+1));

	return ans;
}

int main(){
	int n,w;
	cout << "Enter the max weight sack can hold : "; cin >> w;
	cout << "Enter the no of objects : "; cin >> n;

	vector<int> profit(n);
	cout << "Enter the profit for each object : ";

	for(int i=0;i<n;i++) cin>>profit[i];

	vector<int> weight(n);
	cout << "Enter the weight of each object : ";

	for(int i=0;i<n;i++) cin>>weight[i];

	int ans = knapsack(weight, profit, n, w, 0);

	cout << "Maximum Profit : " << ans << "\n";

	return 0;
}
