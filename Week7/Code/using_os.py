#!/usr/bin/env python

"""
	Searches through home directory for various files and directories.
	Demonstrates the use of the subprocess.os module.
"""
__author__ = "Louie Adams (la2417@ic.ac.uk)"
__version__ = "0.0.1"
__date__ = "Nov 2017"


# Use the subprocess.os module to get a list of files and  directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess

#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:

# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

# Create a list to store the results.
FilesDirsStartingWithC = []

# Use a for loop to walk through the home directory.
for (dir, subdirs, files) in subprocess.os.walk(home):
	for subdir in subdirs:
		if subdir.startswith("C"):
			FilesDirsStartingWithC.append(subprocess.os.path.join(dir, subdir))
	for file in files:
		if file.startswith("C"):
			FilesDirsStartingWithC.append(subprocess.os.path.join(dir, file))


print ""
print "List of files and directories starting with C or c: [" + FilesDirsStartingWithC[0] + ","  + FilesDirsStartingWithC[1] + ", " + FilesDirsStartingWithC[2] + ", ... (" + str(len(FilesDirsStartingWithC) - 3) + " more items in list) ]"
  
#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:
FilesDirsStartingWithCorc = []

for (dir, subdirs, files) in subprocess.os.walk(home):
	for subdir in subdirs:
		if subdir.startswith(("C", "c")):
			FilesDirsStartingWithCorc.append(subprocess.os.path.join(dir, subdir))
	for file in files:
		if file.startswith(("C", "c")):
			FilesDirsStartingWithCorc.append(subprocess.os.path.join(dir, file))


print ""
print "List of files and directories starting with C or c: [" + FilesDirsStartingWithCorc[0] + ","  + FilesDirsStartingWithCorc[1] + ", " + FilesDirsStartingWithCorc[2] + ", ... (" + str(len(FilesDirsStartingWithCorc) - 3) + " more items in list) ]"

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:
DirsStartingWithC = []

for (dir, subdirs, files) in subprocess.os.walk(home):
	for subdir in subdirs:
		if subdir.startswith("C"):
			DirsStartingWithC.append(subprocess.os.path.join(dir, subdir))
			
print ""
print "List of directories starting with C: [" + DirsStartingWithC[0] + ","  + DirsStartingWithC[1] + ", " + DirsStartingWithC[2] + ", ... (" + str(len(DirsStartingWithC) - 3) + " more items in list) ]"
