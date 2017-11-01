#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 10.2017
#Version: 0.0.1 

# Runs the stochastic (with gaussian fluctuations) Ricker Eqn .

rm(list=ls())

stochrick<-function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  for (pop in 1:length(p0)) #loop through the populations ------- this adds time to function by making the below loop have to be carried out on each column separately
  {
    for (yr in 2:numyears) #for each pop, loop through the years
    {
      N[yr,pop]<-N[yr-1,pop]*exp(r*(1-N[yr-1,pop]/K)+rnorm(1,0,sigma))   
    }
  }
  return(N)
}

# Now write another code called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 


rm(list=ls()) # clear workspace

stochrickvect <- function(p0=runif(1000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=100) # sets default arguments for equation
{
  N <- matrix(NA,numyears,length(p0)) # creates matrix to be filled, row numbers = muber of years, columns represent populations
  N[1,] <- p0 # first entry in time series set to p0, the initial population size
  
  for (yr in 2:numyears) # iterate through years (rows) 
  {
    stoch <- rnorm(length(p0), 0, sigma) # sets stochasticity as vector of length equal to that of p0. will be used to quickly asign stochasticity value to each population using formula below
    N[yr,] <- N[yr-1,] * exp(r * (1-N[yr-1,] / K) + stoch) # fills each row in N using the ricker equation
  }
  return(N)
}



print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect())) # tells you how long this script took to run
