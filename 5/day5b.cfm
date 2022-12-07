<cfscript>
    srcfile = expandPath( "./5a-source.txt" )
    prefacefile = expandPath( "./5b-source.txt" )
    stacks = []
    instructions = []
    tmpStr = ""
    holdingStruct = {}
    topCrates = ""
    newstacks = []
    tmpArr = []

    //read in the instructions 
    cfloop(file=srcfile, index="line"){
        /*  get rid of 'move, from, to'
            create the struct as a numiteration, src, dest relatively 
        */
        tmpStr = replaceNoCase(line,"move ", "")
        tmpStr = replaceNoCase(tmpStr, "from ", "")
        tmpStr = replaceNoCase(tmpStr, "to" , "")
    
        holdingStruct = {"num"=listGetAt(tmpStr,1,' '),"from"=listGetAt(tmpStr,2,' '),"to"=listGetAt(tmpStr,3,' ')}
        instructions.push(holdingStruct)
    }
    
    //read the preface to get the stacks of crates 
    //just get the file input first and put it in arrays to transpose
    cfloop(file=prefacefile, index="line"){
        /*  split the line into stacks against a space-band 
            then push subsequent lines */
            stacks.push(line.split(" "))
    }
    //setup the arrays for transposition
    newstacks = []
    for(i=1;i<=arraylen(stacks[1]);i++){
        newstacks.push([])
    }
    //now transpose the arrays 
    for(i=1;i<=arraylen(stacks[1]);i++){   //looping 1-9
        for(j=1;j<=arraylen(stacks);j++){   //looping 1-8
            if(stacks[j][i] != "[-]"){
                arrayprepend(newstacks[i],reReplaceNoCase(stacks[j][i], "[^a-zA-Z]", "", "ALL"))
            }
        }
    }
    writedump(newstacks)
    
    //do the stack moves 
    for(i=1; i<=arraylen(instructions); i++){
        //move crates in a group per the instructions

        //quick reference for the instruction set 
        arFrom = instructions[i].from
        arTo = instructions[i].to
        arNum = instructions[i].num

        //add them to the To array 
        tmpArr = newstacks[arFrom].slice(newstacks[arFrom].len()-arNum+1,arNum)
        newstacks[arTo].addAll(tmpArr)
        //remove those items from the From array
        for(j=1;j<=arNum;j++){newstacks[arFrom].pop()}
    }
    
    writedump(newstacks)
    
    </cfscript>
    