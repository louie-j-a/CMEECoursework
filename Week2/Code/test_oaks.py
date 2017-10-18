#!/usr/bin/env python

"""Finds any oak species within the file 'TestOakData.csv' and writes them to a new file 'JustOaksData.csv'. Doctests included to hep with debugging"""

___author___ = 'Louie Adams (la2417@ic.ac.uk)'
__version__ = '0.0.1'
__date__ = '18.10.2017'


import csv
import sys
import pdb
import doctest

#Define function
def is_an_oak(name):
    """ Returns True if name is starts with 'quercus'
        >>> is_an_oak('quercus')
        True
        
        >>> is_an_oak('Fagus sylvatica')
        False
        
        >>> is_an_oak('quercuss')
        False
    """
    return name.lower() == 'quercus'
    
print(is_an_oak.__doc__)

def main(argv): 
    f = open('../Data/TestOaksData.csv','rb')
    g = open('../Data/JustOaksData.csv','wb')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    oaks = set()
    for row in taxa:
        print row
        print "The genus is", row[0]
        if is_an_oak(row[0]):
            print row[0]
            print 'FOUND AN OAK!'
            print " "
            csvwrite.writerow([row[0], row[1]])    
    
    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)

doctest.testmod()
