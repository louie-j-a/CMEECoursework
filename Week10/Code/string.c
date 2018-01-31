#include <stdio.h>

int main (void){

   char chararray[] = "This is a string!";
   char cararray[] = {'S', 't', 'r', 'i', 'n', 'g'}; // Not techinaclly a string
   char astring[] = {'S', 't', 'r', 'i', 'n', 'g', '\0'}; //terminal null signal needed to define end of string

   printf("%s\nAnd another %s\n", chararray, astring);
   printf("Printing a string without terminating null: %s\n", cararray);

   return 0;
}