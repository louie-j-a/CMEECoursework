#!/usr/bin/env Rscript
#Author: Louie Adams la2417@ic.ac.uk
#Date: 11.2017
#Version: 0.0.1 


rm(list = ls())
graphics.off()

community <- c()

species_richness <- function(community){
  sr <- length(unique(community))
  return(sr)
}


initialise_max <- function(size){
  MaxSp <- seq(1, size)
  return(MaxSp)
}


initialise_min <- function(size){
  MinSp <- c()
  for (i in 1:size){
    MinSp[i] <- 1
  }
  return(MinSp)
}


choose_two <- function(x){
  C2 <- sample(c(1:x), 2, replace = F)
  return(C2)
}


neutral_step <- function(community){
  index <- choose_two(length(community))
  community <- replace(community, index[1], community[index[2]])
  return(community)
}


neutral_generation <- function(community){
  for (i in 1:ceiling((length(community)/2))){
   community <- neutral_step(community)
  }
  return(community)
}

########################################################
####### ~~~ CHECK THIS CHANGED WITH DUNCS ~~~ ##########
########################################################
neutral_time_series <- function(initial, duration){     ##
  TimeSeries <- c(species_richness(initial))             ##
  for (i in 1:duration){                                  ##
    initial <- neutral_generation(initial) #added this     #######################
    TimeSeries[i+1] <- species_richness(initial) #took away neutral_generation ###
  }                                                        #######################
  return(TimeSeries)                                      ##
}                                                        ##
#########################################################
#########################################################
#########################################################



# question 8
# max diversity, 100 individuals, 200 generations
question_8 <- function(){
  plot(neutral_time_series(initial = initialise_max(100), 200),
       type = "l",
       xlab = "Generations",
       ylab = "Species Richness",
       main = "Neutral Model Simulation")
}

#Q9
neutral_step_speciation <- function(community, v){
  index <- choose_two(length(community))
  if ((runif(1, 0, 1)<=v)){
  step2 <- replace(community, index[1], (max(community)+1))
  }
  else{
  step2 <- replace(community, index[1], community[index[2]])
  }
  return(step2)
}  


#Q10
neutral_generation_speciation <- function(community, v){
  for (i in 1:ceiling((length(community)/2))){
    community <- neutral_step_speciation(community, v)
  }
  return(community)
}


#Q11
#################################################################################################
########### ~ ~ ~ CHECK THIS ONE MAKES SENSE COS WAS TIRED WHEN WRITING IT ~ ~ ~  ###############
#################################################################################################
neutral_time_series_speciation <- function(community, v, duration){
  TimeSeries <- c(species_richness(community))
  for (i in 1:duration){
    community <- neutral_generation_speciation(community, v) # have to update community for next line of code
    TimeSeries[i+1] <- species_richness(neutral_generation_speciation(community, v))
  }
  return(TimeSeries)
}


#Q12
question_12 <- function(){
  plot(neutral_time_series_speciation(community = initialise_max(100), 0.1, 200),
       type = "l",
       col = "blue",
       xlab = "Generations",
       ylab = "Species Richness",
       main = "Neutral Model Simulation With Speciation",
       ylim = c(0,100))
  lines(neutral_time_series_speciation(community = initialise_min(100), 0.1, 200),
        col = "red")
}


#Q13
species_abundance <- function(community){
  SpAbVec <- as.vector(sort(table(community), decreasing = T))
  return(SpAbVec)
}


#Q14
octaves <- function(SpeciesAbundance){
  oct <- tabulate(log2(SpeciesAbundance)+1)
  return(oct)
}


#Q15
sum_vect <- function(x, y){
  if (length(x)<length(y)){
    x <- append(x, rep(0, (length(y)-length(x))), after = length(x))
  }
  if (length(y)<length(x)){
    y <- append(y, rep(0, (length(x)-length(y))), after = length(y))
  }
  z <- x + y
  return(z)
}


#Q16
question_16 <- function(){
  comm <- initialise_max(100)
  for (i in 1:200){
    comm <- neutral_generation_speciation(community = comm, v = 0.1)
  }
  oct <- octaves(species_abundance(comm))
  for (i in 1:2000){
    comm <- neutral_generation_speciation(comm, 0.1)
    if (i %% 20 == 0){
      oct <- sum_vect(oct, octaves(species_abundance(comm)))
    }
  }
    oct <- oct/101
    barplot(oct, names.arg = c(1,2,4,8,16,32))
}


#Q17
#default values provided to test function
# speciation_rate <- 0.1
# size <- 100
# wall_time <- 0.1
# interval_rich <- 20
# interval_oct <- 20
# burn_in_generations <- 200

cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name){
  comm <- initialise_min(size)
  i <- 1
  SpRichBurn <- c()
  oct <- list()
  ptm <- proc.time()
  while ((proc.time()[3] - ptm[3]) <= (60*wall_time)){
    comm <- neutral_generation_speciation(comm, speciation_rate)
    if (i %in% seq(0,burn_in_generations,interval_rich)){
        SpRichBurn[i/interval_rich] <- species_richness(comm)
      }
    if (i %% interval_oct == 0){
      oct[i/interval_oct] <- list(octaves(species_abundance(comm))) 
    }
     i = i + 1
  }
  time <- proc.time()[3] - ptm[3]
  save(SpRichBurn, oct, comm, time, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, file = output_file_name)
}


#Q18

iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# iter <- 1  #this is for testing locally only
 
if (iter %in% seq(1, 100, 4)){
  J <- 500
} else if (iter %in% seq(2, 100, 4)){
  J <- 1000
} else if (iter %in% seq(3, 100, 4)){
  J <- 2500
} else if (iter %in% seq(4, 100, 4)){
  J <- 5000
}
  
my_sp_rate <- 0.003369
#output_file_name <- paste0("neutral_sim_", iter, ".rda")
file_name <- paste0("neutral_sim_", iter, ".rda")
#time <- (11.5*60)

set.seed(iter)  
cluster_run(my_sp_rate, J, wall_time = (11.5*60), 1, (J/10), (J*8), file_name)

#Q20

files <- list.files(pattern = "neutral_sim*")

oct500 <- list()
oct1000 <- list()
oct2500 <- list()
oct5000 <- list()

oct500length <- c(0)
oct1000length <- c(0)
oct2500length <- c(0)
oct5000length <- c(0)


for(i in 1:length(files)){
  load(files[i])
  if (size == 500){
    oct500 <- c(oct500, oct[81:length(oct)])
    oct500length <- (oct500length + (length(oct)-80))
  }
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
}
PlotOct500 <- PlotOct500/oct500length

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


par(mfrow = c(2,2))
barplot(PlotOct500)
barplot(PlotOct1000)
barplot(PlotOct2500)
barplot(PlotOct5000)


###################################################################################
###############                  fractals                   #######################
###################################################################################


#Q18
log(8)/log(3)

log(20)/log(3)

#Q19


chaos_game <- function(){
  
  a <- c(0,0)
  b <- c(3,4)
  c <- c(4,1)
  
  X <- a
  x <- c()
  y <- c()
  
  plot(X[1],X[2], cex = 0.01, xlim = c(0,5), ylim = c(0,5))

  for (i in 1:10000){
    points <- unlist(sample(list(a, b, c), 1))
    x <- (points[1] + X[1])/2
    y <- (points[2] + X[2])/2 
    lines(c(X[1], x[1]), c(X[2], y[1]), type = "p", cex = 0.01)
    X <- c(x[1], y[1])
  }
}


#Q20

qp <- function() { plot(0,0, xlim = c(0,20), ylim = c(0,20))}


turtle <- function(start_position, direction, length){
  x <- (length * cos(direction)) + start_position[1]
  y <- (((length + start_position[2])**2)+(x**2))**0.5
  lines(c(start_position[1], x), c(start_position[2], y), type = "l")
  return(c(x,y))
}


#Q21

elbow <- function(start_position, direction, length){
  a <- turtle(start_position, direction, length)
  turtle(a, direction - pi/4, length * 0.95)
}


#Q22

spiral <- function(start_position, direction, length){
  a <- turtle(start_position, direction, length)
  i <- 1
  while (length * 0.95 * i >1.8){
  spiral(a, direction - (pi/(4*i)), length * 0.95*i)
  i <- i +1
  }
}
