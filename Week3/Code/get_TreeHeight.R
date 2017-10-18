
GTreeHeight <- function(file= *.csv, degrees=MyTreeData$Angle.degrees, distance=MyTreeData$Distance.m){
  args <- commandArgs()
  GMyTreeData <- read.csv("args[1,]") # is , header = TRUE needed here? depends on the layout of the input file?
  