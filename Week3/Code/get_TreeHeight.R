#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 10.2017
#Version: 0.0.1 

args <- commandArgs(trailingOnly = T) # sets argument given in command line as variable "args"

#formula to calculate tree height from angles in degrees and distance in m
TreeHeight <- function(angle, distance){
  radians <- angle * pi/180
  height <- distance * tan(radians)
  #print(paste("Tree height is:", height)) 
  
  return (height)
}

MyTreeData <- read.csv(args, header = TRUE) # reads in file from argument given in commandline


MyTreeData$Tree.Height.m <- TreeHeight(MyTreeData[,2], MyTreeData[,3]) # adds new column containing tree heights to MyTreeData

title <- gsub("/|../Data/|.csv","",args) #removes relative path and .csv from name of argument
write.csv(MyTreeData, paste0("../Results/",title,"_treeheights.csv"), row.names = FALSE) #write it out as a new file, paste0 needed to concatenate strings to form a file name
