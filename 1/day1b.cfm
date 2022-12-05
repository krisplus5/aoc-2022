<cfscript>

maxElfCals = []    // holding ALL the elf cals to sort later
currentElf = 0
currentCals = 0
srcfile = expandPath( "./1a-source.txt" )
line = ""
top3 = 0

//loop over the file line by line
cfloop(file=srcfile, index="line"){ 
    //increment our current elf counter 
    currentElf += 1
 
    //if the line isn't empty 
    if (trim(line) != ""){
        //for each line, add the number to a running total until you hit an empty line 
        currentCals += trim(line)

    //if the line is empty, store the elfCal in the array 
    } else {
        arrayAppend(maxElfCals, currentCals)
        //reset current cal sum to zero 
        currentCals = 0
    }
}

//now get the top 3 elves by calories 
arraySort(maxElfCals,"numeric","desc")
for(i=1; i <= 3; i++){
    top3 += maxElfCals[i]
}

//output the elf ID and cals 
writeDump(top3)
writeDump(maxElfCals)
</cfscript>
