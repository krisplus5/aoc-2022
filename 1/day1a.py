import os

maxElfCals = 0    # holding the max cals by elf 
currentCals = 0

#loop over the file line by line
file = os.getcwd() + "/1/1a-source.txt"
f = open(file,"rt")

#process each line of the file
for line in f:
    
    if (line.strip() != ""): #if the line isn't empty, add to calorie count
        currentCals += int(line.strip())
    else:
        if (currentCals > maxElfCals): 
            maxElfCals = currentCals
        currentCals = 0

f.close()

#output the elf ID and cals 
print(maxElfCals)

