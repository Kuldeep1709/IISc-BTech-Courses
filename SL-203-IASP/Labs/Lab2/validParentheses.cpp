#include <bits/stdc++.h>
using namespace std;

class Node {
public:
    int val;
    Node* next;
    Node* prev;
};

bool checkValidParenthesesArray(const string& s) {
    vector<char> v;
    for (int i=0;i<s.size();i++) {
        if (s[i] == '(' || s[i] == '{' || s[i] == '[') {
            v.push_back(s[i]);
        }
        else {
            if (v.empty()) return false;

            if (s[i] == ')') {
                if (v.back() != '(') return false;
            }
            else if (s[i] == '}') {
                if (v.back() != '{') return false;
            }
            else if (s[i] == ']') {
                if (v.back() != '[') return false;
            }
            else return false;

            v.pop_back();
        }
    }

    if (v.size() > 0) return false;
    return true;
}

bool checkValidParenthesesLinkedList(const string& s) {
    if (s.empty()) return true;

    if (s[0] == ')' || s[0] == '}' || s[0] == ']') return false;

    map<char, int> mp;
    mp['{'] = -1; mp['}'] = 1;
    mp['('] = -2; mp[')'] = 2;
    mp['['] = -3; mp[']'] = 3;

    Node* head = new Node();
    head->val = mp[s[0]];
    head->next = nullptr;
    head->prev = nullptr;

    for (int i=1;i<s.size();i++) {
        int curr = mp[s[i]];
        if (curr < 0) {
            if (head == nullptr) {
                Node* p = new Node();
                head = p;
                head->val = curr;
                head->next = nullptr;
                head->prev = nullptr;
            }
            else {
                head->next = new Node();
                Node* p = head;
                head = head->next;
                head->prev = p;
                head->val = curr;
            }
        }
        else {
            if (head == nullptr) return false;
            if (head->val + curr != 0) return false;

            head = head->prev;
            Node* temp = head->next;
            head->next = nullptr;

            delete temp;
        }
    }

    if (head != nullptr) return false;
    return true;
}

bool checkValidParenthesesStack(const string &s) {
    stack<char> st;
    for (int i=0;i<s.size();i++) {
        if (s[i] == '(' || s[i] == '{' || s[i] == '[') {
            st.push(s[i]);
        }
        else {
            if (st.empty()) return false;

            if (s[i] == ')') {
                if (st.top() != '(') return false;
            }
            else if (s[i] == '}') {
                if (st.top() != '{') return false;
            }
            else if (s[i] == ']') {
                if (st.top() != '[') return false;
            }
            else return false;

            st.pop();
        }
    }
    if (st.size() > 0) return false;
    return true;
}

int main() {
    string s;cin>>s;

    bool valid1 = checkValidParenthesesArray(s);
    bool valid2 = checkValidParenthesesLinkedList(s);
    bool valid3 = checkValidParenthesesStack(s);

    cout << "Using Array : ";

    if (valid1) {
        cout << "Yes " << s << " s is valid parentheses\n";
    }
    else {
        cout << "No " << s << " s is not a valid parentheses\n";
    }

    cout << "Using LinkedList : ";

    if (valid2) {
        cout << "Yes " << s << " s is valid parentheses\n";
    }
    else {
        cout << "No " << s << " s is not a valid parentheses\n";
    }

    cout << "Using Stack : ";

    if (valid3) {
        cout << "Yes " << s << " s is valid parentheses\n";
    }
    else {
        cout << "No " << s << " s is not a valid parentheses\n";
    }

}