#!/usr/bin/env python

"""Demonstrate variable scope"""
	
__author__ = 'Samraat Pawar (s.pawar@imperial.ac.uk)'
__version__ = '0.0.1'
__date__ = '18.10.2017'


## Try this first

_a_global = 10

def a_function():
	_a_global = 5
	_a_local = 4
	print "Inside the function, the value is ", _a_global
	print "Inside the function, the value is ", _a_local
	return None

a_function()
print "Outside the function, the value is ", _a_global



## Now try this

_a_global = 10

def a_function():
	global _a_global   ##  This tells the computer that _a_global is actually a global variable
	_a_global = 5
	_a_local = 4
	print "Inside the function, the value is ", _a_global
	print "Inside the function, the value is ", _a_local
	return None
	
a_function()
print "Outside the function, the value is", _a_global
