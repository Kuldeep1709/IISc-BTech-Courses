#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct Node{
    int key;
    struct Node *next;
} Node;

Node* new_node(int key){
    Node *p = (Node*)(malloc(sizeof(Node)));

    if(!p) return NULL;

    p->key = key;
    p->next = NULL;

    return p;
}

bool push_front(Node **head, int key){
    Node *p = new_node(key);

    if(!p) return false;

    p->next = *head;
    *head = p;

    return true;
}

Node* list_search(Node *head, int key) {
    for (Node *p = head; p != NULL; p = p->next) {
        if (p->key == key)
            return p;
    }
    return NULL;
}

bool list_insert_after(Node *node, int key) {
    if (!node) return false;

    Node *p = new_node(key);
    if (!p) return false;

    p->next = node->next;
    node->next = p;

    return true;
}


bool list_delete_key(Node **head, int key) {
    Node *prev = NULL;
    Node *curr = *head;

    while (curr && curr->key != key) {
        prev = curr;
        curr = curr->next;
    }

    if(!curr) return false;   // key not found

    if(!prev){
        // deleting head
        *head = curr->next;
    } 
    else{
        prev->next = curr->next;
    }

    free(curr);
    return true;
}