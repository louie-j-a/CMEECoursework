#include <stdio.h>

int main (void){

    // int size = 5;
    // int array1[size];

    // int x;

    //x = array1[size]; // this wouldnt work since array[size] would evaluate to the 6th element of array1 which doesnt exist

    int array1[] = {1, 2, 3, 4, 5, 6};
    int array2[] = {7, 8, 9};
    int array3[9];

    //array3 = array1 + array2; // doesnt work

    array3[0] = array1[0];
    array3[1] = array1[1];
    // and so on...



    return 0;
}

//code not importable, windows compilers may give errors 