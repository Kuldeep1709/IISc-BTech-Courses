#include<iostream>
using namespace std;

int main(){
	string s;cin>>s;

	int i = 0, j = s.size()-1;
	bool palindrome = true;
	while(i <= j){
		if(s[i] != s[j]){
			palindrome = false;
			break;
		}
		i++;
		j--;
	}

	if(palindrome) cout << "Yes\n";
	else cout << "No\n";

	return 0;
}
