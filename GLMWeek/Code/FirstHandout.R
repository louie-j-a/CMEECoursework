rm(list = ls())
setwd("~/CMEECourseWork/GLMWeek/Code/")

d <- read.table("../Data/SparrowSize.txt", header = T)
str(d)

names(d)

head(d)

hist(d$Tarsus, main = "", xlab = "Sparrow tarsus length (mm)", col = "grey")

mean(d$Tarsus, na.rm = T)
var(d$Tarsus, na.rm = T)
sd(d$Tarsus, na.rm = T)

#plotting density with mean +/- 1SD lines

hist(d$Tarsus, main = "", xlab = "Sparrow tarsus length (mm)", col = "grey", prob = T) # tells r to plot density instead of frequency

lines(density(d$Tarsus, na.rm = T), #density plot
      lwd = 2)

abline(v = mean(d$Tarsus, na.rm = T), col = "red", lwd = 2)

abline(v = mean(d$Tarsus, na.rm = T)-sd(d$Tarsus, na.rm = T), col = "blue", lwd = 2, lty = 5)

abline(v = mean(d$Tarsus, na.rm = T)+sd(d$Tarsus, na.rm = T), col = "blue", lwd = 2, lty = 5)


#testing for sex difference in tarsus length
t.test(d$Tarsus~d$Sex)

#plotting by sex
par(mfrow=c(2,1))
hist(d$Tarsus[d$Sex==1], main = "", xlab = "Male sparrow tarsus length (mm)", col="grey", prob = T)

lines(density(d$Tarsus[d$Sex==1], na.rm = T), lwd = 2)

abline(v = mean(d$Tarsus[d$Sex==1], na.rm = T), col="red", lwd = 2)

abline(v = mean(d$Tarsus[d$Sex==1], na.rm = TRUE)-sd(d$Tarsus[d$Sex==1], na.rm = TRUE), col = "blue",lwd = 2, lty=5)

abline(v = mean(d$Tarsus[d$Sex==1], na.rm = TRUE)+sd(d$Tarsus[d$Sex==1], na.rm = TRUE), col = "blue",lwd = 2, lty=5)

hist(d$Tarsus[d$Sex==0], main="", xlab="Female sparrow tarsus length (mm)", col="grey", prob=T)

lines(density(d$Tarsus[d$Sex==0],na.rm=TRUE), lwd = 2) 	

abline(v = mean(d$Tarsus[d$Sex==0], na.rm = TRUE), col = "red",lwd = 2) 	

abline(v = mean(d$Tarsus[d$Sex==0], na.rm = TRUE)-sd(d$Tarsus[d$Sex==0], na.rm = TRUE), col = "blue",lwd = 2, lty=5) 	

abline(v = mean(d$Tarsus[d$Sex==0], na.rm = TRUE)+sd(d$Tarsus[d$Sex==0], na.rm = TRUE), col = "blue",lwd = 2, lty=5) 	

dev.off() 

#summing variances

d1 <- subset(d, d$Tarsus != "NA")
d1 <- subset(d1, d1$Wing!= "NA")
sums <- var(d1$Tarsus) + var(d1$Wing)
test <- var(d1$Tarsus+d1$Wing)

sums
test
#shows that the two variables are not independent since sums != test

plot(jitter(d1$Wing), d1$Tarsus, pch = 19, cex = 0.4)


cov(d1$Tarsus, d1$Wing)

sums <- var(d1$Tarsus) + var(d1$Wing) + 2*cov(d1$Tarsus,d1$Wing)
test <- var(d1$Tarsus+d1$Wing)

sums
test

#multiplying variance of variable with constant

var(d1$Tarsus*10)
var(d1$Tarsus)*10^2 	


############### LINEAR MODELS ####################

uni<-read.table("../Data/RUnicorns.txt", header=T)
str(uni) 	
head(uni)
mean(uni$Bodymass)
sd(uni$Bodymass)
var(uni$Bodymass)
hist(uni$Bodymass)
mean(uni$Hornlength) 	
sd(uni$Hornlength) 	
var(uni$Hornlength)
hist(uni$Hornlength) 	

plot(uni$Bodymass~uni$Hornlength, pch=19, xlab="Unicorn horn length", ylab="Unicorn body mass", col="blue")

mod<-lm(uni$Bodymass~uni$Hornlength) 	

abline(mod, col="red") 	

res <- signif(residuals(mod), 5) 	
pre <- predict(mod) 	

segments(uni$Hornlength, uni$Bodymass, uni$Hornlength, pre, col="black") 	


#investigating the linear model for unicorn body mass ~ horn length
hist(uni$Bodymass) 	
hist(uni$Hornlength) 	
hist(uni$Height)

#check for colinearity
cor.test(uni$Hornlength,uni$Height) 	
#not much correlation so good to continue

boxplot(uni$Bodymass~uni$Gender) 	

par(mfrow=c(2,1)) 	
boxplot(uni$Bodymass~uni$Pregnant) 	

plot(uni$Hornlength[uni$Pregnant==0],uni$Bodymass[uni$Pregnant==0], pch=19, xlab="Horn length", ylab="Body mass", xlim=c(2,10), ylim=c(6,19))
points(uni$Hornlength[uni$Pregnant==1],uni$Bodymass[uni$Pregnant==1], pch=19,col="red") 	
#shows that pregnancy is affecting outcome of model

dev.off()

