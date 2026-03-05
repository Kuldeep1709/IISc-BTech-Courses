#include <bits/stdc++.h>
using namespace std;
using namespace std::chrono;

int lcs_bruteForce(string s1, string s2){
	int m = s1.size(), n = s2.size();
	if(m > n){
		swap(m ,n);
		swap(s1, s2);
	}
	if(m > 30){
		cout << "In bruteForce more than 2**30 subSeq possibilities so it will cause stack overflow Error\n";
		return -1;
	}
	
	int total = (1<<m), ans = 0;
	for(int i=0;i<total;i++){
		string subSeq;
		for(int j=0;j<m;j++){
			if(i&(1<<j)) subSeq.push_back(s1[j]);
		}

		int idx = 0, k = 0;
		while(idx < subSeq.size() && k < n){
			if(subSeq[idx] == s2[k]) idx++;
			k++;
		}

		if(idx == subSeq.size()) ans = max(ans, (int)subSeq.size());
	}
	
	return ans;
}

int lcs_recursion(const string &s1, const string &s2, int idx1=0, int idx2=0){
	if(idx1 >= s1.size() || idx2 >= s2.size()) return 0;

	if(s1[idx1] != s2[idx2]){
		int a = lcs_recursion(s1, s2, idx1+1, idx2);
		int b = lcs_recursion(s1, s2, idx1, idx2+1);
		int c = lcs_recursion(s1, s2, idx1+1, idx2+1);

		return max({a, b, c});
	}

	return 1 + lcs_recursion(s1, s2, idx1+1, idx2+1);
}

int lcs_dp(const string &s1, const string &s2){
	int m = s1.size(), n = s2.size();
	vector<vector<int>> dp(m+1, vector<int> (n+1));

	for(int i=0;i<=m;i++) dp[i][0] = 0;
	for(int j=0;j<=n;j++) dp[0][j] = 0;

	for(int i=1;i<=m;i++){
		for(int j=1;j<=n;j++){
			if(s1[i-1] == s2[j-1]) dp[i][j] = dp[i-1][j-1] + 1;
			else dp[i][j] = max({dp[i-1][j], dp[i][j-1], dp[i-1][j-1]});
		}
	}

	return dp[m][n];
}

int main(){
	string s1, s2;
	cout << "Enter the first string : "; cin >> s1;
	cout << "Enter the second string : "; cin >> s2;
		
	// BruteForce timing
    auto start1 = high_resolution_clock::now();
    int ans0 = lcs_bruteForce(s1, s2);
    auto end1 = high_resolution_clock::now();
    auto time1 = duration_cast<microseconds>(end1 - start1);

    // Recursion timing
    auto start2 = high_resolution_clock::now();
    int ans1 = lcs_recursion(s1, s2);
    auto end2 = high_resolution_clock::now();
    auto time2 = duration_cast<microseconds>(end2 - start2);

    // DP timing
    auto start3 = high_resolution_clock::now();
    int ans2 = lcs_dp(s1, s2);
    auto end3 = high_resolution_clock::now();
    auto time3 = duration_cast<microseconds>(end3 - start3);

    cout << "BruteForce : " << ans0 << "  Time: " << time1.count() << " microseconds\n";
    cout << "Recursion  : " << ans1 << "  Time: " << time2.count() << " microseconds\n";
    cout << "DP         : " << ans2 << "  Time: " << time3.count() << " microseconds\n";

	return 0;
}
