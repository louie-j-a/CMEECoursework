#!/usr/bin/env python

""" Runs and profiles LV1.py and LV2.py """

__author__ = 'Louie Adams (la2417@ic.ac.uk)'
__version__ = '0.0.1'


import cProfile
import subprocess
def runLV1():
	subprocess.os.system("ipython LV1.py")

def runLV2():
	subprocess.os.system("ipython LV2.py")

cProfile.run("runLV1()")
cProfile.run("runLV2()")
