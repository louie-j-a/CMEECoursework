#include <stdio.h>

int main(void){

    int i = 1;
    int counter = 0;

    for (i; counter < 33; ++i){
        if (i % 10 == 0 && i % 7 == 0){
            printf("%i is a multiple of 10 and 7\n", i);
            ++counter;
        }
        else if (i % 10 == 0){
            printf("%i is a multiple of 10\n", i);
            ++counter;
        }
        else if (i % 7 == 0){
            printf("%i is a multiple of 7\n", i);
            ++counter;
        }
    }
    printf("counter is at: %i\n", counter);
}