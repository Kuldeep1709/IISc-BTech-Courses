#include <stdbool.h>

// Circular Queue

typedef struct {
    int *Q;
    int cap;
    int head;
    int tail;
} Queue;

static int next_i(Queue *q, int i) {
    return (i + 1) % q->cap;
}

bool q_empty(Queue *q) {
    return q->head == q->tail;
}

bool q_full(Queue *q) {
    return next_i(q, q->tail) == q->head;
}

bool q_enqueue(Queue *q, int x) {
    if (q_full(q)) return false;
    q->Q[q->tail] = x;
    q->tail = next_i(q, q->tail);
    return true;
}

bool q_dequeue(Queue *q, int *out) {
    if (q_empty(q)) return false;
    if (out) *out = q->Q[q->head];
    q->head = next_i(q, q->head);
    return true;
}

// Queue Via Linked List

typedef struct {
    Node *head;
    Node *tail;
} LLQueue;

bool llq_enqueue(LLQueue *q, int x) {
    Node *p = new_node(x);
    if (!p) return false;
    if (!q->tail) {
        q->head = q->tail = p;
    } else {
        q->tail->next = p;
        q->tail = p;
    }
    return true;
}

bool llq_dequeue(LLQueue *q, int *out) {
    if (!q->head) return false;
    Node *tmp = q->head;
    if (out) *out = tmp->key;
    q->head = tmp->next;
    if (!q->head) q->tail = NULL;
    free(tmp);
    return true;
}