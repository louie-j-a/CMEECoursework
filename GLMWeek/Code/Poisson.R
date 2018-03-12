rm(list = ls())
setwd("~/CMEECourseWork/GLMWeek/Code/")

gala <- read.table("../Data/gala.txt", header = T)
str(gala)
plot(Species ~ Area, data=gala, pch=19, cex=0.8)
#log transform the area to visualise data
plot(Species ~ log(Area), data=gala, pch=19, cex=0.8)

#The	problem is	that	the	data	is	count	data:	there	is increasing	variance	and	the	data	is	bounded below	at zero.

## when you specify the family type in glm(), it refers to the error distribution

gala$lgArea <- log(gala$Area)
galaMod <- glm(Species ~ lgArea, data=gala, family=poisson(link = log))

summary(galaMod)

#The	summary	of doesn't	include	 R^2.	This	can't	be defined	for	a	GLM,	since	the	residual	sums	of squares	don't	make	sense	as	a	measure	of	model	fit, but	we	can	calculate	the	proportion	of	the	null deviance	explained,	which	does	a	similar	job.	

(galaMod$null.deviance - galaMod$deviance) / galaMod$null.deviance


#diagnostic plots now show deviance residuals which should still be normally distributed with constant variance

par(mfrow=c(1,2))
plot(galaMod, which=c(1,2))
#everything looks good from these plots

#back transforming the cofficients
exp(0.3377)

# predict for a neat sequence of log area values 	
pred <- expand.grid(lgArea = seq(-5, 9, by=0.1)) 	
head(pred) 	
tail(pred)

pred$fit <- predict(galaMod, newdata = pred, type = "response")
head(pred)

# plot the logged data and the model lines 	

plot(Species ~ log(Area), data=gala) 	
lines(fit ~ lgArea, data=pred, col='red') 	




##################################################
############ AMPHIBIAN ROADKILLS #################
##################################################

roadkill <- read.table("../Data/RoadKills.txt", header = T)
head(roadkill)
str(roadkill)


plot(TOT.N ~ D.PARK, data=roadkill)

RKMod <- glm(roadkill$TOT.N~roadkill$D.PARK, family = poisson(link = log))
summary(RKMod)


(RKMod$null.deviance - RKMod$deviance)/RKMod$null.deviance

par(mfrow=c(2,2))
plot(RKMod)

exp(-1.059e-04)

#drawing line of predicted values
pred <- expand.grid(D.PARK = seq(0, 25000, by=481))
head(pred)
tail(pred)
pred$fit <- predict(RKMod, newdata = pred, type = 'response')
head(pred)

plot(roadkill$TOT.N~roadkill$D.PARK)
lines(fit ~ D.PARK, data=pred, col='red') 


##################################################
########### GRASSLAND SPECIES RICHNESS ###########
##################################################

species <- read.table("../Data/species.txt", header=T) 	
head(species) 	
str(species) 	

mfull <- glm(Species~pH*Biomass, data=species, family=poisson) 	
m2 <- glm(Species~pH+Biomass, data=species, family=poisson) 	

require(lmtest) 	

lrtest(mfull, m2)  # likelihood ratio test between the two models; second model has lower loglikelihood than first

AIC(mfull, m2)
#AIC agrrees with likelhood ratio test

summary(mfull)
plot(mfull)


plot(species$Species~species$Biomass, col=species$pH)
levels(species$pH) 
palette()

