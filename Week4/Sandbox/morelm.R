rm(list = ls())
setwd("~/CMEECourseWork/Week4/Code")

d <- read.table("../Data/SparrowSize.txt", header = T)

plot(d$Mass~d$Tarsus, ylab = "Mass (g)", xlab = "Tarsus (mm)", pch=19, cex=0.4)

d$Mass[1]
length(d$Mass)
d$Mass[1770]

plot(d$Mass~d$Tarsus, ylab = "Mass (g)", xlab = "Tarsus (mm)", pch=19, cex=0.4, 
     ylim = c(-5, 38), xlim = c(0, 22))

d1 <- subset(d, d$Mass != "NA")
d2 <- subset(d1, d$Tarsus != "NA")
length(d2$Tarsus)

model1 <- lm(Mass~Tarsus, data = d2)
summary(model1)

hist(model1$residuals)
