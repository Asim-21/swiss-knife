#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

typedef int Ty;

int main (int argc, char ** argv)
{
	Ty *ptr = malloc(sizeof(Ty)*5);
	Ty *temp = ptr;
	printf("%d", *temp);
	printf("%d", *temp);
	free(ptr);
}

