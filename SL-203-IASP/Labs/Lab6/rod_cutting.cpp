#include <bits/stdc++.h>
using namespace std;

int rec(const vector<int> &p, int n){
	if(n == 1) return p[0];
	if(n < 1) return 0;

	int ans = 0;
	for(int i=1;i<=n;i++){
		ans = max(ans, p[i-1] + rec(p, n-i));
	}
	return ans;
}

int main(){
	cout << "Enter the length of rod : ";
	int n; cin>>n;	

	cout << "Enter the profit values : ";
	vector<int> p(n);
	for(int i=0;i<n;i++) cin>>p[i];

	int ans = rec(p, n);

	cout << "Maximum Profit : " << ans << "\n";
}
