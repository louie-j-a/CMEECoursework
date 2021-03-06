#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 10.2017
#Version: 0.0.1 

SomeOperation <- function(v){ # (What does this function do?)
  if (sum(v) > 0){ # if sum of v is greater than 0
    return (v * 100) # multiply v by 100
  }
  return (v)
} 
M <- matrix(rnorm(100), 10, 10)
print (apply(M, 1, SomeOperation))