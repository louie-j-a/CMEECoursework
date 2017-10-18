#!/usr/bin/env python

"""Some functions exemplifying control statements"""
__author__ = 'Louie Adams (la2417@ic.ac.uk), copied from CMEE Coursebook 2017'
__date__ = '10.10.2017'


#1)
for i in range(3, 17):
	print 'hello'

#2)
for j in range(12):
	if j % 3 == 0:
		print 'hello'

#3)
for j in range(15):
	if j % 5 == 3:
		print 'hello'
	elif j % 4 == 3:
		print 'hello'
		
#4)
z = 0 
while z != 15:
	print 'hello'
	z = z + 3
	
#5) 
z = 12
while z < 100:
	if z == 31:
		for k in range(7):
			print 'hello'
	elif z == 18:
		print 'hello'
	z = z + 1
	
import sys

def foo1(x):
"""square root of x"""
	return x ** 0.5 # x to the power of 1/2
	
def foo2(x, y):
"""State which argument is larger"""
	if x > y: 
		return x #if x is bigger than y, return x
	return y #if not then return y
	
def foo3(x, y, z): 
"""re-orders 3 arguments (not always in ascending order)"""	
	#if x is bigger than y, switch their positions
	if x > y:
		tmp = y
		y = x
		x = tmp
	#if y is bigger than z, switch their positions	
	if y > z:
		tmp = z
		z = y
		y = tmp
	return [x, y, z]
	
def foo4(x):
"""find factorial of x"""
	result = 1
	for i in range(1, x + 1):
		result = result * i # result equals the product of all integers from 1 to i
	return result
	
# This is a recursive function, meaning that the function calls itself
# read about it at 
# en.wikipedia.org/wiki/Recursion_(computer_science)
def foo5(x):
"""find factorial of x using recursion"""
	if x == 1:
		return 1
	return x * foo5(x - 1) # iterates through x * x-1 until x-1 = 1 
	
foo5(10)

def main(argv):
	print foo1(22)
	print foo2(33, 22)
	print foo3(15, 2, 1)
	print foo4(12)
	print foo5(6)
	return 0
	
if (__name__ == "__main__"):
	status = main(sys.argv)
	sys.exit(status)
	

	
