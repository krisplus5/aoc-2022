<cfscript>
    srcfile = expandPath( "./4b-source.txt" )
    containsCount = 0
    assignments = []
    temp1 = []
    temp2 = []
    temp3 = []

    assignments = [
    [{"low"=71,"high"=97},{"low"=71,"high"=72}],
    [{"low"=60,"high"=97},{"low"=20,"high"=95}],
    [{"low"=20,"high"=59},{"low"=58,"high"=59}],
    [{"low"=24,"high"=83},{"low"=3,"high"=82}],
    [{"low"=48,"high"=96},{"low"=33,"high"=47}]
]

writedump(assignments)

//writeoutput(assignments[1]."high")
/*if the 1st el.low is <= 2nd el.low and 1st el.high >= 2nd el.high - this qualifies 
    elseif the opposite - this also qualifies */

//loop through assignments (this is each pair)
for (element in assignments) {
    if(element[1].low <= element[2].low and element[1].high >= element[2].high){ 
        containsCount++
    }else if(element[2].low <= element[1].low and element[2].high >= element[1].high){ 
        containsCount++
    }
}
//writeoutput(assignments[1][1].low)
writeOutput(containsCount)

//get the assignments into our array
 /*   cfloop(file=srcfile,index="line"){
        temp1 = line.split(",")
        temp2 = temp1[1].split("-")
        temp3 = temp1[2].split("-")
        temp1 = {"low"=temp2[1],"high"=temp2[2]}
        temp2 = {"low"=temp3[1],"high"=temp3[2]}
        temp3 = [temp1,temp2]
        assignments.append[temp2å]
  
    } 
*/

</cfscript>