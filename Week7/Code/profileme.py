#!/usr/bin/env python


def a_useless_function(x) :
	y = 0
	# eight zeros!
	for i in xrange(100000000) :
		y = y + i
	return 0
	
def another_useless_function(x):
	y = 0
	z = 0 # start a counter
	while z <= 100000000: # eight zeros!
		y = y + x
		z += 1
	return 0
	
def a_less_useless_function(x) :
	y = 0
	# five zeros!
	for i in xrange(100000) :
		y = y + i
	return 0
	
def some_function(x) :
	print x
	a_useless_function(x)
	another_useless_function(x)
	a_less_useless_function(x)
	return 0
	
some_function(1000)
