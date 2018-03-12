#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 03.2018
#Version: 0.0.1

#doesn't print warnings when workflow is ran on terminal
options(warn=-1)

# clear current workspace
rm(list=ls())


# load in ggplot2
require(ggplot2)

# read in data produced in TPCfitting.py
data <- read.csv("../Data/fittedData.csv", header = T)



#### graphs for intro/methods ####

sub <- subset(data, MyID == 110)

# cubic model equation B = B0 + B1T + B2T^2 + B3T^3
# B0 <- sub$cubicB0
# B1 <- sub$cubicB1
# B2 <- sub$cubicB2
# B3 <- sub$cubicB3
  
graph <- ggplot(sub, aes(x=ConTempKelvin, y=OriginalTraitValue)) + geom_point() + 
  geom_smooth(data = sub, aes(x=ConTempKelvin, y = OriginalTraitValue), se = F) +
  # stat_function(fun = function(ConTempKelvin) B0 + B1*ConTempKelvin + B2*ConTempKelvin^2 + B3*ConTempKelvin^3) +
  geom_segment(aes(x = 299.6, y = 15, xend = 299.6, yend = 0), linetype = 3, colour = "red") +
  geom_segment(aes(x = 280, y = 15.35, xend = 326.7, yend = 15.35), linetype = 3, colour = "red") +
  geom_segment(aes(x = 326.7, y = 0, xend = 326.7, yend = 15), linetype = 3, colour = "red") +
  geom_segment(aes(x = 280, y = 30.7, xend = 312.5, yend = 30.7), linetype = 3, colour = "red") +
  geom_segment(aes(x = 280, y = 4.8, xend = 283.15, yend = 4.8), linetype = 3, colour = "red") +
  geom_segment(aes(x = 283.15, y = 0, xend = 283.15, yend = 4.8), linetype = 3, colour = "red") +
  xlim(280, 330) +
  annotate("text", x= 298, y = 0, parse = TRUE, label = as.character(expression(T[l]))) +
  annotate("text", x= 325, y = 0, parse = TRUE, label = as.character(expression(T[h]))) +
  annotate("text", x= 283, y = 0, parse = TRUE, label = as.character(expression(T[ref]))) +
  annotate("text", x= 280, y = 2, parse = TRUE, label = as.character(expression(B[0]))) +
  annotate("text", x= 280, y = 17.5, parse = TRUE, label = as.character(expression(frac(B[max], 2)))) +
  annotate("text", x= 280, y = 32, parse = TRUE, label = as.character(expression(B[max])))


graph <- graph + ggtitle("Thermal Performance Curve") +
  xlab("Temperature (K)") +
  ylab("Trait Value")



pdf("../Results/TPCcurve.pdf")
graph
invisible(dev.off())


k <- 8.6173303e-05
sub$logTraits <- log(sub$OriginalTraitValue)
sub$oneOverKT <- 1/(sub$ConTemp*k)

logGraph <- ggplot(sub, aes(x=oneOverKT, y = logTraits)) + geom_point() +
  geom_smooth(se=F, method = "loess", span=0.4) +
  geom_segment(aes(x = 525, y = 2, xend = 310, yend = 3.6), colour = "red", size = 0.7) +
  geom_segment(aes(x = 195, y = 2.5, xend = 265, yend = 3.6), colour = "red", size = 0.7) +
  geom_segment(aes(x = 625, y = 1.82, xend = 1150, yend = 1.39), colour = "red", size = 0.7) +
  xlim(150, 1200) +
  ggtitle("Logged Thermal Performance Curve") +
  ylab("Logged Trait Value") +
  xlab(expression(frac(1, kT)))


logGraph <- logGraph + annotate("text", x= 420, y = 3, label = "E", colour = "red") +
  annotate("text", x= 200, y = 3, parse = TRUE, label = as.character(expression(E[h])), colour = "red") +
  annotate("text", x= 850, y = 1.75, parse = TRUE, label = as.character(expression(E[l])), colour = "red")
  

pdf("../Results/logTPCcurve.pdf")
logGraph
invisible(dev.off())






#### graphs for results #### 

sub <- subset(data, MyID == 1819)

temperatures <- sub$ConTempKelvin
kT <- sub$ConTempKelvin*k
sub$one.kT <- 1/kT


k <- 8.6173303e-05


#### for full schoolfield ####

B0 <- sub$B0FullMod
E <- sub$EFullMod
El <- sub$ElFullMod
Eh <- sub$EhFullMod
Tl <- sub$TlFullMod
Th <- sub$ThFullMod


sub$full <- log(B0) - ( (E/k) * ((1/temperatures) - (1/283.15)) ) - log( 1 + exp( (El/k) * ( (1/Tl) - (1/temperatures) ) ) + exp( (Eh / k) * ( (1/Th) - (1/temperatures) ) ) )



schoolGraphs <- ggplot(sub, aes(x=one.kT, y = log(sub$OriginalTraitValue))) + 
  geom_point() +
  geom_smooth(data = sub, aes(x=one.kT, y = full), colour = "green")



#### for high schoolfield ####

B0 <- sub$B0outHighMod
E <- sub$EOutHighMod
Eh <- sub$EhOutHighMod
Th <- sub$ThOutHighMod

sub$high <- log(B0) - ( (E/k) * ((1/temperatures) - (1/283.15)) ) - log( 1 + exp( (Eh / k) * ( (1/Th) - (1/temperatures) ) ) )


schoolGraphs <- schoolGraphs + geom_smooth(data = sub, aes(x=one.kT, y = high), colour = "red")


#### for low schoolfield ####

B0 <- sub$B0outLowMod
E <- sub$EOutLowMod
El <- sub$ElOutLowMod
Tl <- sub$TlOutLowMod

sub$low <- log(B0) - ( (E/k) * ((1/temperatures) - (1/283.15)) ) - log( 1 + exp( (El / k) * ( (1/Tl) - (1/temperatures) ) ) )

schoolGraphs <- schoolGraphs + geom_smooth(data = sub, aes(x=one.kT, y = low), colour = "blue") 

schoolGraphs <- schoolGraphs + ggtitle("Logged Thermal Performance Curve") +
  ylab("Logged Trait Value") +
  xlab(expression(frac(1, kT)))

#save graph
pdf("../Results/schoolfieldGraphs.pdf")
schoolGraphs
invisible(dev.off())




#### cubic model ####

sub$cubic <- sub$cubicB0 + sub$cubicB1 *temperatures + sub$cubicB2 * (temperatures^2) + sub$cubicB3 * (temperatures ^ 3)    

cubicGraphs <- ggplot(sub, aes(x=temperatures, y = sub$OriginalTraitValue)) + 
  geom_point() +
  geom_smooth(data = sub, aes(x=temperatures, y = cubic), se = F)


cubicGraphs <- cubicGraphs + ggtitle("Thermal Performance Curve") +
  xlab("Temperature (K)") +
  ylab("Trait Value")


pdf("../Results/cubicGraphs.pdf")
cubicGraphs
invisible(dev.off())
