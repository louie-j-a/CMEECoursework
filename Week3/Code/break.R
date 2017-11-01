#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 10.2017
#Version: 0.0.1 

i <- 0 #Initialize i
while(i < Inf) {
  if (i == 20) {
    break } # Break out of the while loop!
  else {
    cat("i equals " , i , " \n")
    i <- i + 1 # Update i
  }
}
