#!/usr/bin/env python

"""Demonstrate use of __name__ = __main__"""
	
__author__ = 'Samraat Pawar (s.pawar@imperial.ac.uk)'
__version__ = '0.0.1'
__date__ = '18.10.2017'


#!/usr/bin/python
# Filename: using_name.py
if __name__ == '__main__':
print 'This program is being run by itself'
else:
print 'I am being imported from another module'
