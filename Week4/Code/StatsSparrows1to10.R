#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 10.2017
#Version: 0.0.1


################################
## StatswithSparrows1 
################################

getwd()
rm(list=ls()) # clear workspace before each session

# basic calc functions:
2*2+1
2*(2+1)
12/2^3
(12/2)^3

# assigning variables:
x <- 5
x2 <- x^2
a <- x2 + x
z <- sqrt((x * x2)/1.24)

# logical tests:
3 > 2
3 >= 3
4 < 2

#creating vectors of different formats:
myNumericVector <- c(1.3,2.5,1.9,3.4,5.6,1.4,3.1,2.9)    
myCharacterVector <- c("low","low","low","low","high","high","high","high")  
myLogicalVector <- c(TRUE,TRUE,FALSE,FALSE,TRUE,TRUE,FALSE,FALSE) 
myMixedVector <- c(1, TRUE, FALSE, 3, "help", 1.2, TRUE, "notwhatIplanned")  

str(myNumericVector) # check see structure of any variable use str()
str(myCharacterVector)
str(myLogicalVector)
str(myMixedVector)

#Installing and loading packages:
#install.packages("lme4")
library(lme4) #Loads package with warning.
require(lme4) #Loads package without warning.

# help() function:
help(getwd)
help(log)

# input external data:
d <- read.table("../Data/SparrowSize.txt", header=TRUE) #Load a data frame.
str(d) #Look at structure of dataframe.


############################
## StatswithSparrows2
###########################


rm(list=ls())

d <- read.table("../Data/SparrowSize.txt", header=TRUE)
str(d)
names(d)
head(d) 
length(d$Tarsus)
hist(d$Tarsus) 

# What is a Normal Distribution?
# What is centrality?
mean(d$Tarsus, na.rm = TRUE) # removes NAs
median(d$Tarsus, na.rm = TRUE)
mode(d$Tarsus) #this just returns "numeric", see below;


par(mfrow = c(2,2))
hist(d$Tarsus, breaks = 3, col = "grey")
hist(d$Tarsus, breaks = 10, col = "grey")
hist(d$Tarsus, breaks = 30, col = "grey")
hist(d$Tarsus, breaks = 100, col = "grey")

require('modeest')
d2 <- subset(d, d$Tarsus!="NA")
mlv(d2$Tarsus) # to work out mode of continuous data

# spread of data
range(d2$Tarsus, na.rm = TRUE)
var(d2$Tarsus, na.rm = TRUE)
sum((d2$Tarsus - mean(d2$Tarsus))^2)/(length(d2$Tarsus) - 1) # find variance without using var
sqrt(var(d2$Tarsus)) # find standard deviation without using sd
sd(d2$Tarsus)

mean(d$Tarsus, na.rm = TRUE)
mean(d$Mass, na.rm = TRUE)
mean(d$Bill, na.rm = TRUE)
var(d$Tarsus, na.rm = TRUE)
var(d$Mass, na.rm = TRUE)
var(d$Bill, na.rm = TRUE)
sd(d$Tarsus, na.rm = TRUE)
sd(d$Mass, na.rm = TRUE)
sd(d$Bill, na.rm = TRUE)

#Calculating Z scores
zTarsus <- (d2$Tarsus - mean(d2$Tarsus))/sd(d2$Tarsus)
var(zTarsus)
sd(zTarsus)
hist(zTarsus)

#install.packages("mosaic")
require(moasaic) # package calculates Z-scores
set.seed(123) # set seed to get same random numbers
znormal <- rnorm(1e+06) # random generation of normal distribution
hist(znormal, breaks = 100)
summary(znormal)

#Generating graphs displaying last quantiles:

par(mfrow = c(1, 2))    
hist(znormal, breaks = 100)     
abline(v = qnorm(c(0.25, 0.5, 0.75)), lwd = 2)  
abline(v = qnorm(c(0.025, 0.975)), lwd = 2, lty = "dashed")   
plot(density(znormal))  
abline(v = qnorm(c(0.25, 0.5, 0.75)), col = "gray")   
abline(v = qnorm(c(0.025, 0.975)), lty = "dotted", col = "black")   
abline(h = 0, lwd = 3, col = "blue")  
text(2, 0.3, "1.96", col = "red", adj = 0)  
text(-2, 0.3, "-1.96", col = "red", adj = 1)
# 95% confidence interval v important
boxplot(d$Tarsus~d$Sex.1, col = c("red", "blue"), ylab="Tarsus length (mm)")


############################
## StatswithSparrows3
############################

#In this lesson we work out how to plot some common statistical ditributions, and look at the class types of the Tarsus data and how they are distributed#
#reading the data file
d<-read.table("../Data/SparrowSize.txt", header=TRUE)  
#plotting a histogram of the Year variable with suitable binwidth ; the data show an approimate normal distribution#
dev.off()
ggplot(data=d, aes(d$Year)) + 
  geom_histogram(col="red", fill="green", alpha=.2, binwidth=1)
#plotting a Gaussian distribution in ggplot2#
dev.off()
xvalues<-data.frame(x=c(-3,3))
plot<-ggplot(xvalues, aes(x=xvalues))
plot +stat_function(fun=dnorm) +xlim(c(-4,4))+
  annotate("text",x=2.4, y=0.3, size=7, fontface="bold",
           label="Gaussian\nDistribution")
#plotting a poisson distribution in ggplot2#
dev.off()
ggplot(data.frame(x=c(0:100)), aes(x))+
  geom_point(aes(y=dpois(x,5)), colour="red")+
  xlim(c(0,50))+
  annotate("text",x=40, y=0.1, size=7, fontface="bold",
           label="Poisson\nDistribution")
##plotting a binomial distribution in ggplot2#
dev.off()
x1  <- seq(3,17)
df <- data.frame(x = x1, y = dbinom(x1, 20, 0.5))
plot1 <- ggplot(df, aes(x = x, y = y)) + geom_point(stat = "identity", col = "red", fill = "pink") + 
  scale_y_continuous(expand = c(0.01, 0)) + xlab("x") + ylab("Density") + 
  labs(title = "dbinom(x, 20, 0.5)") + theme_bw(16, "serif") + 
  theme(plot.title = element_text(size = rel(1.2), vjust = 1.5))
print(plot1)


#########################
## StatswithSparrows4 
#########################


varTarsus <- var(d$Tarsus, na.rm = TRUE)
varBill <- var(d$Bill, na.rm = TRUE)
varWing <- var(d$Wing, na.rm = TRUE)
varMass <- var(d$Mass, na.rm = TRUE)
meanTarsus <- mean(d$Tarsus, na.rm = TRUE)
meanBill <- mean(d$Bill, na.rm = TRUE)
meanWing <- mean(d$Wing, na.rm = TRUE)
meanMass <- mean(d$Mass, na.rm = TRUE)
semTarsus <- sqrt(varTarsus/meanTarsus)
semBill <- sqrt(varBill/meanBill)
semWing <- sqrt(varWing/meanWing)
semMass <- sqrt(varMass/meanMass)
nTarsus <- length(d$Tarsus)
nBill <- length(d$Bill)
nWing <- length(d$Wing)
nMass <- length(d$Mass)

#2001 subset
d.ss <- subset(d, Year == 2001)
varTarsus.ss <- var(d.ss$Tarsus, na.rm = TRUE)
varBill.ss <- var(d.ss$Bill, na.rm = TRUE)
varWing.ss <- var(d.ss$Wing, na.rm = TRUE)
varMass.ss <- var(d.ss$Mass, na.rm = TRUE)
meanTarsus.ss <- mean(d$Tarsus.ss, na.rm = TRUE)
meanBill.ss <- mean(d$Bill.ss, na.rm = TRUE)
meanWing.ss <- mean(d$Wing.ss, na.rm = TRUE)
meanMass.ss <- mean(d$Mass.ss, na.rm = TRUE)
semTarsus.ss <- sqrt(varTarsus.ss/meanTarsus.ss)
semBill.ss <- sqrt(varBill.ss/meanBill.ss)
semWing.ss <- sqrt(varWing.ss/meanWing.ss)
semMass.ss <- sqrt(varMass.ss/meanMass.ss)
nTarsus.ss <- length(d.ss$Tarsus)
nBill.ss <- length(d.ss$Bill)
nWing.ss <- length(d.ss$Wing)
nMass.ss <- length(d.ss$Mass)


#########################
## StatswithSparrows5 
#########################

#hypothesis testing and t-tests

# boxplot to see how mass is distributed differently in males and females
boxplot(d$Mass~d$Sex.1,  col  =  c("red",  "blue"),  ylab="Body  mass  (g)")  

# t-test to compare means and variance of two datasets
t.test1 <- t.test(d$Mass~d$Sex.1)   
t.test1    # mean difference of ~0.5g, with a very low p-value. 95% CI tell us that 95% of time the difference between mass will fall between ~0.4 and ~0.8 (a small difference)
shortd <- as.data.frame(head(d,  50))  
t.test2 <- t.test(shortd$Mass~shortd$Sex)   
t.test2     
# with smaller sample size, effect no longer statistically significant. Large N required to show small effect sizes


#########################
## StatswithSparrows6
#########################


#install.packages("pwr")
library("pwr")
pwr.t.test(d=(0-5)/1-(0.8*0.05), power = 0.8, sig.level = 0.05, type = "two.sample", alternative = "two.sided")
# Sample 6 to reduce chance of Type II error (we got 2.1 -> round it up --> multiply by two as we are sampling males and females (two different groups/categories)). The effect size (d) is 5.04 - i.e. the difference between two means.


#########################
## StatswithSparrows7
#########################

#How do df's affect Student's t? As df increase, the t-distribution approachs normality - the center increases, while the area near the tail decreases. The more df, the larger the sample esize and the t-distribution is more peaked (less spread out), so a smaller difference between means and mean (or criterion value) is required for us to say that there is actually a difference.
#Why are the df's in a dataset of 100 birds on a 2-sample t-test 98? In a two sample t-test with 100 samples, we can deduce each of the two samples with n-1 (we can work out the last one via subtraction when we know n-1 pbservations lus the total number of observations) - because there are 2 samples we have to subtract 2, 1 for each sample.


#########################
## StatswithSparrows8
#########################

#In this lecture we discuss the degrees of freedom of a line.


#########################
## StatswithSparrows9
#########################
# Fitting models to data
# Linear models
# No handout for lecture.
x <- c(1,2,3,4,8)
y <- c(4,3,5,7,9)
model1 <- (lm(y~x)) #generating a linear model.
model1
summary(model1)
anova(model1)
resid(model1)
cov(x,y)
var(x)
plot(y~x)


#########################
## StatswithSparrows10 
#########################


rm(list=ls())
d<-read.table("../Data/SparrowSize.txt", header=T)
plot(d$Mass~d$Tarsus, ylab="Mass (g)", xlab="Tarsus (mm)", pch=19, cex=0.4)
#Making a line using the formular y = mx + b
x<-c(1:100)
b<-0.5
m<-1.5
y<- m*x + b
plot(x,y, xlim=c(0,100), ylim=c(0,100), pch=19, cex=0.5)
#Exploring the indices of our data.
d$Mass[1]
length(d$Mass)
d$Mass[1770]
plot(d$Mass~d$Tarsus, ylab="Mass (g)", xlab="Tarsus (mm)", pch=19, cex=0.4, ylim=c(-5,38), xlim=c(0,22))
plot(d$Mass~d$Tarsus, ylab="Mass (g)", xlab="Tarsus (mm)", pch=19, cex=0.4) #Using original plot rather than one where we define limits, where it is harder to see the data.
#Creating a subset of the data to strip missing values.
d1 <- subset(d, d$Mass!="NA")
d2 <- subset(d1, d1$Tarsus!="NA")
length(d2$Tarsus)
model1 <- lm(Mass~Tarsus, data=d2) #Creating linear model.
summary(model1)
hist(model1$residuals) #Looking at distributio of residuals.
head(model1$residuals)
model2 <- lm(y~x) #Using x and y we generated before.
summary(model2)
d2$z.Tarsus <- scale(d2$Tarsus) #Adding a new column to d2.
model3 <- lm(Mass~z.Tarsus, data=d2) #Making a new linear model. Running it with z scores.
plot(d2$Mass~d2$z.Tarsus, pch=19, cex=0.4)
abline(v = 0, lty = "dotted")
#Plotting graphs
d$Sex <- as.numeric(d$Sex)
par(mfrow = c(1, 2))
plot(d$Wing ~ d$Sex.1, ylab="Wing (mm)")
plot(d$Wing ~ d$Sex, xlab="Sex",xlim=c(-0.1,1.1), ylab="")
abline(lm(d$Wing ~ d$Sex, lwd=2))
text(0.15, 76, "intercept")
text(0.9, 77.5, "slope", col = "red")
d4 <- subset(d, d$Wing!="NA")
m4 <- lm(Wing~Sex, data=d4)
t4 <- t.test(d4$Wing~d4$Sex, var.equal=TRUE) #Carrying out a t-test.
summary(m4) #Looking at results of t-test.
par(mfrow=c(2,2))
plot(model3)