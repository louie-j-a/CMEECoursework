#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 10.2017
#Version: 0.0.1 

#This function calculates heights of trees from the angle of
#elevation and the distance from the base using the trigonometric
#formula height = distance * tan(radians)
#
#ARGUMENTS:
#degrees	The angle of elevation
#distance	The distance from base
#
#OUTPUT:
#The height of the tree, same units as "distance"

MyTreeData <- read.csv("../Data/trees.csv", header = TRUE)

# uses degrees and distance values from trees.csv to calculate height of tree
TreeHeight <- function(degrees=MyTreeData$Angle.degrees, distance=MyTreeData$Distance.m){
  radians <- MyTreeData$Angle.degrees * pi/180 # converts angles in degrees to radians
  height <- MyTreeData$Distance.m * tan(radians) # calculates height from degrees in radians and distance in m
	#print(paste("Tree height is:", height)) 

	return (height)
}

MyTreeData$Tree.Height.m <- TreeHeight() # adds new column called Tree.Height.m to MyTreeData, contains the heights calculated using TreeHeight()

write.csv(MyTreeData, "../Results/TreeHts.csv", row.names = FALSE) #write MyTreeData out as a new file
