#!/bin/bash
# Author: Louie Adams la2417@imperial.ac.uk
# Script: csvtospace.sh
# Desc: substitute the commas in the files with space
# saves the output into a space separated values file
# Arguments: 1-> comma delimited file
# Date: Oct 2015

echo "Creating a space delimted version of $1 ..."

cat $1 | tr -s "," " " >> $1.txt

echo "Done!"

exit 
