#include <stdio.h>
#include <stdlib.h>

void myfree(int** datptr){

    if (datptr != NULL){
        free(*datptr);
        *datptr = NULL;
    }
    else {
        printf("Warning: attempt to free data already freed\n");
    }
}
int main(void){

    int *somedata = (int*)malloc(10 * sizeof(int));

    // free(somedata);
    //free(somedata); // causes crash, free has danger associated with its use
    // somedata = NULL;
    // myfree(somedata);

    myfree(&somedata);
    myfree(&somedata);

    printf("somedata pointer value: %p\n", somedata);
    return 0;
}
