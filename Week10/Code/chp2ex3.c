#include <stdio.h>

int main (void)
{

  int x = 1;
  //int x = 'a'; //chp2 ex4
  int b = 999999999; // chp2 ex 5
  char y = 'T';
  float z = 1.1;
  double a = 100.2;

  printf("The value of x: %i\n", x);
  printf("The value of b: %i\n", b);  
  printf("The value of y: %c\n", y);
  printf("The value of z: %f\n", z);
  printf("The value of a: %e\n", a);

  return x;

}