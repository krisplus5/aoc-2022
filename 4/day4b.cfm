<cfscript>
    srcfile = expandPath( "./4a-source.txt" )
    containsCount = 0
    assignments = []
    temp1 = []
    temp2 = []
    str1 = {}
    str2 = {}

 //get the assignments into our array
    cfloop(file=srcfile,index="line"){
        temp1 = line.split(",")
        temp2 = temp1[1].split("-")
        str1 = {"low"=temp2[1],"high"=temp2[2]}
        temp2 = temp1[2].split("-")
        str2 = {"low"=temp2[1],"high"=temp2[2]}
        assignments.append([str1,str2])
     } 

//writedump(assignments)
/* if the 1st el.low OR .high is BETWEEN 2nd el.low and .high - this qualifies 
     elseif the opposite (1st contains the 2nd .low or .high) - this also qualifies */
//loop through assignments (this is each pair)
for (element in assignments) {
    if((element[1].low >= element[2].low and element[1].low <= element[2].high) 
        or (element[1].high >= element[2].low and element[1].high <= element[2].high)){ 
        containsCount++
    }else if(element[2].low >= element[1].low and element[2].low <= element[1].high 
    or element[2].high >= element[1].low and element[2].high <= element[1].high){ 
        containsCount++
    }
}

writeOutput(containsCount)

</cfscript>