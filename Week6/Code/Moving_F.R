#!/usr/bin/env RScript
rm(list=ls())

cargs <- commandArgs(T)
if (length(cargs) < 1){
  infile <- "../Data/H938_chr15.geno"
}
# stop("not enough arguments")
if (length(cargs) > 1) stop("too many arguments, please note that no output file name is required")

infile <- cargs[1] # input data file name
#outfile <- cargs[2] # output file name

library(dplyr)
library(ggplot2)
library(reshape2)



FunctionPEOH <- function(g) {
  g <- read.table(file = g, header = T)
  g <- mutate(g, nObs = nA1A1 + nA1A2 + nA2A2) 
  g <- mutate(g, p11 = nA1A1/nObs, p12 = nA1A2/nObs, p22 = nA2A2/nObs)
  g <- mutate(g, p1 = p11 + 0.5*p12, p2 = p22 + 0.5*p12)
  head(g)
  g <- mutate(g, X2 = (nA1A1-nObs*p1^2)^2 /(nObs*p1^2) + (nA1A2-nObs*2*p1*p2)^2 / (nObs*2*p1*p2) + (nA2A2-nObs*p2^2)^2 / (nObs*p2^2)) 
  g <- mutate(g, pval = 1 - pchisq(X2,1))
  g <- mutate(g, F = (2*p1*(1-p1)-p12) / (2*p1*(1-p1)))
  return(g)
}

movingavg <- function(x, n=5) {stats::filter(x, rep(1/n,n), sides = 2)}

ReadInputFile <- function(genofile) {
  h <- FunctionPEOH(genofile)

  #THEplot <- plot(movingavg(h$F), xlab="SNP number")
  title <- gsub("/|../Data/|.geno","",genofile) #Using gsub to remove parts of name.
    newtitle <- paste0("../Results/",title,"_MovAVG.pdf")
  pdf(newtitle,11.7,8.3)
  plot(movingavg(h$F), xlab="SNP number")
  dev.off()
}

#ReadInputFile("../Data/H938_chr15.geno")
ReadInputFile(infile)


# g <- read.table(file = infile, header = T) #reading in data as a dataframe in R.
#g <- mutate(g, nObs = nA1A1 + nA1A2 + nA2A2) #Adding a column to g, that adds up the number of observations of the three genotypes to get the number of observations. New column is called nObs.
# g <- mutate(g, p11 = nA1A1/nObs, p12 = nA1A2/nObs, p22 = nA2A2/nObs)
# 
# #Compute allele frequencies from genotype frequencies
# g <- mutate(g, p1 = p11 + 0.5*p12, p2 = p22 + 0.5*p12)
# head(g)
# 
# #Testing Hardy-Weinberg
# g <- mutate(g, X2 = (nA1A1-nObs*p1^2)^2 /(nObs*p1^2) + (nA1A2-nObs*2*p1*p2)^2 / (nObs*2*p1*p2) + (nA2A2-nObs*p2^2)^2 / (nObs*p2^2)) 
# 
# g <- mutate(g, pval = 1 - pchisq(X2,1))
# 
# #Plot to see expected vs observed heterozygosity
# qplot(2*p1*(1-p1), p12, data = g) + geom_abline(intercept = 0, slope=1, color="red", size=1.5)



