#!/usr/bin/env R

### Read in csv file and assign to variable
rm(list=ls())
graphics.off()
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

### load lattice
require("lattice")
### Density plot of predator sizes sorted by feeding interaction type
p <- densityplot(~log(Predator.mass) | Type.of.feeding.interaction, # piped bit tells r to sort by feeding type (makes different graph for each type)
               main = "Predator mass by feeding interaction type", # graph title
               data = MyDF) # tells r to get the data from MyDF
pdf("../Results/Pred_Lattice.pdf") #opens blank pdf named "Pred_Lattice.pdf"
print(p) # prints graph inside new pdf
dev.off() # closes pdf


###  density plot of prey size sorted by feeding interaction, below block of code is similar to above block
q<-densityplot(~log(Prey.mass) | Type.of.feeding.interaction,
               main = "Prey mass by feeding interaction type",
               data = MyDF)
pdf("../Results/Prey_Lattice.pdf")
print(q)
dev.off()


### density plot of predator-prey size ratio sorted by feeding interaction, code is similar to above blocks
r<-densityplot(~log(Predator.mass/Prey.mass) | Type.of.feeding.interaction,
               main = "Predator-prey size ratio by feeding interaction type",
               data = MyDF)
pdf("../Results/SizeRatio_Lattice.pdf")
print(r)
dev.off()


### mean log predator mass by feeding type
MeanPredatorMass <- tapply(log(MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, mean)
### median log predator mass by feeding type
MedianPredatorMass <- tapply(log(MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, median)

### mean log prey mass by feeding type
MeanPreyMass <- tapply(log(MyDF$Prey.mass), MyDF$Type.of.feeding.interaction, mean)
### median log prey mass by feeding type
MedianPreyMass <- tapply(log(MyDF$Prey.mass), MyDF$Type.of.feeding.interaction, median)

### mean log predator-prey size ratio by feeding type
MeanSizeRatio <- tapply(log(MyDF$Predator.mass/MyDF$Prey.mass), MyDF$Type.of.feeding.interaction, mean)
### median log predator-prey size ratio by feeding type
MedianSizeRatio <- tapply(log(MyDF$Prey.mass/MyDF$Predator.mass), MyDF$Type.of.feeding.interaction, median)

### Create data frame with above measures of centrality as columns, rows are by feeding type
CSVDF <- data.frame(MeanPredatorMass, MedianPredatorMass, MeanPreyMass, MedianPreyMass, MeanSizeRatio, MedianSizeRatio)
### Create new data frame with column name for the column of row names. New data frame created (rather than overwriting old data frame) in case we later want to refer to each row by feeding type rather than numbers which will be assigned to rows the next line of code
CSVDF2 <- cbind(FeedingInteractionType = rownames(CSVDF), CSVDF)
### remove row names
rownames(CSVDF2) <- NULL
### write data frame to csv file, row names are now numbers rather than feeding type so we want row.names set to False
write.csv(CSVDF2, "../Results/PP_Results.csv", row.names = F)