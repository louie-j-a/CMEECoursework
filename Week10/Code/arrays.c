#include <stdio.h>

int main (void){
    
    int iarray1[5]; //reserve space for 5 int next to eachother in memory 
    char carray1[10]; //ten chars, cannot go over this number now it has been set, although a comiler wont warn you of this

    int iarray2[] = {2, 5, 2, 4, 7};

    printf("The %i element of iarry1 is: %i\n", 0, iarray1[0]);

    iarray1[0] = 7;

    printf("The %i element of iarry1 is: %i\n", 0, iarray1[0]);

    return 0;

}