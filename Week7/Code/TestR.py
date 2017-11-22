#!/usr/bin/env python

"""
	Runs a test R file through python using the subprocess module
"""
__author__ = "Louie Adams (la2417@ic.ac.uk)"
__version__ = "0.0.1"
__date__ = "Nov 2017"

import subprocess

subprocess.Popen("/usr/lib/R/bin/Rscript --verbose TestR.R > ../Results/TestR.Rout 2> ../Results/TestR_errorFile.Rout", shell=True).wait()
