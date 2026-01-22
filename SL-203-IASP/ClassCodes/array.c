#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

int main(void){
    int A[5] = {10, 20, 30, 40, 50};

    // O(1) access
    printf("A[2] = %d \n", A[2]);

    // O(n) Traversal
    for(int i=0;i<5;i++){
        printf("A[%d] = %d \n", i, A[i]);
    }

    return 0;
}