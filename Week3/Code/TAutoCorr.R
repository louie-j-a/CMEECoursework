#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 10.2017
#Version: 0.0.1 

data <- load("../Data/KeyWestAnnualMeanTemperature.RData") # load .RData file
data <- ats # access contents of ats (which was in the above file) as "data"

## inspect data
head(data)
str(data)
plot(data)
abline(lm(data$Temp~data$Year))
nrow(data)

corr <- cor(data[1:99, 2], data[2:100, 2], method = "pearson") # find correlation coefficient for temperatures of successive years
corr

## estimate p-value associated with correlation coefficient

corr2 <- vector("numeric", 10000) # make empty vector of size 10,000 to be filled with correlation coefficients of temperatures for random years
for (i in 1:10000){
  corr2[i] <- cor(x = sample(data[1:99, 2], 99, replace = T), 
                  y = sample(data[2:100, 2], 99, replace = T),
                  method = "pearson") #takes years at random and checks for correlation between temperatures of those years. sample() used here to reorder the rows from data
} # repeated 10000 times

pval <- length(corr2[corr2>corr])/length(corr2) # finds the rate at which temperatures of random years are more highly correlated than those of successive years
pval
