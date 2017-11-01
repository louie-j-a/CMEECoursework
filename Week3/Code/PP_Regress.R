#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 10.2017
#Version: 0.0.1 

require(ggplot2)
require(plyr)

data <- read.csv("../Data/EcolArchives-E089-51-D1.csv", header=T)
View(data)
names(data)


for (i in 1:nrow(data)){
  if (data$Prey.mass.unit[i] == "mg"){
    data$Prey.mass[i] <- data$Prey.mass[i]/1000
    data$Prey.mass.unit[i] <- "g"
  }
}


p <- ggplot(data, aes(x = Prey.mass,
                      y = Predator.mass,
                      colour = Predator.lifestage)) +
  facet_grid(Type.of.feeding.interaction ~.) +
  scale_x_log10(name = "Prey Mass in grams",
                breaks = c(1e-07, 1e-03, 1e+01)) +
  scale_y_log10(name = "Predator Mass in grams",
                breaks = c(1e-06, 1e-02, 1e+02, 1e+06))

p <- p + geom_point(shape = I(3)) +
  geom_smooth(method = lm, fullrange = T, size=I(0.25)) +
  theme(legend.position = "bottom",
        panel.background = element_rect(fill = NA),
        panel.grid.major = element_line(colour = "grey85", size = 0.35),
        panel.grid.minor = element_line(colour = "grey95"),
        panel.border = element_rect(fill = NA, colour = "grey", size = 0.75),
        axis.text = element_text(colour = "black", size = 10), 
        strip.text = element_text(face = "bold", colour = "black", size = 5),
        strip.background = element_rect(colour = "grey", size = 0.75)) +
  guides(col = guide_legend(nrow = 1))

pdf("../Results/PP_Regress_Graph.pdf")
print(p)
dev.off()



######################################################################################
# regressions for all feeding type x predator lifestage combinations
# y = log(predator mass), x = log(prey mass)
######################################################################################


# function to run linear model on log Predator mass by log Prey mass.  
lm1 <- function(df) { 
  lm(log(df$Predator.mass) ~ log(df$Prey.mass))
}

# extracts p-values from dataframe, also replaces null values with NA.
pval <- function(df) {
  x <- summary(df)
  x$fstatistic[1] <- ifelse(is.null(x$fstatistic[1]), NA, x$fstatistic[1])
  x$fstatistic[2] <- ifelse(is.null(x$fstatistic[2]), NA, x$fstatistic[2])
  x$fstatistic[3] <- ifelse(is.null(x$fstatistic[3]), NA, x$fstatistic[3])
  
  y <- (pf(x$fstatistic[1], x$fstatistic[2], x$fstatistic[3], lower.tail = FALSE))
}

# extracts f-statistics and replaces nulls with NA.
fstat <- function(df) {
  f <- summary(df)$fstatistic[1]
  ifelse(is.null(f), NA, f)
}

# combines pval and fstat and extracts r2 and cf and adds them all together in a new data frame
combine.stats <- function(df) {
  cf <- coef(df)
  r2 <- summary(df)$adj.r.squared
  f <- fstat(df)
  p <- pval(df)
  data.frame(intercept = cf[1], slope = cf[2],  Rsq = r2, f.statistic = f, p.value = p)
}

# applies the above function, lm1, to data and groups data by Type.of.feeding.interaction and Predator.lifestage
linearmods <- dlply(data, .(Type.of.feeding.interaction, Predator.lifestage),.fun = lm1)
# applies combine.stats to contents of linearmods, and outputs the statistics to data frame called "final".
RegResults <- ldply(linearmods, combine.stats)

write.csv(RegResults, "../Results/PP_Regress_Results.csv", row.names=FALSE)

