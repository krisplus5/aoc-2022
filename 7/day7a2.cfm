<cfscript>
    /*  TASK: we're given console commands that iterate a file directory tree 
              we need to find directories that have total content sizes of <= 100000 
    
        what do we want this to look like on output? 
        ultimately, we want an array of directory pathnames and their sizes 
            [{dirname='/',dirsize='134003'}]
            [{dirname='/bugz',dirsize='5603'}]
            [{dirname='/bugba',dirsize='65403'}]
            [{dirname='/bugba/some',dirsize='567'}]
            [{dirname='/somma',dirsize='134'}]
            [{dirname='/trze',dirsize='14567'}]
            [{dirname='/trze/e34',dirsize='567'}]
    
        for each function call ... 
            * append the parameter DirSizes[] with the current dirsum {string dirname, numeric dirsize}
            * return a sum of filesizes 

        note: * arrays are passed by value; we want to pass by reference 
              * to avoid changing CF behavior at the full application level, we'll contain this array in a struct
              * structs are passed by reference

    INPUT we'll take our command output and make it an array of commands 
    ** we have: 
        * commands that start with $ followed by a spaceband
            * $ cd - changes the directory 
            * $ ls - lists the contents of a directory - SKIP IT 
            * $ cd 'dirname' - goes into a directory - CALL FUNCTION (currdirpath/dirname); returns {dirpath,dirsize}
            * $ cd .. - navigates to the parent of this directory - RETURN FROM CURR DIR AND SKIP IT
        * output of commands that don't start with $ 
            * 123456 filename - this is a file, preceded by its size - ADD THIS TO CURRENT DIRSIZE
            * dir filename - this is a directory and has no size - SKIP IT
          
    */
    depth = 0;
    srcfile = expandPath( "./7a-source.txt" )  // our input file of console commands
    console = []    // this will hold the contents of the srcfile in an array by line
    // this is OUR collection of structs holding dirname/dirsize (contained in a struct, see note above)
    strSizes = {sizes=[]}

    //read in the cli commands we execute to build our tree
    cfloop(file=srcfile, index="line"){
        console.append(line)
    }

    //this is our udf that gets called recursively; don't screw it up
    numeric function getDirSize(array commandArray, string callingDir, struct DirSizes){
        depth ++ //infinite loop protection
        if(depth > 10){exit;}
        // look at the command array, and get our current directory name off the 1st element
        /* special case of $ cd .. in first element (2 in a row) - navigates to the parent of this directory - just return 
        if(left(commandArray[1],7) == "$ cd .."){
            return 0
        }*/
writedump(var="#commandArray#", label="the commands: depth #depth#")
        thisdir = callingDir & "/" & listgetat(commandArray[1],3," ");
        thissum = 0 
        // loop through the commandArray that is being passed in from the NEXT element 
        for(i=2;i<=commandArray.len();i++){
            //NOT a command 
            if(left(commandArray[i],1) != "$"){

                //if its a directory, skip it because we'll cd into it and then deal with it
                if(left(commandArray[i],4) == "dir "){
                    writeoutput(i & " = dir<br />")
                    continue;
                } else {
                    //if its a file, get the filesize and add it to thissum 
                    thissum += listgetat(commandArray[i],1," ");
                }
            // IS a command
            } else {
                writeoutput("current command: row #i#: #commandArray[i]#<br />")
                // $ ls - lists the contents of a directory - SKIP IT 
                if(left(commandArray[i],4) == "$ ls"){ 
                    writeoutput(i & " = $ls<br />");
                    continue;
                }
                //* $ cd .. - navigates to the parent of this directory - break out of loop 
                else if(left(commandArray[i],7) == "$ cd .."){
                    writeoutput("#i# = $cd ..<br />")
                    break; 
                }
                // $ cd - changes the directory goes into a directory
                //CALL FUNCTION (currdirpath/dirname); dirsize & appends to dirsizes
                else if(left(commandArray[i],4) == "$ cd"){
                    thissum += getDirSize(commandArray.slice(i),thisdir,DirSizes);
                    //forward through the commandArray in the containing iteration to the next $ cd .. 
                    do {
                        i += 1;   //advance the array counter
                    } while (commandArray[i] != "$ cd .." and i < commandArray.len())
                    //i += 1;
                }
            }
        }
        writeoutput("depth #depth#: just before appending to DirSizes, i = #i#; dirname=#thisdir#; dirsize=#thissum#<br />")
        DirSizes.sizes.append({"dirname"=thisdir, "dirsize"=thissum}) // update our array of dirs w/ size
        depth --
        return thissum;
    }   //end of udf

    
    writeoutput(getDirSize(console,"root",strSizes))

writedump(var="#strSizes#",label="last dump")

    </cfscript>