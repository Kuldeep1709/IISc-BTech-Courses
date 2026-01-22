#include <stdbool.h>

typedef struct {
    int *s;
    int top;
    int cap;
} Stack;

bool st_push(Stack *st, int x) {
    if (st->top == st->cap) return false; // overflow
    st->s[st->top++] = x;
    return true;
}

bool st_pop(Stack *st, int *out) {
    if (st->top == 0) return false; // underflow
    if (out) *out = st->s[--st->top];
    return true;
}

bool st_push_ll(Node **top, int x) {
    return list_push_front(top, x);
}

bool st_pop_ll(Node **top, int *out) {
    if (!*top) return false;
    Node *tmp = *top;
    if (out) *out = tmp->key;
    *top = tmp->next;
    free(tmp);
    return true;
}