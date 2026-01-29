#include<stdio.h>

int main(){
	printf("Enter a Number : ");
	int n;scanf("%d", &n);

	while(n >= 5){
		n /= 2;
	}

	printf("Final Number : %d\n", n);

	return 0;
}
