#!/usr/bin/env python

"""Simple DNA alignment function. Takes input file containing two DNA sequences and finds the best matched alignment of the two"""
	
__author__ = 'Louie Adams (la2417@ic.ac.uk)'
__version__ = '0.0.1'
__date__ = '18.10.2017'


import csv # import csv module

f = open("../Sandbox/afile.csv", "rb") #open file containing two sequences
seqs = list(csv.reader(f)) #store contents of file as a list

seq1 = str(seqs[0]) #store 0th element of list (first line of afile.csv) as a string

## remove any "[", "]", and "'", characters from seq1 as these are not part of the DNA sequence
seq1 = seq1.replace("[", "")
seq1 = seq1.replace("]", "")
seq1 = seq1.replace("'", "")

##repeat above process for second DNA sequence 
seq2 = str(seqs[1])
seq2 = seq2.replace("[", "")
seq2 = seq2.replace("]", "")
seq2 = seq2.replace("'", "")

f.close()

# assign the longest sequence s1, and the shortest to s2
# l1 is the length of the longest, l2 that of the shortest

l1 = len(seq1)
l2 = len(seq2)
if l1 >= l2:
    s1 = seq1
    s2 = seq2
else:
    s1 = seq2
    s2 = seq1
    l1, l2 = l2, l1 # swap the two lengths

# function that computes a score
# by returning the number of matches 
# starting from arbitrary startpoint
def calculate_score(s1, s2, l1, l2, startpoint):
    # startpoint is the point at which we want to start
    matched = "" # contains string for alignement
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            # if its matching the character
            if s1[i + startpoint] == s2[i]:
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # build some formatted output
    print "." * startpoint + matched           
    print "." * startpoint + s2
    print s1
    print score 
    print ""

    return score

calculate_score(s1, s2, l1, l2, 0)
calculate_score(s1, s2, l1, l2, 1)
calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score)
my_best_align = None
my_best_score = -1

for i in range(l1):
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2
        my_best_score = z

print my_best_align
print s1
print "Best score:", my_best_score


best_align = open('../Results/best_align.txt','w') # create new file called best_align.txt

# write best alignment into best_align.txt, then start a new line
best_align.write(my_best_align + '\n')
best_align.write(s1 + '\n') 

best = ("Best score:", my_best_score) # create object containig the best score; next function, .write will only take one argument
best_align.write(str(best) + '\n') #write this object into file; 

best_align.close() # close best_align.txt
