#!/usr/bin/env RScript

library(dplyr)
library(ggplot2)
library(reshape2)

g <- read.table(file = "../Data/H938_chr15.geno", header = T)
head(g)
dim(g) #shows that there are 19560 SNPs in the file

#calculate number of counts for each SNP and add into new column
g <- mutate(g, nObs = nA1A1 + nA1A2 + nA2A2)
head(g)

qplot(nObs, data = g)#can see from graph that most SNPs have complete data
range(g$nObs)#lowest count is 887, below the desired rate of 98.5%

#Compute genotype frequencies
g <- mutate(g, p11 = nA1A1/nObs, p12 = nA1A2/nObs, p22 = nA2A2/nObs)

#compute allele frequencies from genotype frequencies
g <- mutate(g, p1 = p11 + 0.5*p12, p2 = p22 + 0.5*p12)
head(g)

qplot(p1, p2, data=g) # freq A2 vs A1; p2 = 1 - p1

gTidy <- select(g, c(p1, p11, p12, p22)) %>%
  melt(id = "p1", value.name = "Genotype.Proportion")
head(gTidy)
dim(gTidy)

ggplot(gTidy) + geom_point(aes(x = p1, y = Genotype.Proportion,
                               color = variable, shape = variable)) +
  stat_function(fun = function(p) p^2, geom = "line",
                colour = "red", size = 2.5) + stat_function(fun = function(p) 2*p*(1-p), geom = "line", colour = "green", size = 2.5) +
  stat_function(fun = function(p) (1-p)^2, geom = "line",
                colour = "blue", size = 2.5)

#Testing H-W

g <- mutate(g, x2 = (nA1A1 - nObs*p1^2)^2 /(nObs*p1^2) +
                       (nA1A2 - nObs*2*p1*p2)^2 / (nObs*2*p1*p2) + (nA2A2 - nObs*p2^2)^2 / (nObs*p2^2))

g <- mutate(g, pval = 1-pchisq(x2, 1))

head(g$pval)
dim(g)

sum(g$pval < 0.05, na.rm = T)

qplot(pval, data = g)

