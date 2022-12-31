<cfscript>

/* 
    * we're calculating cycle values 
    * each addx is 2 cycles
    * values don't sum in until 2 cycles later
    * we start with the value 1 as the first cycle - not included in the source file 
    * noop are ignored - they don't do anything and DO count as cycles 
*/
    
//our cycle instructions
srcfile = expandPath( "./10a-source.txt" )

currcycle = 1 //the cycle val we're evaluating
currval = 1 //our current value: initialized with 1
cycles = [] // the instruction values in order - no noops
values = [] // the value per cycle 

cfloop(file=srcfile, index="line"){
    cycles.append(listlast(line," "));
}

/* loop through our instructions: 
 * save values for each cycle. 
 * remember, each instruction is 2 cycles. */
values.append(currval); // initialize values with the first cycle of 1
for (i in cycles) {
    if(i == "noop"){
        values.append(currval); //append for every cycle
        currcycle++;
    }else{
        for(j=1;j<=2;j++){  // each instruction is 2 cycles
            values.append(currval); //append for every cycle
            currcycle++;
            //takes 2 cycles to update value
            if(j == 2){
                currval += i;
            }
        }
    }
}

writedump(var=cycles,label="cycle instructs");
writedump(var=values,label="cycle values");

// now get the signal strength of the 20, 60, 100, 140, 180, 200, 220 elements - this is value * element 
currval = 0;
for(i=20;i<=220;i+=40){
    currval += (values[i+1] * i);
    writeoutput("#i# = #values[i+1]# || value = #i*values[i+1]#<br />");
}
writeoutput(currval & "<br />");

</cfscript>
