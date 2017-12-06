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
  spiral(a, direction - pi/4, length * 0.95)
  return(c(x,y))
}
