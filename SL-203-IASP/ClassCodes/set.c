#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

bool set_contains(const int S[], int n, int x) {
    for (int i = 0; i < n; i++)
        if (S[i] == x) return true;
    return false;
}

bool set_add(int S[], int *n, int cap, int x) {
    if (*n >= cap) return false;
    if (set_contains(S, *n, x)) return true;
    S[(*n)++] = x;
    return true;
}

bool set_remove(int S[], int *n, int x) {
    for (int i = 0; i < *n; i++) {
        if (S[i] == x) {
            S[i] = S[*n - 1];
            (*n)--;
            return true;
        }
    }
    return false;
}

// returns index of x, or -1 if not found
int bin_search(const int A[], int n, int x) {
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (A[mid] == x) return mid;
        if (A[mid] < x) lo = mid + 1;
        else hi = mid - 1;
    }
    return -1;
}