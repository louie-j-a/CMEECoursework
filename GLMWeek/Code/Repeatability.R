rm(list=ls())
setwd("~/CMEECourseWork/GLMWeek/Code/")

d <- read.table("../Data/DataForMMs.txt", header = T)
str(d)

table(table(d$Individual))

require(MCMCglmm)

m <- MCMCglmm(Bodymass ~ 1, random=~Individual, data = d, nitt=1000, burnin=0)
plot(m$Sol)
plot(m$VCV)
