import networkx as nx
import scipy as sc
import matplotlib.pyplot as plt
import csv


l = open("../Data/QMEE_Net_Mat_edges.csv", "rb")

l2 = csv.reader(l)
links = []
for i in l2:
	links.append(tuple(i))
	
l.close

#~ n = open("../Data/QMEE_Net_Mat_nodes.csv", "rb")

#~ n2 = csv.reader(n)
#~ nodes = []
#~ for i in n2:
	#~ nodes.append(tuple(i))
	
#~ n.close


#~ ## Assign body mass range
#~ SizRan = ([-10,10]) #use log scale

#~ ## Assign number of species (MaxN) and connectance (C)
#~ MaxN = 30
#~ C = 0.75

#~ ## Generate adjacency list:
#~ AdjL = sc.array(GenRdmAdjList(MaxN, C))

## Generate species (node) data:
Sps = sc.unique(links) # get species ids
#~ Sizs = sc.random.uniform(SizRan[0],SizRan[1],MaxN)# Generate body sizes (log10 scale)

###### The Plotting #####
plt.close('all')

##Plot using networkx:

## Calculate coordinates for circular configuration:
## (See networkx.layout for inbuilt functions to compute other types of node
# coords)
pos = nx.circular_layout(Sps)

G = nx.Graph()
G.add_nodes_from(Sps)
G.add_edges_from(tuple(links))
#NodSizs= 10**-32 + (Sizs-min(Sizs))/(max(Sizs)-min(Sizs)) #node sizes in proportion to body sizes
nx.draw(G, pos)#, node_size = NodSizs*1000)
plt.show()



#~ #generate adjaceny list
#~ net = sc.array(links)

