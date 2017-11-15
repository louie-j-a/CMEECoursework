import re

my_string = "a given string"
# find a space in the string
match = re.search(r"\s", my_string)

print match
#prints <_sre.SRE_Match object at 0x7f38846d2780>

#now we can see what has matched
match.group()
# shows spaces (" ") have been matched

match = re.search(r"s\w*", my_string)

#shows "string" has been matched
match.group()

# Now an example of NO MATCH:
# find a digit in the string
match = re.search(r"\d", my_string)

#should print "None"
print match


#further example 
my_string = "an example"
match = re.search(r"\w*\s", my_string) # print any alphanumeric character followed by a space

if match:
	print "found a match:", match.group()
else:
	print "did not find a match"


#Some basic examples

match = re.search(r"\d", "it takes 2 to tango")
print match.group() #prints 2

match = re.search (r"\s\w*\s", "once upon a time")
match.group() # " upon "

match = re.search(r"\s\w{1,3}\s", "once upon a time") # match pattern at least once but not more than three times
match.group() # " a "

match = re.search(r"\s\w*$", "once upon a time")
match.group()

match = re.search(r"\w*\s\d.*\d", "take 2 grams of H2O")
match.group() # "take 2 grams of H20" 

match = re.search(r"^\w*.*\s", "once upon a time")
match.group() # "once upon a "

##Note that *, +, and { } are all greedy:
##they repeat the previous regex token as many times as possible
##as a result, they may match more text than you want

#to make it non-greedy add ?:
match = re.search(r"^\w*.*?\s", "once upon a time")
match.group() # "once "

## To further illustrate greediness, let's try matching an HTML tag:
match = re.search(r'<.+>', 'This is a <EM>first</EM> test')
match.group() # '<EM>first</EM>'

## But we didn't want this: we wanted just <EM>
## It's because + is greedy!
## Instead, we can make + "lazy"!
match = re.search(r'<.+?>', 'This is a <EM>first</EM> test')
match.group() # '<EM>'

## OK, moving on from greed and laziness
match = re.search(r'\d*\.?\d*','1432.75+60.22i') #note "\" before "."
match.group() # '1432.75'
match = re.search(r'\d*\.?\d*','1432+60.22i')
match.group() # '1432'
match = re.search(r'[AGTC]+', 'the sequence ATTCGT')
match.group() # 'ATTCGT'
re.search(r'\s+[A-Z]{1}\w+\s\w+', 'The bird-shit frog''s name is Theloderma asper').←-
group() # ' Theloderma asper'
## NOTE THAT I DIRECTLY RETURNED THE RESULT BY APPENDING .group()
