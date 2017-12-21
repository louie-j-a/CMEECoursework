#include <stdio.h>
#include <stdlib.h>

typedef struct locality{
    float latitude;
    float longitude;
    float elevation;
    char* sitename;
    int siteID;
} locality;

union coord_point {
    float flt_x;
    int int_x;
};//allows type flexibility, works similar to struct but cant simultaneously assign

void record_locality(struct locality* loc){

    //... illustrates passing pointer to struct in function
}
int main (void){


    locality loc1;
    locality loc2;
    locality loc3;
    locality loc4;

    loc1.latitude = 10.30;
    loc1.longitude = -10.0;

    float latitude = 0.0;

    latitude = loc1.latitude;    

    return 0;
}