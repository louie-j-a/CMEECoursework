#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 02.2018
#Version: 0.0.1

#doesn't print warnings when workflow is ran on terminal
options(warn=-1)

#clear current workspace
rm(list=ls())


#read in data
data <- read.csv("../Data/GrowthRespPhotoData_new.csv", header = T)
# head(data)
# str(data)


#################################
#### Cleaning/preparing data ####
#################################


# remove NA's from variables that will be used 

# which(is.na(data$ConTemp))
data <- subset(data, ConTemp != "NA")

# which(is.na(data$OriginalTraitValue))
# no Nas here

#remove negative and 0 OriginalTraitValue data points
data <- subset(data, OriginalTraitValue > 0)


# remove data sets if fewer than 5 data points
data <- subset(data,FinalID %in% names(which(table(data$FinalID)>=5)))


#create new column in data called MyID, goes from 1 to length(unique(data$FinalID))
data$MyID <- match(data$FinalID, unique(data$FinalID))




################################################
#### parameter estimates for use with LMfit ####
################################################


# Tref (closest temperature to 10C)
# B0 is corresponding trait value

# loop through all unique id's
for (i in unique(data$MyID)){
  
  # store temperatures for id == i
  temperatures <- data$ConTemp[data$MyID==i]
  
  # find the temperature closest to 10 degrees and stores in new column Tref
  data$Tref[data$MyID == i] <- temperatures[which(abs(data$ConTemp[data$MyID==i]-10)==min(abs(data$ConTemp[data$MyID==i]-10)))[1]]
  
  # store trait values for id == i 
  trait.values <- data$OriginalTraitValue[data$MyID == i]
  
  # find trait value corresponding to Tref and store in B0
  data$B0[data$MyID==i] <- trait.values[which(abs(data$ConTemp[data$MyID==i]-10)==min(abs(data$ConTemp[data$MyID==i]-10)))[1]]

}




# Bmax, max trait value
# Tl is temp at which B is half of Bmax on lower half of data
# Th is temp at which B is half of Bmax on upper half of data

# loop through id's
for (i in unique(data$MyID)){
  
  # store trait values for MyID == i
  trait.values <- data$OriginalTraitValue[data$MyID==i]
  # find Bmax
  Bmax <- max(trait.values)
  # store temperatures for MyID == i
  temperatures <- data$ConTemp[data$MyID == i] + 273.15
  
  # for groups where Bmax occurs at the highest temperature we won't want to split the data to find Th, just set Th to be the last value in the temperatures 
  if (temperatures[which(trait.values==Bmax)] == temperatures[length(temperatures)]){
    
    # create new column for Th
    data$Th[data$MyID == i] <- temperatures[length(temperatures)]
  } else{
    # if Bmax doesn't occur at the last temperature, split temperatures and trait values in to two groups, corresponding to those data points above Bmax and below Bmax 
    higher.trait.values <- trait.values[which(trait.values==Bmax):length(trait.values)]
    higher.temperatures <- temperatures[which(trait.values==Bmax):length(temperatures)]
    # which(abs(higher.trait.values-Bmax/2)==min(abs(higher.trait.values-Bmax/2))) finds the index of the value closest to half of Bmax
    data$Th[data$MyID == i] <- higher.temperatures[which(abs(higher.trait.values-Bmax/2)==min(abs(higher.trait.values-Bmax/2)))]
  }
  # find and store Tl
  lower.trait.values <- trait.values[1:which(trait.values==Bmax)]
  lower.temperatures <- temperatures[1:which(trait.values==Bmax)]
  data$Tl[data$MyID == i] <- lower.temperatures[which(abs(lower.trait.values-Bmax/2)==min(abs(lower.trait.values-Bmax/2)))] 
  
  # store Tpeak (temperature at which Bmax occurs)
  data$Tpeak[data$MyID == i] <- temperatures[which(trait.values==Bmax)]
}




# to estimate activation energy run lm on logged trait values vs 1/k*temperatures(in kelvins)
# run lm on datapoints covering lower temperature ranges for each group, as this will give slope for E  
# Then can use 2xE and E/2 for Eh and El parameter estimates respectively


# Set Boltzmann constant, k
# careful units of K are ok, I used eV.K^-1 here
K <- 8.6173303e-5

# add temperature in kelvins column
data$ConTempKelvin <- data$ConTemp + 273.15

for (i in unique(data$MyID)){
  trait.values <- data$OriginalTraitValue[data$MyID==i]
  temperatures <- data$ConTempKelvin[data$MyID==i]
  
  # temperatures need to be sorted into ascending order
  orderedT <- sort(temperatures, decreasing = F)
  # trait values have to be ordered according to the way temepratures have been sorted
  ordered.traits <- trait.values[order(temperatures, decreasing = F)]
  
  # calculate 1/kt
  one.over.kt <- 1/(K*orderedT)
  iBmax <- which(ordered.traits == max(ordered.traits))
  iBmin <- which(ordered.traits == min(ordered.traits))
  
  # run lm on lower half of logged data
  # warnings occur here were there are two maximum values, the first maximum value is taken as Bmax
  logmod <- lm(log(ordered.traits[iBmin:iBmax])~one.over.kt[iBmin:iBmax])
  
  # activation energy is equal to absolute value of gradient of the line
  E <- abs(logmod$coefficients[2])
  data$E[data$MyID == i]  <- E
}



# some groups give NAs for data$E
# > unique(data$MyID[which(is.na(data$E))])
# [1]  904  905  906  907 1414 1433 1435 1436 1437 1443 1508 1557
# remove these data sets as too few temperatures for lm


# removes the data sets giving NAs in data$E
for (i in unique(data$MyID[which(is.na(data$E))])){
  data <- subset(data, MyID != i)
}



# # build 1.kT column, probably useless, remove at end
# K <- 8.6173303e-5
# one.over.kt <- rep(NA, length(data$MyID))
# for (i in 1:length(data$MyID)){
#   one.over.kt[i] <- 1/(K*data$ConTemp[i])
# } 
# 
# data$oneOverKt <- one.over.kt




# add all useful columns to a new data frame for use in lmfit in python
# the reason a new data frame was created rather than using the original data frame was that I was having difficulty in reading in the full data frame in python 
data <- cbind.data.frame(data$MyID, data$ConTemp, data$ConTempKelvin ,data$OriginalTraitValue, data$B0, data$Tref, data$Th, data$Tl, data$E, data$Consumer, data$Tpeak, data$Location, data$LocationType, data$Latitude, data$Longitude)

# give all columns with 'nicer' names
colnames(data) <- c("MyID", "ConTemp", "ConTempKelvin", "OriginalTraitValue", "B0", "Tref", "Th", "Tl", "E", "Consumer", "Tpeak", "Location", "LocationType", "Latitude", "Longitude")



####write to csv####
write.table(data, file="../Data/TPCdata.csv", sep = ",", col.names = TRUE, row.names = FALSE)

