import os

#loop over the file line by line
source = os.getcwd() + "/1/1a-source.txt"
f = open(source,"rt")


for line in f:
    print(line.strip())

f.close()
