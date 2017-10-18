taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 

# ANNOTATE WHAT EVERY BLOCK OR IF NECESSARY, LINE IS DOING! 

# ALSO, PLEASE INCLUDE A DOCSTRING AT THE BEGINNING OF THIS FILE THAT 
# SAYS WHAT THE SCRIPT DOES AND WHO THE AUTHOR IS

# Write your script here:

#!/usr/bin/env python

"""Creates a dictionary from the list of tuples 'taxa', assigning the binomial
name of each species to the correct order"""

___author___ = 'Louie Adams (la2417@ic.ac.uk)'
__version__ = '0.0.1'
__date__ = '18.10.2017'


taxa_dic = {}  # creates an empty dictionary called taxa_dic

for i in taxa: # cycles through each tuple in list 'taxa'
	if i[1] not in taxa_dic: # if the order name (i[1]) is not already in 
                                 # taxa_dic,
		taxa_dic[i[1]] = set() # create set of keys from order names
	taxa_dic[i[1]].add(i[0]) # add corresponding binomial names to the set 
print taxa_dic 



