import sys
#print int(sys.argv[1]) + int(sys.argv[2])
from tmp import myfunc
print 'this is sysargv'
print __name__
print "This is the name of the script: ", sys.argv[0]
print "Number of arguments: ", len(sys.argv)
print "The arguments are: " , str(sys.argv)
