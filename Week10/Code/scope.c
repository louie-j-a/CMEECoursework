#include <stdio.h>

int x;
int i;

int main (void){

    int i = 5;

    {
        int i;  // variable masking, not a good idea, avoid doing this
    }

    return 0
}