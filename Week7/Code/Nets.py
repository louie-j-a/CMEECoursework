#!/usr/bin/env python

"""
	Plots connectivity network 
	Needs: Adjacency matrix of QMEE student interactions between institutions and node labels
"""
__author__ = "Louie Adams (la2417@ic.ac.uk)"
__version__ = "0.0.1"
__date__ = "Nov 2017"

import numpy as np #genfromtxt is within numpy
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
import networkx as nx

# Read in data for adjacency matrix
data = np.genfromtxt("../Data/QMEE_Net_Mat_edges.csv", delimiter = ",")

adj = data[1:,] # Gets rid of NAs whcih correspond to node labels

# Read in node sizes
nodes = np.genfromtxt("../Data/QMEE_Net_Mat_nodes.csv", delimiter =",")

NodeSizes = nodes[1:,2] # Again removes NAs corresponding to node labels

# Node sizes must be read in again, this time in the form of a string,
# so that the names of each node and corresponding institution type
# can be read
nodcol = np.genfromtxt("../Data/QMEE_Net_Mat_nodes.csv", delimiter =",", dtype='str', skip_header=1)

# Creating list of node colours
NodeColours = []
for i in range(len(nodcol)):
	if nodcol[i][1] == "University":
		NodeColours.append("g")
	elif nodcol[i][1] == "Hosting Partner":
		NodeColours.append("b")
	elif nodcol[i][1] == "Non-Hosting Partners":
		NodeColours.append("r")
	else:
		NodeColours.append("w")


# Creating dictionary of node labels; nx.draw(labels={}) requires a dictionary
lbldic = {}
for i in range(len(nodcol)):
	lbldic[i] = nodcol[:,0][i]
	

# Creating edge weights
edges = []
for i in range(len(adj)):
	for k in range(len(adj)):
		edges.append(adj[i][k]) #creates list of all values in the adjacency matrix
		
# Adjacency matrices will always have douplicates for all values, 
# these must be removed from the list before plotting.		
seen = set()
seen_add = seen.add
edges1 = [x for x in edges if not (x in seen or seen_add(x))]
edges1 = [i for i in edges1 if not i == 0] #Removes 0s since they correspond to no edges
edges1 = [i/10 + 1 for i in edges1] # Provides reasonable scale for weighting of edges


# Plot network

plt.close('all') # close all current plots



rows, cols = np.where(adj > 1)
edges = zip(rows.tolist(), cols.tolist())
gr = nx.Graph()
gr.add_edges_from(edges)

nx.draw(gr, node_size = 100*NodeSizes, node_color = NodeColours, labels = lbldic, with_labels=True, width = edges1)


# Creating legend
line1 = mlines.Line2D(range(1), range(1), color="white", marker='o', markersize=15, markerfacecolor="green")
line2 = mlines.Line2D(range(1), range(1), color="white", marker='o', markersize=15,markerfacecolor="blue")
line3 = mlines.Line2D(range(1), range(1), color="white", marker='o', markersize=15, markerfacecolor="red")

plt.legend((line1,line2,line3),('University','Hosting Partner', 'Non-Hosting Partner'),numpoints=1, loc=1)
 

plt.savefig("../Results/Nets.svg",format="svg")
plt.show()
