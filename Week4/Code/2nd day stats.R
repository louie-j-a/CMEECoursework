DF <- read.table("../Data/SparrowSize.txt", header = T)
head(DF)

hist(DF$BirdID) # count data
hist(DF$Year) # count
hist(DF$Tarsus) # continuous
hist(DF$Bill) # continuous
hist(DF$Wing) # continuous
hist(DF$Mass) # continuous
hist(DF$Sex) # categorical, ranked
hist(DF$Sex.1) # categorical, ranked

x <- rnorm(1000000)
hist(x, breaks = 1000)

p <- rpois(100, 5)
hist(p, breaks = 10000)

b <- rbinom(10, 10000000, 0.6)
hist(b, breaks = 100)

hist(runif(1000, min = 0, max = 100), breaks = 1000)



#####################################################
###standard error
#####################################################

l <- subset(DF, DF$Tarsus != "NA")
sqrt(sd(l$Tarsus)/length(l))

l <- subset(DF, DF$Bill != "NA")
sqrt(sd(l$Bill)/length(l))

l <- subset(DF, DF$Wing != "NA")
sqrt(sd(l$Wing)/length(l))

l <- subset(DF, DF$Mass != "NA")
sqrt(sd(l$Mass)/length(l))




