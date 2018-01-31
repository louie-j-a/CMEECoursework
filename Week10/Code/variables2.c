#include <stdio.h>

int main (void){

    int x = 3;
    // float y = 4;
    int y = 4;
    float r = 0;
    // int r = 0;

    // r = x+ y;
    // printf("the sum of x and y is: %i\n", r);

    // r = x * y;
    // printf("x times y is equal to: %i\n", r);

    r = y / (float)x;
    printf("the result of dividing %i by %i is: %f\n", y, x, r);

    return 0;
}