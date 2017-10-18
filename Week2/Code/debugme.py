#!/usr/bin/env python

"""Some functions exemplifying debugging in python"""
#docstrings are considered part of the running code (normal comments are 
#stripped). Hence, you can access your docstrings at run time.	
__author__ = 'Samraat Pawar (s.pawar@imperial.ac.uk)'
__version__ = '0.0.1'

def createabug(x):
	y = x**4
	z = 0.
	# can put an if statement here, if something happens then import pdb
	import pdb; pdb.set_trace()
	y = y/z
	return y
	
createabug(25)
