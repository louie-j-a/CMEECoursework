#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 02.2018
#Version: 0.0.1

#doesn't print warnings when workflow is ran on terminal
options(warn=-1)

# clear current workspace
rm(list=ls())


# read in data produced in TPCfitting.py
data <- read.csv("../Data/fittedData.csv", header = T)
# str(data)


# remove column of row numbers added in python
data <- subset(data, select=-c(X))


# how many converged for each model
convergedFull <- subset(data, AICFullMod != "NA")

proportionConvergedFull <- length(unique(convergedFull$MyID))/length(unique(data$MyID))
meanRsquaredFull <- mean(convergedFull$RsquaredFullMod)   


convergedHigh <- subset(data, AIChighMod != "NA")

proportionConvergedHigh <- length(unique(convergedHigh$MyID))/length(unique(data$MyID))
meanRsquaredHigh <- mean(convergedHigh$RsquaredHighMod)   


convergedLow <- subset(data, AIClowMod != "NA")

proportionConvergedLow <- length(unique(convergedLow$MyID))/length(unique(data$MyID))
meanRsquaredLow <- mean(convergedLow$RsquaredLowMod)   


convergedCubic <- subset(data, AICcubicMod != "NA")

proportionConvergedCubic <- length(unique(convergedCubic$MyID))/length(unique(data$MyID))
meanRsquaredCubic <- mean(convergedCubic$RsquaredCubicMod)   



# compare AIC scores for Full and partial Schoolfield models, and cubic model for each id
# one model is better than another if its AIC is lower by 2
# if difference in AIC scores if less than 2, the model with fewer parameterse is chosen instead

for (i in unique(data$MyID)){
  # subset data into group of interest
  sub = subset(data, MyID == i)
  
  # store AIC values for each model 
  AICs <- c(sub$AICFullMod[1], sub$AIChighMod[1], sub$AIClowMod[1] , sub$AICcubicMod[1])
 
  # to deal with NA's in data, replace any NA's with higher AICs than max(AICs)
  AICs[which(is.na(AICs))] <- max(AICs[which(AICs != "NA")]) + 10
  
  # name each AIC 
  names(AICs) <- c("Full", "High", "Low", "Cubic")
  
  # sort the AICs in ascending order
  AICs <- sort(AICs)
  
  # extract lowest AIC scores
  if (AICs[2] - AICs[1] >= 2){
    BestAIC <- AICs[1]
  } else if (AICs[3] - AICs[1] >= 2){
    BestAIC <- AICs[1:2]
  } else if (AICs[4] - AICs[1] >= 2){
    BestAIC <- AICs[1:3]
  } else {
    BestAIC <- AICs[1:4]
  }
  
  # Now sort by lowest number of parameters 
  # Since the high and low Schoolfield models and the cubic model have 4 parameters, while the full Schoolfield has 6, only the full Schoolfield model can be excluded due to having more parameters than other models
  
  if ((length(BestAIC)>1) & ("Full" %in% names(BestAIC))){
    BestAIC <- BestAIC[-which(BestAIC==BestAIC["Full"])]
  }
  
  # add this information to new columns in data
  data$Model1[data$MyID == i] <- names(BestAIC[1])
  data$AIC1[data$MyID == i] <- BestAIC[1]
  
  data$Model2[data$MyID == i] <- names(BestAIC[2])
  data$AIC2[data$MyID == i] <- BestAIC[2]
  
  data$Model3[data$MyID == i] <- names(BestAIC[3])
  data$AIC3[data$MyID == i] <- BestAIC[3]
  
  data$Model4[data$MyID == i] <- names(BestAIC[4])
  data$AIC4[data$MyID == i] <- BestAIC[4]
}


#which model fits best overall?

CountModels <- lapply(data[, c("Model1", "Model2", "Model3")], table)

proportionFull <- length(which(data$Model1 == "Full"))/length(data$Model1)

proportionHigh <- length(which(data$Model1 == "High"))/length(data$Model1)

proportionLow <- length(which(data$Model1 == "Low"))/length(data$Model1)

proportionCubic <- length(which(data$Model1 == "Cubic"))/length(data$Model1)

# the cubic always fits the data better


# bestfit <- data.frame(proportionCubic, proportionFull, proportionHigh, proportionLow)
# names(bestfit) <- c("Cubic", "Full", "High Temperatures", "Low Temperatures")



