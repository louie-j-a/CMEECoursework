#include <stdio.h>

int add(int x, int y){

    int result = 0;

    result = x + y;

    return result;
    // return x + y;
}

int quick_add (int x, int y){
//this function is the same as add but is faster
    return x + y;

}


int main (void){
    int a = 5;
    int b = 7;
    int c = 0;


//    c = add(a, b);

    printf("a + b: %i\n", add(a, b));

    return 0;
}