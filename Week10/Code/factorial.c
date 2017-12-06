#include <stdio.h>

int calculate_factorial(int n){

    int n_n1;

    if (n) {
        n_n1 = calculate_factorial(n-1);
        return n * n_n1;
    }

    return 1;
}

int main (void){
    
    int i;
    int facts[] = {1, 2, 3, 4, 5, 6};

    for (i = 0; i < 6; ++i) {
        printf("The %i factorial: %i\n", facts[i], calculate_factorial(facts[i]));
    }


    return 0;
}