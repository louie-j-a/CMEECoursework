#!/usr/bin/env python

"""
	Searches through "blackbirds.txt" and extracts kingdom, phylum and 
	species names, for each species in the dataset. 
"""
__author__ = "Louie Adams (la2417@ic.ac.uk)"
__version__ = "0.0.1"
__date__ = "Nov 2017"

import re

# Read the file
f = open('../Data/blackbirds.txt', 'r')
text = f.read()
f.close()

# remove \t\n and put a space in:
text = text.replace('\t',' ')
text = text.replace('\n',' ')

# note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform
# to ASCII:
text = text.decode('ascii', 'ignore')

# Now extend this script so that it captures the Kingdom, 
# Phylum and Species name for each species and prints it out to screen neatly.

# Hint: you may want to use re.findall(my_reg, text)...
# Keep in mind that there are multiple ways to skin this cat! 
# Your solution may involve multiple regular expression calls (easier!), or a single one (harder!)


allin1 = re.findall(r"Kingdom\s\w*|Phylum\s\w*|Species\s\w*", text) # Find all
# instances of the string "Kingdom", followed by a word; all instances of the string # "Phlyum", followed by a word; and all instances of the string "Species", followed 
# by a word
print allin1

#~ king = re.findall(r"Kingdom\s\w*", text)
#~ phy = re.findall(r"Phylum\s\w*", text)
#~ sps = re.findall(r"Species\s\w*", text)

#~ print king 
#~ print phy
#~ print sps

#~ Species1 = [king[0], phy[0], sps[0]]
#~ Species2 = [king[1], phy[1], sps[1]]
#~ Species3 = [king[2], phy[2], sps[2]]
#~ Species4 = [king[3], phy[3], sps[3]]
	
#~ print Species1
#~ print Species2
#~ print Species3
#~ print Species4
