#include<stdio.h>
#include <string.h>
#include <stdbool.h>

#define MAX_LEN 100 // Will not work if input string length is > 100

int main(){
	printf("Enter String : ");
	char s[MAX_LEN];
	
	fgets(s, MAX_LEN, stdin);

	int i = 0, j = strlen(s)-2;
	bool palindrome = true;
	while(i <= j){
		if(s[i] != s[j]){
			palindrome = false;
			break;
		}
		i++;
		j--;
	}

	if(palindrome){
		printf("Palindrome\n");
	}
	else{
		printf("Not Palindrome\n");
	}


	return 0;
}
