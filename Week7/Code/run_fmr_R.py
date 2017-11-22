#!/usr/bin/env python

"""
	Runs the file "fmr.R" in R, through python, using the subprocess
	module. Tells user of run was successful and prints the R error
	message if there was an error.
"""
__author__ = "Louie Adams (la2417@ic.ac.uk)"
__version__ = "0.0.1"
__date__ = "Nov 2017"

import subprocess

ReadR = subprocess.Popen("/usr/lib/R/bin/Rscript --verbose fmr.R > \
../Results/fmr.Rout 2> ../Results/fmr_errFile.Rout",\
shell = True).wait() # runs fmf.R, creates fmr.Rout and error file

if ReadR == 0:
	print "Run was successful"
	subprocess.os.system("cat ../Results/fmr.Rout") #prints to fmr.Rout 
	
if ReadR != 0:
	subprocess.os.system("cat ../Results/fmr_errFile.Rout")#prints to error file
	

