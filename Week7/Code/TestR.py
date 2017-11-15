import subprocess

subprocess.Popen("/usr/lib/R/bin/Rscript --verbose TestR.R > ../Results/TestR.Rout 2> ../Results/TestR_errorFile.Rout", shell=True).wait()
