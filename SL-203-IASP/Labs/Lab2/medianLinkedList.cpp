#include <bits/stdc++.h>
using namespace std;

class Node {
public:
    int val;
    Node* next;
};

double medianLinkedList(Node* head) {
    Node* p = head;
    int n = 0;
    while (p != NULL) {
        n++;
        p = p->next;
    }

    p = head;

    if (n%2 == 1) {
        for (int i=0;i<n/2;i++) {
            p = p->next;
        }

        return (double) (p->val);
    }
    else {
        for (int i=1;i<n/2;i++) {
            p = p->next;
        }

        double mid = (1.0*(p->val + p->next->val))/2;

        return mid;
    }
}

int main() {
    int n;cin>>n;

    if (n == 0) {
        cout << "Linked List is Empty\n";
    }

    Node* head = new Node();
    int x;cin>>x;
    head->val = x;

    Node* curr = head;

    for (int i=1;i<n;i++){
        int x;cin>>x;

        curr->next = new Node();
        curr = curr->next;
        curr->val = x;
    }

    double mid = medianLinkedList(head);

    std::cout<< "Mid is : " << mid<<std::endl;
}