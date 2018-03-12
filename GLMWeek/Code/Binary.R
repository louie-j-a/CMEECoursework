rm(list=ls())
setwd("~/CMEECourseWork/GLMWeek/Code/")

galliformes <- read.table("../Data/galliformesData.txt", header = T)
str(galliformes)

galliformes <- na.omit(galliformes)

#convert IUCN categories to binary (0s and 1s)
galliformes$ThreatBinary <- ifelse(galliformes$Status04 %in% c("1_(LC)", "2_(NT)"), 0, 1)

#scatter plot matrix
pairs(ThreatBinary ~ Range + Mass + Clutch + ElevRange, data = galliformes)

galliformes$lgMass <- log(galliformes$Mass)
galliformes$lgRange <- log(galliformes$Range)
galliformes$lgClutch <- log(galliformes$Clutch)
galliformes$lgElevRange <- log(galliformes$ElevRange)

pairs(ThreatBinary ~ lgRange + lgMass + lgClutch + lgElevRange, data=galliformes)


par(mfrow=c(2,2))
plot(ThreatBinary ~ lgRange, data = galliformes)
plot(ThreatBinary ~ lgMass, data = galliformes)
plot(ThreatBinary ~ lgClutch, data = galliformes)
plot(ThreatBinary ~ lgElevRange, data = galliformes)

#running the model, the squared term is a quick wa to include all the interaction terms without having to actually type them out
galliMod <- glm(ThreatBinary ~ (lgRange + lgMass + lgClutch + lgElevRange)^2, data=galliformes, family = binomial(link = logit))

summary(galliMod)

#No coefficients were found to be significant, delete least significant value and try again
galliMod2 <- glm(ThreatBinary ~ (((lgRange + lgMass + lgClutch + lgElevRange)^2) - lgMass:lgClutch), data=galliformes, family = binomial(link = logit))

summary(galliMod2)


#Now lgMass is the least significant term in the model, but we can't remove it as it is still involved in an interaction term, instead we remove the next least significant term
galliMod3 <- glm(ThreatBinary ~ (((lgRange + lgMass + lgClutch + lgElevRange)^2) - (lgMass:lgClutch + lgRange:lgClutch)), data=galliformes, family = binomial(link = logit))

summary(galliMod3)


galliMod4 <- glm(ThreatBinary ~ (((lgRange + lgMass + lgClutch + lgElevRange)^2) - (lgMass:lgClutch + lgRange:lgClutch + lgClutch:lgElevRange)), data=galliformes, family = binomial(link = logit))

summary(galliMod4)


galliMod5 <- glm(ThreatBinary ~ ((lgRange + lgMass + lgElevRange)^2), data=galliformes, family = binomial(link = logit))

summary(galliMod5)


galliMod6 <- glm(ThreatBinary ~ (((lgRange + lgMass + lgElevRange)^2)-(lgRange:lgMass)), data=galliformes, family = binomial(link = logit))

summary(galliMod6)



galliMod7 <- glm(ThreatBinary ~ (((lgRange + lgMass + lgElevRange)^2)-(lgRange:lgMass + lgRange:lgElevRange)), data=galliformes, family = binomial(link = logit))

summary(galliMod7)


galliMod8 <- glm(ThreatBinary ~ (((lgRange + lgMass + lgElevRange)^2)-(lgRange:lgMass + lgRange:lgElevRange +lgMass:lgElevRange)), data=galliformes, family = binomial(link = logit))

summary(galliMod8)
#now all terms are significant so model is done