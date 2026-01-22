#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct {
    int *data;
    int n;
    int cap;
} DynArray;

bool da_init(DynArray *a, int init_cap){
    a->n = 0;
    a->cap = (init_cap > 0) ? init_cap : 4;
    a->data = (int*)malloc(size(int)*a->cap);

    return a->data != NULL;
}

bool da_push(DynArray *a, int x){
    if(a->cap == a->n){
        int new_cap = a->cap *= 2;
        int *p = (int*)realloc(a->data, size(int)* new_cap);

        if(!p) return false;
        a->data = p;
    }

    a-data[a->n] = x;
    a->n++;

    return true;
}

bool array_insert(int A[], int *n, int cap, int pos, int x){
    if(*n > cap) return false;
    if(pos < 0 || pos > *n) return false;

    for(int i=*n;i >= pos;i--){
        A[i+1] = A[i];
    }

    A[pos] = x;
    (*n)++;

    return true;
}

bool array_delete(int A[], int *n, int pos, int *out){
    if(pos < 0 || pos > *n) return false;

    if(out) *out = A[pos];
    for(int i=pos;i < *n - 1;i++){
        A[i] = A[i+1];
    }

    (*n)--;

    return true;
}