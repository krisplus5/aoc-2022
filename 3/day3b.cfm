<cfscript>
    /* 
    we want a map of the letter scores so that we can quickly reference the value for a given item type
    because coldfusion is case-insensitive (for structkeys, and well, almost everything) we'll have to test for uppercase and add 26 to the result
    a-z = 1-26 
    A-Z = 27-52
    */
    values = {"a"=1,"b"=2,"c"=3,"d"=4,"e"=5,"f"=6,"g"=7,"h"=8,"i"=9,"j"=10,"k"=11,"l"=12,"m"=13,"n"=14,"o"=15,"p"=16,"q"=17,"r"=18,"s"=19,"t"=20,"u"=21,"v"=22,"w"=23,"x"=24,"y"=25,"z"=26}
    priorityValueTotal = 0
    priority = ""
    line = ""
    srcfile = expandPath( "./3a-source.txt" ) 
    srcarray = []
    temparray = []

    //make a 2D array: file x lines    
    cfloop(file=srcfile,index="line"){
        line.each(function(inp){arrayappend(temparray,inp)})
        arrayappend(srcarray,temparray)
        temparray = []
    }

    //writedump(srcarray)
    //now loop through our groups - every 3 array elements
    for(i=1; i<arraylen(srcarray); i=i+3){
        /*  loop through first array checking other 2 for each char; 
        when you find the char in both of the others, break out and get the priority value  */
        //using a for loop here instead of each so that we can break out of the loop 
        for(j=1; j<=arraylen(srcarray[i]); j++){
            if(srcarray[i+1].contains(srcarray[i][j]) and srcarray[i+2].contains(srcarray[i][j])){
                //calculate the value of the badget ID priority
                priority = srcarray[i][j]
                //find the value of the item type and add it to our running total     
                priorityValueTotal += values[priority]
                //if the mistake is actually an uppercase letter, we need to add 26 to the value (stupid caseinsensitivity)
                if(asc(priority) == asc(ucase(priority))){
                    priorityValueTotal += 26 
                }
                break;
            }
        }
    }
    
    writeoutput(priorityValueTotal)
    </cfscript>
    