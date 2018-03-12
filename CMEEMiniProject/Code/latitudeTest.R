#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 02.2018
#Version: 0.0.1

#doesn't print warnings when workflow is ran on terminal
options(warn=-1)

# clear current workspace
rm(list=ls())

# load package ggplot2
suppressMessages(require(ggplot2))

# read in data produced in TPCfitting.py
data <- read.csv("../Data/fittedData.csv", header = T)
# str(data)


# remove column of row numbers added in python
data <- subset(data, select=-c(X))



# extract data sets where location tells you where the study organism was collected/cultured from 
levels(data$LocationType)

data <- subset(data, LocationType == "Organism" | LocationType == "organism")


# remove NAs from latitude
data <- subset(data, Latitude != "NA")


# compare AIC scores for 4 models for each id
# model is better if its AIC is lower by 2, or if it has fewer parameters

for (i in unique(data$MyID)){
  sub = subset(data, MyID == i)
  
  AICs <- c(sub$AICFullMod[1], sub$AIChighMod[1], sub$AIClowMod[1]) # , sub$AICcubicMod[1])
  # to deal with NA's in data, replace any NA's with higher AICs than max(AICs)
  AICs[which(is.na(AICs))] <- max(AICs[which(AICs != "NA")]) + 10
  names(AICs) <- c("Full", "High", "Low") # , "Cubic")
  AICs <- sort(AICs)
  
  # extract lowest AIC scores
  if (AICs[2] - AICs[1] >= 2){
    BestAIC <- AICs[1]
  } else if (AICs[3] - AICs[1] >= 2){
    BestAIC <- AICs[1:2]
  } else {
    BestAIC <- AICs[1:3]
  } 
  # else {
    # BestAIC <- AICs[1:4]
  # }
  
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
  
  # data$Model4[data$MyID == i] <- names(BestAIC[4])
  # data$AIC4[data$MyID == i] <- BestAIC[4]
  
  # add the r squared value associated with the model to a new column
  if (names(AICs[1]) == "Full"){
    data$RsquaredBestModel[data$MyID == i] <- data$RsquaredFullMod[data$MyID == i]
  } else if (names(AICs[1]) == "High"){
    data$RsquaredBestModel[data$MyID == i] <- data$RsquaredHighMod[data$MyID == i]
  } else {
    data$RsquaredBestModel[data$MyID == i] <- data$RsquaredLowMod[data$MyID == i]
  }
}


 

#which model fits best overall?

CountModels <- lapply(data[, c("Model1", "Model2", "Model3")], table)

proportionFull <- length(which(data$Model1 == "Full"))/length(data$Model1)

proportionHigh <- length(which(data$Model1 == "High"))/length(data$Model1)

proportionLow <- length(which(data$Model1 == "Low"))/length(data$Model1)



# need to test latitude vs best model;

# summary(data$Latitude)

data$absoluteLatitude <- abs(data$Latitude)

# remove any data points with Rsquared <0.5
# data <- subset(data, RsquaredBestModel>=0.5)
# could't do this as only full schoolfield models had an r squared of over 0.5 so no stat could be conducted if this was to be done


# extract single data values (rather than duplicated ones in data frame)

absLat <- rep(NA, length(unique(data$MyID)))
j <- 1
for (i in unique(data$MyID)){
  absLat[j] <- data$absoluteLatitude[data$MyID==i][1]
  j <- j + 1
}

BestMod <- rep(NA, length(unique(data$MyID)))
j <- 1
for (i in unique(data$MyID)){
  BestMod[j] <- data$Model1[data$MyID==i][1]
  j <- j + 1
}

testData <- data.frame(absLat, BestMod)
names(testData) <- c("latitude", "model")


# plot latitude vs best model

xlabel <- expression("Absolute Latitude ("*~degree*")")

bxplt <- ggplot(testData, aes(x = model, y = latitude)) +
  geom_boxplot(fill = c("#66FF00", "#FF0033", "#33CCCC"), alpha = 0.7) +
  scale_x_discrete(name = "Schoolfield Model") +
  scale_y_continuous(name = xlabel,
                     breaks = seq(0, 80, 10)) +
  ggtitle("Absolute Latitude vs. Best Fitting Schoolfield Model")

pdf("../Results/latitudeBxPlt.pdf")
bxplt
invisible(dev.off())



# ANOVA
anova <- aov(testData$latitude~testData$model)
# summary(anova)
# plot(anova)

# subsetting data to see if seasonality affects model fit, low latitudes only
testSubset <- subset(testData, latitude <= 23.5)



#plot data

xlabel <- expression("Absolute Latitude ("*~degree*")")

bxplt2 <- ggplot(testSubset, aes(x = model, y = latitude)) +
  geom_boxplot(fill = c("#66FF00", "#FF0033", "#33CCCC"), alpha = 0.7) +
  scale_x_discrete(name = "Schoolfield Model") +
  scale_y_continuous(name = xlabel,
                     breaks = seq(0, 80, 10)) +
  ggtitle("Absolute Latitude vs. Best Fitting Schoolfield Model")


pdf("../Results/latitudeBxPlt2.pdf")
bxplt2
invisible(dev.off())



# ANOVA
anova2 <- aov(testSubset$latitude~testSubset$model)
# summary(anova2)
# plot(anova2)

Tukey <-  TukeyHSD(anova2)
# plot(Tukey)





# 
# # subsetting data to see if seasonality affects model fit, high latitudes only
# testSubset <- subset(testData, latitude >= 66.5)
# 
# 
# 
# #plot data
# 
# xlabel <- expression("Absolute Latitude ("*~degree*")")
# 
# bxplt3 <- ggplot(testSubset, aes(x = model, y = latitude)) +
#   geom_boxplot(fill = c("#66FF00", "#FF0033"), alpha = 0.7) +
#   scale_x_discrete(name = "Schoolfield Model") +
#   scale_y_continuous(name = xlabel,
#                      breaks = seq(0, 80, 10)) +
#   ggtitle("Absolute Latitude vs. Best Fitting Schoolfield Model")
# 
# 
# pdf("../Results/latitudeBxPlt3.pdf")
# bxplt3
# invisible(dev.off())
# 
# 
# 
# # ANOVA
# anova3 <- aov(testSubset$latitude~testSubset$model)
# # summary(anova2)
# # plot(anova2)
# 
# Tukey2 <-  TukeyHSD(anova3)
# # plot(Tukey)
# 
