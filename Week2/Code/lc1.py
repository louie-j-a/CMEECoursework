#!/usr/bin/env python

"""Creates a list of latin names, a list of common names, and a list \n
of body masses of 5 bird species. This is done two times, first using \n
list comprehensions and then using conventional loops"""

__author__ = 'Louie Adams (la2417@ic.ac.uk)'
__version__ = '0.0.1'
__date__ = '18.10.2017'


birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )    #### creates a tuple called birds. Each element in birds is itself a tuple

#####################
# question 1
#####################



ln = [tup[0] for tup in birds]  #####   cycles through each tuple in birds and creates a list of 0th element of each tuple
cn = [tup[1] for tup in birds]
bm = [tup[2] for tup in birds]



#####################
#question 2
#####################



latin = [] # creates empty list called latin

for i in birds:
	latin.append(i[0]) # cycles through each tuple in birds and appends the 0th element (latin names) of each tuple to latin
	
common = []
	
for i in birds:
	common.append(i[1]) # appends appends the 1st element (common names) of each tuple to common
	
body_mass = []
	
for i in birds:
	body_mass.append(i[2]) # appends the 2nd element (body weight) of each tuple to body_weight
	
	

	
		
