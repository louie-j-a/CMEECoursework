birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line for each species
# Hints: use the "print" command! You can use list comprehensions!

# ANNOTATE WHAT EVERY BLOCK OR IF NECESSARY, LINE IS DOING! 

# ALSO, PLEASE INCLUDE A DOCSTRING AT THE BEGINNING OF THIS FILE THAT 
# SAYS WHAT THE SCRIPT DOES AND WHO THE AUTHOR IS

#!/usr/bin/env python

"""Prints, on seperate lines, the latin name, common name, and mass for each species in the object 'birds'"""

___author___ = 'Louie Adams (la2417@ic.ac.uk)'
__version__ = '0.0.1'
__date__ = '18.10.2017'

for i in birds: # cycles through each tuple within birds
	print i[0]  # prints the 0th element (latin name) of each tuple
	print i[1]  # prints the 1st element (common name) of each tuple
	print i[2]  # prints the 2nd element (mass) of each tuple
