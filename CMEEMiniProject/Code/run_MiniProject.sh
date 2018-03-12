#!/bin/bash
# Author: Louie Adams la2417@ic.ac.uk
# Script: run_MiniProject.sh
# Desc: runs miniproject scripts to fit models to data and compile report.
# Arguments: none
# Date: March 2018

printf "\nRunning Louie Adams' MiniProject (la2417@ic.ac.uk)\n\n"
printf "## Cleaning data in R and extracting starting parameter estimate ##\r"
Rscript DataPrep.R > terminalOutput.txt
printf "** Data cleaned in R and  starting parameter estimates extracted **\n\n"

printf "## Fitting Schoolfield models and cubic model to temperature performance data using LMFIT package in Python ##\r"
python -W ignore TPCfitting.py > terminalOutput.txt 
printf "** Schoolfield and cubic model fitted to temperature performance data using LMFIT package in Python ** \n\n"

printf "## Comparing AIC scores in R ##\r"
Rscript Modelselection.R > terminalOutput.txt
printf "** AIC scores compared in R **\n\n"

printf "## Testing effects of latitude on model selection in R ##\r"
Rscript latitudeTest.R > terminalOutput.txt
printf "** Effects of latitude on model selection tested in R **\n\n"

printf "## Producing figures for report in R ##\r"
Rscript GraphsForMethods.R > terminalOutput.txt
printf "** Produced figures for report in R **\n\n"

printf "## Compiling report ##\r"
sh MP_compile_LaTeX.sh la2417miniProject > terminalOutput.txt
mv la2417miniProject.pdf ../Results/la2417miniProject.pdf
printf "** Compiled report **\n\n"
rm terminalOutput.txt
printf "The report has been output as la2417miniProject.pdf in ../Results/\n\n"

exit
