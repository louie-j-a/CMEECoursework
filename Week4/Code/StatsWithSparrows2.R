rm(list=ls())

d <- read.table("../Data/SparrowSize.txt", header = T)
str(d)
names(d)
head(d)
length(d$Tarsus)

hist(d$Tarsus)

mean(d$Tarsus)
help(mean)

mean(d$Tarsus, na.rm = T)
median(d$Tarsus, na.rm = T)
mode(d$Tarsus, na.rm = T)


## checking where mode is graphically
par(mfrow = c(2,2)) # prints 4 graphs in one image, 2 columns, 2 rows
hist(d$Tarsus, breaks = 3, col="grey")
hist(d$Tarsus, breaks = 10, col="grey")
hist(d$Tarsus, breaks = 30, col="grey")
hist(d$Tarsus, breaks = 100, col="grey")


install.packages("modeest")

require(modeest)
library(help = "modeest")

mlv(d$Tarsus) # estimates mode

#mlv() found NAs so we are going to check how many NAs we have
d2 <- subset(d, d$Tarsus != "NA")
length(d$Tarsus)
length(d2$Tarsus)

# d2 doesnt have any NAs in it so we will use that
mlv(d2$Tarsus)


mean(d$Tarsus, na.rm = T)
median(d$Tarsus, na.rm = T)
mlv(d2$Tarsus)
### The mean, median and mode are all fairly similar, a good indication of normally distributed data.
### in prefectly normal data, the three are the same, as the skew increases, so does the difference between them.

range(d$Tarsus, na.rm = T)
range(d2$Tarsus, na.rm = T)

range(d$Tarsus, na.rm = T)
range(d2$Tarsus, na.rm = T)


## Calculate variance
sum((d2$Tarsus - mean(d2$Tarsus))^2)/(length(d2$Tarsus) - 1)

## calc sd
sqrt(var(d2$Tarsus))
sqrt(0.74)
sd(d2$Tarsus)


##### Z-scores  ##### scale(x) will convert vector x into vector of standardised values

zTarsus <- (d2$Tarsus - mean(d2$Tarsus))/sd(d2$Tarsus) # z scores found by dividing the sum of the differences from the mean, divided by sd
var(zTarsus)
sd(zTarsus) ## both equal 1
par(mfrow = c(1,1))
hist(zTarsus)


set.seed(123)
znormal <- rnorm(1e+06)
hist(znormal, breaks = 100)

summary(znormal)

qnorm(c(0.025, 0.975))
pnorm(.Last.value) ##### important in hypoth testing so remember these

par(mfrow = c(1, 2))
hist(znormal, breaks = 100)
abline(v = qnorm(c(0.25, 0.5, 0.75)), lwd =2)
abline(v = qnorm(c(0.025, 0.975)), lwd =2, lty = "dashed")
plot(density(znormal))
abline(v = qnorm(c(0.25, 0.5, 0.75)), col = "gray")
abline(v = qnorm(c(0.025, 0.975)), lty = "dotted", col = "black")
abline(h = 0, lwd = 3, col = "blue")
text(2, 0.3, "1.96", col = "red", adj = 0)
text(-2, 0.3, "-1.96", col = "red", adj = 1)


boxplot(d$Tarsus~d$Sex.1, col = c("red", "blue"), ylab="Tarsus length (mm)")

