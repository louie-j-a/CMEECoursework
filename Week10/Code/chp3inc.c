#include<stdio.h>

void main()
{
int a,b,x=10,y=10;

a = x++;
b = ++y;

printf("Value of a : %d\n",a);
printf("Value of b : %d\n",b);
}