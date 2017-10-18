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

TreeHeight <- function(degrees=MyTreeData$Angle.degrees, distance=MyTreeData$Distance.m){
	radians <- MyTreeData$Angle.degrees * pi/180
	height <- MyTreeData$Distance.m * tan(radians)
	#print(paste("Tree height is:", height))

	return (height)
}

MyTreeData$Height.m <- TreeHeight(MyTreeData$Angle.degrees, MyTreeData$Distance.m)

write.csv(MyTreeData, "../Results/TreeHts.csv", row.names = FALSE) #write it out as a new file
