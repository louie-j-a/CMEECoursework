#!/bin/bash
# Author: Louie Adams la2417@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: Concatenates two files
# Date: Oct 2015

cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3

exit 
