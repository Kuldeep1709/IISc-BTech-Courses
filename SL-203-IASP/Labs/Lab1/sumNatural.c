#include<stdio.h>

int main(){
	printf("Enter the number : ");
	int n;scanf("%d", &n);

	int sum = n*(n+1)/2;

	printf("Sum : %d \n", sum);

	return 0;
}
