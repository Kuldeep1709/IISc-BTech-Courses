#include <bits/stdc++.h>
using namespace std;

class Node {
public:
	string val;
	Node *next;
	
	Node(){}
	Node(string val){
		this->val = val;
		this->next = nullptr;
	}
};

int HASH(const string &s){
	return s.size();
}

void store(const string &key, vector<pair<Node*, Node*>> &hashMap){
	int hash_value = HASH(key);
	
	auto &[head, tail] = hashMap[hash_value];
//	Node *head = p.first;
//	Node *tail = p.second;

	if(head == NULL){
		head = new Node(key);
		tail = head;

		hashMap[hash_value] = {head, tail};

		return;
	}
	
	tail->next = new Node(key);
	tail = tail->next;
}

vector<string> generate_random_emails(int n = 1000) {
    vector<string> emails;

    vector<string> domains = {
        "gmail.com",
        "yahoo.com",
        "outlook.com",
        "hotmail.com",
        "example.com"
    };

    random_device rd;
    mt19937 gen(rd());

    uniform_int_distribution<> len_dist(6, 12);
    uniform_int_distribution<> char_dist(0, 35);
    uniform_int_distribution<> domain_dist(0, domains.size() - 1);

    for (int i = 0; i < n; i++) {
        int len = len_dist(gen);
        string username;

        for (int j = 0; j < len; j++) {
            int r = char_dist(gen);
            if (r < 26)
                username += char('a' + r);
            else
                username += char('0' + (r - 26));
        }

        emails.push_back(username + "@" + domains[domain_dist(gen)]);
    }

    return emails;
}

int main(){
	vector<pair<Node*, Node*>> hashMap(10000, {NULL, NULL});
	vector<string> data = generate_random_emails(10);

	for(const string &str: data) store(str, hashMap);

	for(string str: data) cout << str.size() << " " << str << "\n";

	cout << "\n";

	for(auto ele : hashMap){
		Node* head = ele.first;

		if(head == nullptr) continue;

		while(head != nullptr){
			cout << head->val.size() << " " << head->val << "\n";
			head = head->next;
		}
	}
	return 0;
}
