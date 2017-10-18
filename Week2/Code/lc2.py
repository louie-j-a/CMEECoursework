#!/usr/bin/env python

"""Creates a list of months where rainfall in the UK was above 100mm \n
and states the amount of rain for those months. Then creates a list of 
\n months where rainfall was below 50mm. This is done twice, first \n
using list comprehensions, and then using traditional loops"""

___author___ = 'Louie Adams (la2417@ic.ac.uk)'
__version__ = '0.0.1'
__date__ = '18.10.2017'


# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )    # Creates tuple containing the amount of rainfall for each month in 1910 in the UK. Each element in the tuple is itself a tuple

LotsOfRain = [month for month in rainfall if month [1] > 100] 
# Creates a list containing the month and rainfall for months in which rainfall was over 100mm

LowRainMonth = [month [0] for month in rainfall if month[1] < 50]
# Creates a list of months for which which rainfall was under 50mm

LORls = []

for month in rainfall:
	if month[1] > 100:
		LORls.append(month)
		
# Ceates an empty list and then cycles through each tuple in rainfall adding each month (along with its corresponding rainfall data) where rainfall was over 100mm to this list.  
		
		
LRMls = [] 

for month in rainfall:
	if month[1] <50:
		LRMls.append(month[0])
		
# Ceates an empty list and then cycles through each tuple in rainfall adding each month where rainfall was below 50mm to this list.
