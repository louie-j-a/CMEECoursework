#include <stdio.h>
#include <stdlib.h>

//void* malloc(size_t size); // memory allocation
//void* calloc(size_t num_items, size_t of _size); // clear memory allocation, gives memory all set to 0


int main (void){

    int array[5];


    size_t s1;
    size_t s2;
    
    s1 = sizeof(array);
    s2 = sizeof(int);

    printf("The size of char: %zu\n", sizeof(char));
    printf("The size of int: %zu\n", sizeof(int));
    printf("The size of long: %zu\n", sizeof(long));
    printf("The size of float: %zu\n", sizeof(float));
    printf("The size of double: %zu\n", sizeof(double));
    printf("The size of long double: %zu\n", sizeof(long double));
    printf("The size of size_t: %zu\n", sizeof(size_t));
    printf("The size of int: %zu\n", s2);

    int numelements = 5;
    int *myintarray1 = NULL; // always initialise to NULL
    int *myintarray2 = NULL; // always initialise to NULL

    myintarray1 = (int*)malloc(numelements * sizeof(int));
    if (myintarray1 == NULL){
        printf("ERROR: memory allocation failure\n");
        //exit(-1);
        return -1;
    }
    myintarray2 = (int*)calloc(numelements, sizeof(int));
    if (myintarray2 == NULL){
        printf("ERROR: memory allocation failure\n");
        //exit(-1);
        return -1;
    }

    free(myintarray1);
    myintarray1 = NULL;
    free(myintarray2); // frees memory after use
    myintarray2 = NULL;

    return 0;
}