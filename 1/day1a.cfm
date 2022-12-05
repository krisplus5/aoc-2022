<cfscript>

maxElfCals = {elf=0, cals=0}    // holding the elf with the most cals
currentElf = 0
currentCals = 0
srcfile = expandPath( "./1a-source.txt" )
line = ""

//loop over the file line by line
cfloop(file=srcfile, index="line"){ 
    //increment our current elf counter 
    currentElf += 1
 
    //if the line isn't empty 
    if (trim(line) != ""){
        //for each line, add the number to a running total until you hit an empty line 
        currentCals = currentCals + trim(line)

    //if the line is empty, compare the sum to currently largest sum & elf ID
    } else {
        //if the sum is bigger than the existing maxElfCals cals, then replace the elf and cals with the current
        if(currentCals > maxElfCals.cals){
            maxElfCals.elf = currentElf 
            maxElfCals.cals = currentCals
        }
        //reset current cal sum to zero 
        currentCals = 0
    }
}

//output the elf ID and cals 
writeDump(maxElfCals)

</cfscript>
