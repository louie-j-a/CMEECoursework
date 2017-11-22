#!/usr/bin/env python

""" The Lotka-Volterra Model with prey density dependence simulated using scipy """

__author__ = 'Louie Adams (la2417@ic.ac.uk)'
__version__ = '0.0.1'


import sys
import scipy as sc 
import scipy.integrate as integrate
import pylab as p #Contains matplotlib for plotting

# import matplotlip.pylab as p #Some people might need to do this

def dR_dt(pops, t=0):
    """ Returns the growth rate of predator and prey populations at any 
    given time step """
    
    R = pops[0]
    C = pops[1]
    K = 5   # Carrying capacity, K, added to equation
    dRdt = r*R*(1 - (R/K)) - a*R*C 
    dydt = -z*C + e*a*R*C
    
    return sc.array([dRdt, dydt])

# Define parameters:
if len(sys.argv) == 5: # If correct number of arguments entered, take users arguments
	r = float(sys.argv[1]) # Resource growth rate
	a = float(sys.argv[2]) # Consumer search rate (determines consumption rate) 
	z = float(sys.argv[3]) # Consumer mortality rate
	e = float(sys.argv[4]) # Consumer production efficiency
else: # Default arguments if user eters inccorect arguments
	r = 1.3
	a = 0.4
	z = 0.3
	e = 0.2
	
# Now define time -- integrate from 0 to 15, using 1000 points:
t = sc.linspace(0, 30,  1000)

x0 = 10
y0 = 5 
z0 = sc.array([x0, y0]) # initial conditions: 10 prey and 5 predators per unit area

pops, infodict = integrate.odeint(dR_dt, z0, t, full_output=True)

infodict['message']     # >>> 'Integration successful.'

prey, predators = pops.T # What's this for?
f1 = p.figure() #Open empty figure object
p.plot(t, prey, 'g-', label='Resource density') # Plot
p.plot(t, predators  , 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.text(1,8, "r = %s, \na = %s \nz = %s \ne = %s \nK = 5" %(r, a, z, e))
p.xlabel('Time')
p.ylabel('Population')
p.title('Consumer-Resource population dynamics')
p.show()
f1.savefig('../Results/prey_and_predators_2.pdf') #Save figure
