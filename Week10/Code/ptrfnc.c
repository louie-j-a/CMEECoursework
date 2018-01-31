#include <stdio.h>
#include <stdlib.h>

int *find_position_in_array(int iarray[], int searchval, int arraymax){

    int *loc = NULL;
    loc = iarray;
    int i = 0;

    while (*loc != searchval){
        ++loc;
        ++i;
        if (i >= arraymax){
            loc = NULL;
            break;
        }
    }

    return loc;
}

int main(void) {

    int integers[] = {1, 4, 7, 8, 9, 11};
    int *loc = NULL;
    int searchval = 5;
    void *avoidptr = NULL;

    loc = find_position_in_array(integers, searchval, 6);

    if (loc != NULL){

    printf("found value: %i at: %p\n", searchval, loc);
    }
    else{
        printf("value %i not found in array\n", searchval);
    }

    return 0;
}