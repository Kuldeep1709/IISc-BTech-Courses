#include <iostream>
#include <stack>

using namespace std;

int minDeleteToMakeBalanced(const string &s){
	int count = 0;
	stack<char> st;

	for(char c: s){
		if(c == '(') st.push(c);
		else{
			if(st.empty()) count++;
			else st.pop();
		}
	}

	return count + st.size();
}

int main(){
	cout << "Enter the String : ";
	string s; cin>>s;

	int minDelete = minDeleteToMakeBalanced(s);

	cout << "Minimum Chars to remove to make string Balanced : " << minDelete << "\n";
}
