#include<stdio.h>

int main(){
	printf("Enter a Number to Check its Even or Odd : ");
	int n; scanf("%d", &n);

	if(n%2 == 0){
		printf("%d is Even\n", n);
	}
	else printf("%d is Odd\n", n);

	return 0;
}
