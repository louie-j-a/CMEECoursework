#include <stdio.h>

int sum_ints_in_array(int[], int); // prototype, allows functions to be defined in any order and can be read over different files

int sum_ints_in_array(int intarray[], int size){
    
    int i = 0;
    int result = 0;

    for (i = 0; i < size; ++i) {
        result += intarray[i]; // same as: result = result + intarray[i] 
    }

    return result;
}



int main (void){

    int integers[] = {2, 4, 6, 8};
    int sum = 0;

    sum = sum_ints_in_array(integers, 7);

    printf("The sum of the elements is: %i\n", sum);

    return 0;
}