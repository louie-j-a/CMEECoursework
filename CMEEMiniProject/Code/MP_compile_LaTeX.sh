#!/bin/bash
pdflatex $1.tex
pdflatex $1.tex
bibtex $1
bibtex $1
pdflatex $1.tex
pdflatex $1.tex


## Cleanup
#rm *~
rm *.aux
#rm *.dvi
rm *.log
#rm *.nav
rm *.out
#rm *.snm
rm *.toc
rm *.blg
rm *.bbl
