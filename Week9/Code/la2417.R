#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 11.2017
#Version: 0.0.1 


rm(list = ls()) # Removes all objects from the current workspace
graphics.off() # Closes any open plots

community <- c() # create vector to store community structure 

species_richness <- function(community){ # calculates species richness of a given community 
  sr <- length(unique(community)) # extracts all unique numbers (species) from community and counts how many numbers this is.
  return(sr)
}


initialise_max <- function(size){ # produces a community of maximal diversity when provided with community size
  MaxSp <- seq(1, size) # gives vector of numbers from 1 to size, will be used later for community with maximum diversity (i.e., no two numbers (species) will be the same).
  return(MaxSp)
}


initialise_min <- function(size){ # produces a community of minimal diversity when provided with community size
  MinSp <- c() # creates empty vector to be filled in a for loop
  for (i in 1:size){
    MinSp[i] <- 1 # puts a 1 in each position in the vector, to represent a community with minimal diversity.
  }
  return(MinSp)
}


choose_two <- function(x){ # chooses two numbers between 1:x, will be used in later functions for indexing 
  C2 <- sample(c(1:x), 2, replace = F) # takes a sample of 2 numbers from a vector containing numbers 1 through to x and places them in a new vector. replace = FALSE prevents sample() from picking the same number twice.
  return(C2)
}


neutral_step <- function(community){ # performs single time step in neutral model
  index <- choose_two(length(community)) # chooses two numbers between 1 and abundance
  community[index[1]] <- community[index[2]] # uses these numbers as index as to which individual will be replaced and who will replace them 
  #community <- replace(community, index[1], community[index[2]]) # replaces species from community, at index equal to index[1] with species from community at index equal to index[2]
  return(community) # returns new community
}

neutral_generation <- function(community){ # performs multiple steps in neutral model to simulate an entire generation
  for (i in 1:ceiling((length(community)/2))){ # one generation is equal to half the abundance; ceiling is used to round up in case of uneven abundances
   community <- neutral_step(community) # performs single step of model, each time replaces community with new step to be used again in loop
  }
  return(community)
}


neutral_time_series <- function(initial, duration){ # creates time series of species richness over set duration, initial is the initial community structure
  TimeSeries <- c(species_richness(initial)) # sets the first element in time series to the initial species richness
  for (i in 1:duration){ # performs action as many times as defined by the argument 'duration'
    initial <- neutral_generation(initial) # alters initial community by simulating neutral model for one generation
    TimeSeries[i+1] <- species_richness(initial) # measures species richness and adds to next step in time series
  }
  return(TimeSeries) # returns the time series
}



# Question 8

question_8 <- function(){ # plots graph of time series for community of size 100, with maximal diversity, over 200 generations
  png(file = "../Results/Q8Plot.png") # sets name and relative path
  plot(neutral_time_series(initial = initialise_max(100), 200), # creates time series through nuetral model 
       type = "l", # plots as line graph
       xlab = "Generations", # x-axis label
       ylab = "Species Richness", # y-axis label
       main = "Neutral Model Simulation") # title of graph
  dev.off() # turns graphics off
}

#Q9
neutral_step_speciation <- function(community, v){ # performs single step of neutral model with speciation now included with probability 'v'
  index <- choose_two(length(community)) # chooses indexes of two individuals to act in model
  if ((runif(1, 0, 1)<=v)){ # decides if speciation occurs or not; if random number produced by runif() is less than or equal to v, then speciation occurs
  step2 <- replace(community, index[1], (max(community)+1)) # speciation is simulated by replacing individual with a number (species) greater than the largest number within community 
  }
  else{ # if runif() produces a number greater than v, then speciation will not occur 
  step2 <- replace(community, index[1], community[index[2]]) # no speciation, just one individual dying and replaced with offspring of individual at community[index[2]]
  }
  return(step2) # step2 is vector containing the new community 
}  


#Q10
neutral_generation_speciation <- function(community, v){ # performs neutral model with speciation over a single generation
  for (i in 1:ceiling((length(community)/2))){ # one generation is equal to half the abundance; ceiling is used to round up in case of uneven abundances
    community <- neutral_step_speciation(community, v) # performs single step of model, each time replaces community with new step to be used again in loop
  }
  return(community) # returns community after one generation, with speciation added to model
}


#Q11

neutral_time_series_speciation <- function(community, v, duration){ # creates time series of species richness when speciation is included in model
  TimeSeries <- c(species_richness(community)) # first step in time series set as intial species richness of community 
  for (i in 1:duration){ # performs function for number of times defined by the argument 'duration'
    community <- neutral_generation_speciation(community, v) # performs one generation of neutral model with speciation
    TimeSeries[i+1] <- species_richness(neutral_generation_speciation(community, v)) # measures species richness and stores it as next step of times series
  }
  return(TimeSeries) # returns time series 
}


#Q12
question_12 <- function(){ # plots times series when speciation is included in model, for two communities of size 100, one of maximal diversity and another with minimal diversity. 200 generations are simulated with a speciation rate of 0.1
  png(file = "../Results/Q12Plot.png") # sets file name and relative path
  plot(neutral_time_series_speciation(community = initialise_max(100), 0.1, 200), # creates time series for community of maximal diversity
       type = "l", # plots as line graph
       col = "blue", # plots a blue line for first model
       xlab = "Generations", # x-axis label
       ylab = "Species Richness", # y-axis label
       main = "Neutral Model Simulation With Speciation", # title of graph
       ylim = c(0,100)) # sets limits of y-axis as 0 to 100
  lines(neutral_time_series_speciation(community = initialise_min(100), 0.1, 200), # creates time series for community of minimal diversity
        col = "red") # plots as red line
  dev.off() # turn graphics off
}


#Q13
species_abundance <- function(community){ # calculates abundances of each species in community
  SpAbVec <- as.vector(sort(table(community), decreasing = T)) # first creates table of counts of all numbers (representing species) in community; then sorts them into descending order; then stores these values as a vector
  return(SpAbVec) # returns SpAbVec, the species abundance vector
}


#Q14
octaves <- function(SpeciesAbundance){ # puts species abundance into octave class bins
  oct <- tabulate(log2(SpeciesAbundance)+1) # tabulate counts the number of times an integer occurs in a bin; log2 makes the bins of size 2(n-1); the +1 is to ensure 0 values are not missed
  return(oct)
}


#Q15
sum_vect <- function(x, y){ # reutrns the sum of two vectors, if the lengths of the two vetors differ, zeros will be appended to the end of the shoreter vector before sumation
  if (length(x)<length(y)){ # if vector x is shorter than vector y;
    x <- append(x, rep(0, (length(y)-length(x))), after = length(x)) # append zeros to the end of vector x, until vector x is the same length as vecotr y
  }
  if (length(y)<length(x)){ # if vector y is shorter than vector x;
    y <- append(y, rep(0, (length(x)-length(y))), after = length(y)) # append zeros to the end of vector y, until vector y is the same length as vecotr x
  }
  z <- x + y # create vector z that is the sum of vectors x and y
  return(z)
}


#Q16
question_16 <- function(){ # function to create barplot of octaves produced during a neutral model simulation with speciation
  comm <- initialise_max(100) # create community of maximal diversity, with size 100 
  for (i in 1:200){ # repeat this loop for a burn in period of 200 generations
    comm <- neutral_generation_speciation(community = comm, v = 0.1) # comm is updated with the community produced by one generation of the model with speciation rate of 0.1
  }
  oct <- octaves(species_abundance(comm)) # record the octaves of the speciea abundance after burn in period
  for (i in 1:2000){ # run the model for a further 2000 generations
    comm <- neutral_generation_speciation(comm, 0.1) 
    if (i %% 20 == 0){ # every 20 generations, record the octaves of the species abundances
      oct <- sum_vect(oct, octaves(species_abundance(comm))) # for each run of the loop, add the current octave to the octave previously recorded 
    }
  }
    oct <- oct/101 # find mean of all octaves recorded 
    png(file = "../Results/Q16Plot.png") # sets file name and relative path
    barplot(oct, 
      names.arg = c(1,2,4,8,16,32),
      main = "Species Abundance Octaves for Neutral Model with Speciation",
      xlab = "Species Abundance Octave",
      ylab = "Frequency") # create bar plot of mean octaves
    dev.off() # turn graphics off
}


#Challenge A

challenge_A <- function(){ # plots time series for many repeat neutral model simulations
  SpRchDFMax <- data.frame(c(1:2201)) # create data frames to store time series
  SpRchDFMin <- data.frame(c(1:2201))
  for (sim in 1:50){ # 50 simulations
    comm <- initialise_max(100) # initialise community of max diversity
    SpRchMax <- c(species_richness(comm)) # measure species richness
    for (gen in 1:2200){ # 2200 generations in each simulation
      comm <- neutral_generation_speciation(community = comm, v = 0.1) # perform one generation of simulation
      SpRchMax[gen +1] <- c(species_richness(comm))# record species richness at next generation
      }
    SpRchDFMax[sim] <- SpRchMax # store the time series of each simulation in data frame
    
    #same as above but for minimal divesrsity
    comm <- initialise_min(100)
    SpRchMin <- c(species_richness(comm))
    for (gen in 1:2200){
      comm <- neutral_generation_speciation(community = comm, v = 0.1)
      SpRchMin[gen +1] <- c(species_richness(comm))
      }
    SpRchDFMin[sim] <- SpRchMin
  }
  MeanMax <- rowMeans(SpRchDFMax) # find row means, which correspond to mean species richness for each generation
  MeanMin <- rowMeans(SpRchDFMin)
  MaxConf <- apply(as.matrix(SpRchDFMax), 1, function(x){ # find 97.2% confidence intervals
    mean(x)+c(-qnorm(0.986),qnorm(0.986))*sd(x)/sqrt(length(x))
    })
  MinConf <- apply(as.matrix(SpRchDFMin), 1, function(x){
    mean(x)+c(-qnorm(0.986),qnorm(0.986))*sd(x)/sqrt(length(x))
    })
  png(file = "../Results/ChalAPlot.png") # sets file name and relative path to save graphs
  par(mfrow = c(2,1), font.main = 12) # plots 2 graphs in one window
  plot(MeanMax, type = "l", col = "red", main = "Maximal Initial Species Richness", xlab = "Generations", ylab = "Species Richness") # plots mean time series
  lines(MaxConf[1,], lty = "dashed", col = "black", cex = 0.1) # adds confidence intervals
  lines(MaxConf[2,], lty = "dashed", col = "black", cex = 0.1)
  plot(MeanMin, type = "l", col = "blue", main = "Minimal Initial Species Richness", xlab = "Generations", ylab = "Species Richness")
  lines(MinConf[1,], lty = "dashed", col = "black", cex = 0.1)
  lines(MinConf[2,], lty = "dashed", col = "black", cex = 0.1)
  title("Mean Species Richness Over Time for 50 Simulations of Neutral Model", outer = T, line = -1)
  dev.off()
  }

# Challenge B

initialise_comm <- function(size, SpRich) { # creates community of set size and species richness
    community <- sample.int(SpRich, SpRich, replace = F)
    for (i in 1:(size-SpRich)) {
      ran <- sample.int(SpRich, 1, replace = T)
      community[SpRich + i] <- ran
    }
    return(community)
  }

challenge_B <- function(){# plots mean time series for many communities of various species richnesses
  TimeSeries20 <- data.frame(c(1:1001)) # create data frames to add time series to
  TimeSeries40 <- data.frame(c(1:1001))
  TimeSeries60 <- data.frame(c(1:1001))
  TimeSeries80 <- data.frame(c(1:1001))
  TimeSeries100 <- data.frame(c(1:1001))

  for (i in 1:10){ # repeat 10 times for each species richness
    community <- initialise_comm(100, 20) 
    TimeSeries20[i] <- neutral_time_series_speciation(community, 0.1, 1000)
  }

  for (i in 1:10){
    community <- initialise_comm(100, 40)
    TimeSeries40[i] <- neutral_time_series_speciation(community, 0.1, 1000)
  }

  for (i in 1:10){
    community <- initialise_comm(100, 60)
    TimeSeries60[i] <- neutral_time_series_speciation(community, 0.1, 1000)
  }

  for (i in 1:10){
    community <- initialise_comm(100, 80)
    TimeSeries80[i] <- neutral_time_series_speciation(community, 0.1, 1000)
  }

  for (i in 1:10){
    community <- initialise_comm(100, 100)
    TimeSeries100[i] <- neutral_time_series_speciation(community, 0.1, 1000)
  }

  mean20 <- rowMeans(TimeSeries20) # finds mean species richness at each generation
  mean40 <- rowMeans(TimeSeries40)
  mean60 <- rowMeans(TimeSeries60)
  mean80 <- rowMeans(TimeSeries80)
  mean100 <- rowMeans(TimeSeries100)
  
  png(file = "../Results/ChalBPlot.png") # sets file name and relative path
  par(mfrow = c(3, 2))
  plot(mean20, type = "l", main = "Initial Richness = 20", xlab = "Generations", ylab = "Species Richness")
  plot(mean40, type = "l", main = "Initial Richness = 40", xlab = "Generations", ylab = "Species Richness")
  plot(mean60, type = "l", main = "Initial Richness = 60", xlab = "Generations", ylab = "Species Richness")
  plot(mean80, type = "l", main = "Initial Richness = 80", xlab = "Generations", ylab = "Species Richness")
  plot(mean100, type = "l", main = "Initial Richness = 100", xlab = "Generations", ylab = "Species Richness")
  title("Mean Species Richness Over Time for Neutral Model", outer = T, line = -1)
  dev.off()

}

#Q17


cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name){ # runs model for a set amount of real time; includes a burn in period; creates an ouptut file for each simulation; records species richness, octaves of abundances,
  comm <- initialise_min(size) # create initial community with minimal diversity and size of 100
  i <- 1 # create counter variable for while loop
  SpRichBurn <- c() # create empty vector to store species richness values during the burn in period
  oct <- list() # create empty list to store abundance octaves for the duration of the simulation
  ptm <- proc.time() # start timer here
  while ((proc.time()[3] - ptm[3]) <= (60*wall_time)){ # until timer reaches a time defined by wall_time, carry out the following code;
    comm <- neutral_generation_speciation(comm, speciation_rate) # update community vector (comm) with the results from applyinh one generation of the neutral model with speciation
    if (i %in% seq(0,burn_in_generations,interval_rich)){ # if counter variable, i, is found within the sequence of numbers defined in seq();  
        SpRichBurn[i/interval_rich] <- species_richness(comm) # record the species richness of the community and add to SpRichBurn at next position in vector
      }
    if (i %% interval_oct == 0){ # if i is a multiple of interval_oct;
      oct[i/interval_oct] <- list(octaves(species_abundance(comm))) # record the abundance octaves and add to oct at next position in list
    }
     i = i + 1 # add 1 to counter variable for next run in loop
  }
  time <- proc.time()[3] - ptm[3] # record and store time elapsed 
  save(SpRichBurn, oct, comm, time, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, file = output_file_name) # save data to .rda file
}


#Q18
# 
# iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX")) # index to read in job number from HPC cluster
# 
# # iter <- 1  # this is for testing locally only
#  
# if (iter %in% seq(1, 100, 4)){ # if job number is in this sequence;
#   J <- 500 # then community size was set to 500
# } else if (iter %in% seq(2, 100, 4)){ #else if job number in this sequence;
#   J <- 1000 # then community size was set to 1000
# } else if (iter %in% seq(3, 100, 4)){
#   J <- 2500
# } else if (iter %in% seq(4, 100, 4)){
#   J <- 5000
# }
#   
# my_sp_rate <- 0.003369 # speciation rate
# file_name <- paste0("neutral_sim_", iter, ".rda") # creating output file names e.g. neutral_sim_1.rda
# #time <- (11.5*60)
# 
# set.seed(iter)  # changes seed for random number generation for each iteration
# cluster_run(my_sp_rate, J, wall_time = (11.5*60), 1, (J/10), (J*8), file_name) #runs cluster_run on HPC cluster
# 


#Q20

question_20 <- function(){
#setwd("../Results/")
files <- list.files(pattern = "neutral_sim*") # creates list of files output from HPC
#setwd("../Code/")

oct500 <- list() # generates empty lists for each different community size used in the HPC cluster
oct1000 <- list()
oct2500 <- list()
oct5000 <- list()

oct500length <- c(0) # creates empty vectors to count the total number of octaves recorded for each community size during HPC run
oct1000length <- c(0)
oct2500length <- c(0)
oct5000length <- c(0)


for(i in 1:length(files)){ #loop through all files
  load(files[i]) # load each file one by one 
  if (size == 500){ # if the community size is 500;
    oct500 <- c(oct500, oct[81:length(oct)]) # add all the octaves from this file, apart from those recorded during burn in, to the octave vector created for community sizes of 500  
    oct500length <- (oct500length + (length(oct)-80)) # sums the amount of octaves recorded for all runs for community sizes of 500 
  } # below code does same as above for different community sizes
  if (size == 1000){
    oct1000 <- c(oct1000, oct[81:length(oct)])
    oct1000length <- (oct1000length + (length(oct)-80))
  }
  if (size == 2500){
    oct2500 <- c(oct2500, oct[81:length(oct)])
    oct2500length <- (oct2500length + (length(oct)-80))
  }
  if (size == 5000){
    oct5000 <- c(oct5000, oct[81:length(oct)])
    oct5000length <- (oct5000length + (length(oct)-80))
  }
}

PlotOct500 <- oct500[[1]]
for (i in 1:length(oct500)){
  PlotOct500 <- sum_vect(PlotOct500, oct500[[i]])
} # iterates through octaves list and sums all items 
PlotOct500 <- PlotOct500/oct500length # finds mean abundance octaves for all simulations with community size of 500

PlotOct1000 <- oct1000[[1]]
for (i in 1:length(oct1000)){
  PlotOct1000 <- sum_vect(PlotOct1000, oct1000[[i]])
}
PlotOct1000 <- PlotOct1000/oct1000length

PlotOct2500 <- oct2500[[1]]
for (i in 1:length(oct2500)){
  PlotOct2500 <- sum_vect(PlotOct2500, oct2500[[i]])
}
PlotOct2500 <- PlotOct2500/oct2500length

PlotOct5000 <- oct5000[[1]]
for (i in 1:length(oct5000)){
  PlotOct5000 <- sum_vect(PlotOct5000, oct5000[[i]])
}
PlotOct5000 <- PlotOct5000/oct5000length

print("Mean octaves for J = 500") 
print(PlotOct500)

print("Mean octaves for J = 1000") 
print(PlotOct1000)

print("Mean octaves for J = 2500") 
print(PlotOct2500)

print("Mean octaves for J = 5000") 
print(PlotOct5000)

png(file = "../Results/Q20Plot.png") # sets file name and relative path
par(mfrow = c(2,2), las = 2) # 2 columns and 2 rows of graphs to be plotted
# plot mean abundance octaves for each community size
barplot(PlotOct500, main = "Community size = 500", xlab = "Species Abundance Octave", ylab = "Frequency", names.arg = c(2^(0:8)))
barplot(PlotOct1000, main = "Community size = 1000", xlab = "Species Abundance Octave", ylab = "Frequency", names.arg = c(2^(0:9)))
barplot(PlotOct2500, main = "Community size = 2500", xlab = "Species Abundance Octave", ylab = "Frequency", names.arg = c(2^(0:10)))
barplot(PlotOct5000, main = "Community size = 5000", xlab = "Species Abundance Octave", ylab = "Frequency", names.arg = c(2^(0:11)))
title("Mean Species Abundance Octaves for Neutral Model Simulated on HPC", outer = T, line = -1)
dev.off()
}


#Challenge C


challenge_C <- function(){
  files <- list.files(pattern = "neutral_sim*") # creates list of files output from HPC

  SR500 <- c()
  SR1000 <- c()
  SR2500 <- c()
  SR5000 <- c()

  for(i in 1:length(files)){ #loop through all files
    load(files[i]) # load each file one by one 
    if (size == 500){ # if the community size is 500;
      SR500 <- sum_vect(SR500, SpRichBurn)
    } 
    if (size == 1000){
      SR1000 <- sum_vect(SR1000, SpRichBurn)
    }
    if (size == 2500){
      SR2500 <- sum_vect(SR2500, SpRichBurn)
    }
    if (size == 5000){
      SR5000 <- sum_vect(SR5000, SpRichBurn)
    }
  }
  SR500 <- SR500/25 # finds mean over 25 simulations
  SR1000 <- SR1000/25
  SR2500 <- SR2500/25
  SR5000 <- SR5000/25

  png(file = "../Results/ChalCPlot.png") # sets file name and relative path
  par(mfrow = c(2,2), font.main = 12) # 2 columns and 2 rows of graphs to be plotted
  plot(SR500, type = "l", main = "J = 500", xlab = "generations", ylab = "Species Richness")
  grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = T)
  plot(SR1000, type = "l", main = "J = 1000", xlab = "generations", ylab = "Species Richness")
  grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = T)
  plot(SR2500, type = "l", main = "J = 2500", xlab = "generations", ylab = "Species Richness")
  grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = T)
  plot(SR5000, type = "l", main = "J = 5000", xlab = "generations", ylab = "Species Richness")
  grid(nx = NULL, ny = NULL, col = "lightgray", lty = "dotted", lwd = par("lwd"), equilogs = T)
  title("Mean Species Richness for 25 Simulations of Neutral Model for Various Community Sizes", outer = T, line = -1)
  dev.off()
}


#Challenge D


challenge_D <- function(J = 500, v = 0.1){ # runs coalesence simulation for given community size and speciation rate
  lineages <- c(rep(1, J)) #initialise vector of 1's, and length J
  abundances <- c() #create empty abundance vector
  N <- J # create number N, set as equal to J
  theta <- v * ((J-1)/(1-v)) # create theta using equation
  while(N > 1){ 
    j <- ceiling(runif(1, 0, N)) # choose number between 1 and N to use as index
    randnum <- runif(1, 0, 1) # chose random number between 0 to 1
    if (randnum < (theta / (theta + N - 1))){ 
     abundances <- c(abundances, lineages[j]) # append lineage[j] to abundances vector
     } else { 
     repeat{ # repeat loop until below if statement is fulfilled
       i <- ceiling(runif(1, 0, N)) # create another index
       if (i != j){ # if i is not equal to j;
         break # break out of repeat loop
       }
     }
     lineages[i] <- lineages[i] + lineages[j] # add lineages[j] to lineages[i]
     }
    lineages <- lineages[-j] #remove lineages[j] from lineages
    N <- N - 1 # minus 1 from N, then go back to top of while loop
  }
  abundances <- c(abundances, lineages) # append lineages to abundances
  return(abundances) # returns abundances of community
}



###################################################################################
###############                  fractals                   #######################
###################################################################################



#Q18
log(8)/log(3) # follows formula for determining fractal dimension of self-similar fractal pattern

log(20)/log(3)

#Q19


chaos_game <- function(){ #draws fractal pattern 
  
  a <- c(0,0)
  b <- c(3,4)
  c <- c(4,1) # points will limits size and shape of fractal pattern 
  
  X <- a # point to be plotted, starts at (0,0)
  x <- c() # empty vector to be filled with next x value
  y <- c() # empty vector to be filled with next y value
  
  png(file = "../Results/chaos.png")
  plot(X[1],X[2], cex = 0.01, xlim = c(0,5), ylim = c(0,5)) # plots first point of graph

  for (i in 1:10000){
    points <- unlist(sample(list(a, b, c), 1)) # looks a bit ugly, must first create a list of vectors a, b, and c; then sample one of those vectors from the list; unlist allows the vector to be stored as a vector to be plotted later. 
    x <- (points[1] + X[1])/2 # this formula sets the next values of x to half way between the previous point and the point selected in the above line of code 
    y <- (points[2] + X[2])/2 # this line does the same as the above line, but for values of y
    lines(c(X[1], x[1]), c(X[2], y[1]), type = "p", cex = 0.01) # adds all new points (type = "p") to graph initialised above; the first argument of lines() the is a vector containing the current and next x value to be plotted, the second argument contains this same information but for the y values; cex sets size of points 
    X <- c(x[1], y[1]) # Set X as the coordinates of the newly plotted points so that the loop will plot from between here and a new set of coordinates during the next iteration.
  }
  dev.off()
}


# Challenge E


challenge_E <- function(){

  a <- c(0,0)
  b <- c(3,4)
  c <- c(4,1)  

    #equilateral triangle
  d <- c(0,0)
  e <- c(4,4)
  f <- c(8,0)

    # square
  g <- c(0,0)
  h <- c(0,6)
  i <- c(6,6)
  j <- c(6,0)

  
  X <- a #c(10,15) # start position doesnt really matter, might get a few points outside of fractal pattern
  x <- c()
  y <- c()
  
  png(file = "../Results/chalEequtri.png")
  #png(file = "../Results/chalEsquare.png")
  plot(X[1],X[2], cex = 0.01, xlim = c(0,6), ylim = c(0,4))

  for (i in 1:10000){
  #  points <- unlist(sample(list(a, b, c), 1))
    points <- unlist(sample(list(d, e, f), 1)) # equilateral triangle
  #  points <- unlist(sample(list(g, h, i, j), 1)) # square
    x <- (points[1] + X[1])*0.4
    y <- (points[2] + X[2])*0.4 #to get it to work for square pattern
    if (i <= 1000){ # first 1000 points coloured red
      lines(c(X[1], x[1]), c(X[2], y[1]), type = "p", cex = 0.01, col = "red") # plot new points
    }
    else{
      lines(c(X[1], x[1]), c(X[2], y[1]), type = "p", cex = 0.01) # plot new points
    }
    X <- c(x[1], y[1]) # change X to new points, ready to be used again at begining of next iteration of for loop
  }
  dev.off()
}


#Q20

qp <- function(){
  plot(0,0, 
  xlim = c(0,20), 
  ylim = c(0,20))
  } # plots (0,0) on a graph that will be added to later


turtle <- function(start_position, direction, length){ # function to plot a line on a graph when provided with the length, direction and starting potition of the line
  x <- (length * cos(direction)) + start_position[1] # uses trigonometry to find new x coordinate to draw line between, given the arguments input into the function 
  y <- (length * sin(direction)) + start_position[2] # uses trigonometry to find new x coordinate to draw line between, given the arguments input into the function
  lines(c(start_position[1], x), c(start_position[2], y), type = "l") # draws line on graph intialised in qp(), using the newly found x and y coordinates 
  return(c(x,y)) # returns new set of coordinates
}


#Q21

elbow <- function(start_position, direction, length){ # draws two connected lines whe nprovided with an starting position, direction and length of the first line
  a <- turtle(start_position, direction, length) # calls turtle to draw the first line, stores the coordinates of the end of this line in a vector called a
  turtle(a, direction - pi/4, length * 0.95) # calls turtle again, but with the end of the first line set as the new starting position; the direction of the new line will be at a 45 degree angle to the first line and the length of this line will be 0.95 times the length of the first
}


#Q22

spiral <- function(start_position, direction, length){ # draws a spiral
  a <- turtle(start_position, direction, length)
  spiral(a, direction - pi/4, length * 0.95) # keeps adding smaller and smaller lines to the first lines, creating a sprial; goes on forever
}

#Q23

spiral_2 <- function(start_position, direction, length){ # same as above function but ends at certain point
  if (length > 0.2){ # sets function to stop once the line being drawn falls bellow 0.2
  a <- turtle(start_position, direction, length)
  spiral_2(a, direction - pi/4, length * 0.95)
  }
}


#Q24

tree <- function(start_position, direction, length){ # draws a fractal tree
  if (length > 0.2){ # prevents infinite iterations
  a <- turtle(start_position, direction, length)
  tree(a, direction - pi/4, length * 0.65) # draws one branch on the right
  tree(a, direction + pi/4, length * 0.65) # draws another branch on the left
  }
}


#Q25

fern <- function(start_position, direction, length){
  if (length > 0.01){
  a <- turtle(start_position, direction, length)
  fern(a, direction + pi/4, length * 0.38)
  fern(a, direction, length * 0.87)
  }
}

#Q26

fern_2 <- function(start_position, direction, length, dir){
  if (length > 0.01){
  a <- turtle(start_position, direction, length)
  fern_2(a, direction + (dir * pi/4), length * 0.38, (-1 * dir))
  fern_2(a, direction, length * 0.87, (-1 * dir))
  }
}

# Challenge F


turtleF <- function(start_position, direction, length, colour, lWidth = 4){ # function to plot a line on a graph when provided with the length, direction and starting potition of the line
  x <- (length * cos(direction)) + start_position[1] # uses trigonometry to find new x coordinate to draw line between, given the arguments input into the function 
  y <- (length * sin(direction)) + start_position[2] # uses trigonometry to find new x coordinate to draw line between, given the arguments input into the function
  lines(c(start_position[1], x), c(start_position[2], y), type = "l", col = colour, lwd = lWidth)  # draws line on graph intialised in qp(), using the newly found x and y coordinates 
  return(c(x,y)) # returns new set of coordinates
}


fern_2F <- function(start_position, direction, length, dir, lWidth = 4){
  if (length > 0.01){
    if (length >= 0.05){
      a <- turtleF(start_position, direction, length, "brown", lWidth)
    }
    if (length < 0.05){
      a <- turtleF(start_position, direction, length, "green", lWidth)
    }
    fern_2F(a, direction + (dir * pi/4), length * 0.38, (-1 * dir), lWidth * 0.95)
    fern_2F(a, direction, length * 0.87, (-1 * dir), lWidth * 0.95)
  }
}

shadow <- function(start_position, direction, length, dir, lWidth = 4){
  if (length > 0.01){
    a <- turtleF(start_position, direction, length, "black", lWidth)
    shadow(a, direction + (dir * pi/4), length * 0.38, (-1 * dir), lWidth * 0.95)
    shadow(a, direction, length * 0.87, (-1 * dir), lWidth * 0.95)
  }
}


sun <- function(start_position, direction, length, lWidth, colour = "gold"){ # draws a spiral
  if (length > 0.2){ # sets function to stop once the line being drawn falls bellow 0.2
    a <- turtleF(start_position, direction, length, colour, lWidth)
    sun(a, direction - pi/4, length * 0.95, lWidth, colour) # keeps adding smaller and smaller lines to the first lines, creating a sprial; goes on forever
  }
}


challenge_F <- function(){ # draws pretty little picture using previous functions
  png(file = "../Results/chalF.png")
  par(bg = "deepskyblue1", fg = "deepskyblue1", col.axis = "deepskyblue1")
  plot(-2,-2, xlim = c(0,20), ylim = c(0,20))
  sun(c(6,4), 0.5, 12, 160, "springgreen4") # spiral() edited to draw hills
  sun(c(-5,0), 0.5, 15, 160, "springgreen2")
  sun(c(-2,22), 0.5, 3, 40)# spiral() edited to draw sun
  sun(c(10,23), 0.5, 2, 40, "white")# spiral() edited to draw clouds
  sun(c(13,22), 0.5, 2, 40, "white")
  sun(c(16,23), 0.5, 2, 40, "white")
  fern_2F(c(10,5), pi/2, 2, 1)
  shadow(c(10,5), pi/2 - pi/1.5, 2 * 1.2, 1) # draws tree shadow using edited version of fern_2()
  fern_2F(c(16,11), pi/2, 0.3, 1)
  shadow(c(16,11), pi/2 - pi/1.6, 0.3 * 1.2, 1)
  axis(1, lwd = 2, lwd.ticks = 0, col = "chocolate4", lty = "dotdash") # makes border from axes
  axis(2, lwd = 2, lwd.ticks = 0, col = "chocolate4", lty = "dotdash")
  axis(3, lwd = 2, lwd.ticks = 0, col = "chocolate4", lty = "dotdash")
  axis(4, lwd = 2, lwd.ticks = 0, col = "chocolate4", lty = "dotdash")
  dev.off()
 # larger values of e = more time to draw fern_2; more detail in drawing, more splitting of pattern
}