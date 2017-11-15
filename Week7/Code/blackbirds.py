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


king = re.findall(r"Kingdom\s\w*", text)
phy = re.findall(r"Phylum\s\w*", text)
sps = re.findall(r"Species\s\w*", text)

#~ print king 
#~ print phy
#~ print sps

Species1 = [king[0], phy[0], sps[0]]
Species2 = [king[1], phy[1], sps[1]]
Species3 = [king[2], phy[2], sps[2]]
Species4 = [king[3], phy[3], sps[3]]
	
print Species1
print Species2
print Species3
print Species4
