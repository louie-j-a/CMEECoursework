rm(list=ls())
setwd("~/CMEECourseWork/GLMWeek/Code/")

d <- read.table("../Data/ObserverRepeatability.txt", header = T)
str(d)

hist(d$Tarsus)
hist(d$BillWidth)

#remove incorrect measurments
d <- subset(d, d$Tarsus<=40)
d <- subset(d, d$Tarsus>=10)
hist(d$Tarsus)

summary(d$Tarsus)
var(d$Tarsus)

summary(d$BillWidth)
var(d$BillWidth)


#package for lmms
require(lme4)

require(lmtest)


mT1 <- lmer(Tarsus ~ 1 + (1|StudentID), data=d)
mT2 <- lmer(Tarsus ~ 1 + (1|StudentID) + (1|GroupN), data=d)
#likelihood ratio test
lrtest(mT1, mT2)
###The	LRT	test	is not	statistically	significant	for	tarsus,	so	more	complex	model	(mT2)	doesn't	explain	the	data	better.	But it is	worth	noting	that	it's	close,	so	maybe if	I	keep	measuring	it	I	need	to	keep	an	eye	on it.

summary(mT1)
3.21 / (3.21 + 1.23)


########## Now for Bill Length ###############

mBW1 <- lmer(BillWidth ~ 1 + (1|StudentID), data=d)
mBW2 <- lmer(BillWidth ~ 1 + (1|StudentID) + (1|GroupN), data=d)

#likelihood ratio test
lrtest(mBW1, mBW2)
#mBW2 not significantly better

summary(mBW1)
0.5484 / (0.5484 + 0.2069)
###################### see questions at end of page, not really sure ive answered them ##########################



###################################################
############ Linear mixed models 2 ################
###################################################


rm(list=ls())
setwd("~/CMEECourseWork/GLMWeek/Code/")

d <- read.table("../Data/DataForMMs.txt", header = T)
str(d)
max(d$Individual)

#need to tell R to treat Individual as a factor rather than a continuous variable
d$Individual <- as.factor(d$Individual)
names(d)

par(mfrow=c(2,3))
hist(d$LitterSize)
hist(d$Size)
hist(d$Hornlength)
hist(d$Bodymass)
hist(d$Glizz)
hist(d$SexualActivity)
dev.off()


## hypothesis 1; test for sexual trimorphism in mass, size, horn length
par(mfrow=c(1,3))
boxplot(d$Bodymass~d$Sex)
boxplot(d$Size~d$Sex)
boxplot(d$Hornlength~d$Sex)

#run lmm accounting for psuedoreplication by including individual as a random effect
require(lme4)
#this is a package that we can use for lmms. MCMCglmm does the same, but this one is ok for easier stuff.

h1m1 <- lmer(Bodymass ~ Sex + (1|Individual), data = d)
summary(h1m1)
#The	SE	is	larger	than	the	parameter	estimate.	Also,	the	t-value	is	WAY	below	2.	Maybe	variation	within	and	betwen	families	does cloud	the	picture.	Maybe..	so	we'll	add	the family	as	random	factor:	

h1m2 <- lmer(Bodymass ~ Sex + (1|Individual) + (1|Family), data=d)
summary(h1m2)

#family	explains	nearly	as	much	variance	as	individual.	However,	the	SD	is	also	quite	large.	Let's	use	a	likelihood	ratio	test	to	see	if	adding	this	extra	parameter	to	the	model	improves	the	model:	

require(lmtest)

lrtest(h1m1, h1m2)
#shows adding family when testing bodymass is better fit 

