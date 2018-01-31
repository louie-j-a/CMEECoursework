#include <stdio.h>

int main (void){

    int x = 5;
    char y = 'q';
    float z = 5.5;
    int a = 'a';  // assigns integer to character

    y = y - 2;
    x = x + 'e';
    z = z - x;
    a = a -3;

    printf("The value of x is %i\n", x);
    printf("The value of y is is: %c\n", y);
    printf("The value of x is %f\n", z);
    printf("The value of x is %i\n", a);

    return x;
}