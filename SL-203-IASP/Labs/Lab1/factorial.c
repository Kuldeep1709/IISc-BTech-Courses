#include<stdio.h>

int main(){
	printf("Enter the number : ");
	int n;scanf("%d", &n);

	int fact = 1;

	for(int i=2;i<=n;i++){
		fact *= i;
	}

	printf("Factorial : %d\n", fact);

	return 0;
}
