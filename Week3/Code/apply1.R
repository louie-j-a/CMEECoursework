#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 10.2017
#Version: 0.0.1 

## apply: applying the same function to rows/colums of a matrix

## Build a random matrix
M <- matrix(rnorm(100), 10, 10)

## Take the mean of each row
RowMeans <- apply(M, 1, mean)
print (RowMeans)

## Now the variance
RowVars <- apply(M, 1, var)
print (RowVars)

## By column
ColMeans <- apply(M, 2, mean)
print (ColMeans)

