rm(list = ls())

d <- read.table("../Data/SparrowSize.txt", header = T)

boxplot(d$Mass~d$Sex.1, col = c("red", "blue"), ylab = "Body mass (g)")

t.test1 <- t.test(d$Mass~d$Sex.1)
t.test1

##### reducing sample size to see if we see effect with n = 50
d1 <- as.data.frame(head(d, 50))
length(d1$Mass)

t.test2 <- t.test(d1$Mass~d1$Sex.1)
t.test2


#### test wing length in 2001 differs from grand-total mean
sub01 <- subset(d, d$Year == 2001)
t.test(sub01$Wing, d$Wing)
#### no difference; (mean =, two sample t-test, t = , df =, p<)

#### test if male and female wing length differ in 2001
t.test(sub01$Wing~sub01$Sex.1)
#### do differ

#### test if male and femal wing length differ in whole dataset
t.test(d$Wing~d$Sex.1)
#### do differ


#### test if male and female tarsus differs in full dataset
t.test(d$Tarsus~d$Sex.1)
#### do differ
