#include <iostream>
#include <stack>

using namespace std;

int countBalance(const string &s){
	stack<char> st;
	int count = 0, curr = 0;

	for(char c: s){
		if(c == '(') st.push(c);
		else{
			if(st.empty()) return -1;
			st.pop();
			curr ++;
		}

		if(st.empty()){
			count = max(count, curr);
			curr = 0;
		}
	}

	if(st.empty()) return count;
	return -1;
}

int main(){
	cout << "Enter the string : ";
	string s;cin>>s;

	int count = countBalance(s);

	if(count == -1) cout << s << " is Not balanced\n";
	else cout << "Balance count : " << count << "\n";

	return 0;
}
