.
├── Code
│   ├── DataPrep.R - clean data and extract starting parameter estimates
│   ├── graphsForIntro.R - build graphs using ggplot for intro/methods section
│   ├── la2417miniProject.bib - bibtex bibliography for latex write up
│   ├── la2417miniProject.tex - latex script for write up
│   ├── latitudeTest.R - test for effectts of latitude on model selection
│   ├── Modelselection.R - compare AIC scores output by TPCfitting.py
│   ├── MP_compile_LaTeX.sh - compiles latex script
│   ├── run_MiniProject.sh - shell script to run entire miniproject
│   └── TPCfitting.py - fits models using lmfit and numpy.polyfit
├── Data
│   ├── fittedData.csv - output by TPCfitting.py
│   ├── GrowthRespPhotoData_new.csv - original data file
│   └── TPCdata.csv - output by Datarep.R
├── README.txt
└── Results
    ├── cubicGraphs.pdf - graph for write up
    ├── logTPCcurve.pdf - graph for write up
    ├── latitudeBxPlt.pdf - graph for write up
    ├── latitudeBxPlt2.pdf - graph for write up
    ├── README.txt
    ├── schoolfieldGraphs.pdf - graph for write up 
    └── TPCcurve.pdf - graph for write up




Packages used for CMEE MiniProject;

R version 3.2.3 (2015-12-10) was used for this project.

The R package, ggplot2 was used for plotting graphs


Python 2.7.12 (default, Nov 20 2017, 18:23:56) was used for this project.

The following Python packages were used;

pandas was used for its data structures and functions for manipulating data structures

numpy was used for matematical functions

scipy.constants was used for scientific constants (Boltzmann constant)

lmfit was used for fitting all models

warnings was used to supress warnings in terminal when runing workflow
