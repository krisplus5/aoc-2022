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
    
        loop through the file until you hit cd .. 
            if you hit a "cd "
                push the curr directory name and size onto the array,
                clear the running size
                if "cd <directoryname>", then 
                    append new directoryname onto the directoryname list 
                if "cd .. 
                    pop the currdirectory name "/dirname" off the directoryname list 
            if you hit a number, its a file - go ahead and append to the running size
            if you hit anything else, just continue
    
        note that the structure of lines is a list with a space delimeter 
        * sometimes the first delimeter is a "$" 
            $ cd .. 
            $ cd <dirname>
            $ ls 
        * could also be 
            dir <dirname>
            <number> <filename>
            
        there is a pattern that may be useful 
            * $ cd <dirname> is always followed by $ ls 
            * $ ls is always followed by <number> or <dir>
            * $ cd .. is always followed by another $ cd (can be .. or <dirname>)
            * once you hit $ cd (whatever), you are done calculating the filesizes for the current directory
    */

    srcfile = expandPath( "./7a-source.txt" )  // our input file of console commands
    arSizes = [] // array that holds our directory sizes
    intDirSum = 0 // holds running directory size - including subdirectories
    lstCurrDir = "root" // hold the current directory pathname, delimited by "/"
    lstCommand = "" // command string list delimited by " "
    cmdDir = "" // convenience variable for holding the directory being changed to 
    prevCommand = "" //keeps track of the last command to skip appending to array if cd ..

    //loop through the file until you hit cd .. 
    cfloop(file=srcfile, index="lstCommand"){

        //if you hit a "cd "
        if(listGetAt(lstCommand,2," ") == "cd"){
//writeoutput("lstCurrDir=#lstCurrDir# || cmdDir=#cmdDir# || intDirSum=#intDirSum#<br />")
//writedump(arSizes)
            cmdDir = listGetAt(lstCommand,3," ");
            //append dirsize struct to the array before changing the currDir for the new directory
            // update file sizes for this dir to the array (special case)
            if(prevCommand != "$ cd .."){
                ArrayAppend(arSizes,{"dirname"=lstCurrDir,"dirsize"=intDirSum});
            }
            
            //handle $ cd <dirname>
            if(cmdDir != ".."){ 
                //append to directory path and clear the running file sum
                lstCurrDir = listAppend(lstCurrDir,cmdDir,"/");
                intDirSum = 0;
                //handle $ cd ..
            }else{
                //pop the currdirectory name off the directoryname list 
                lstCurrDir = listDeleteAt(lstCurrDir,listLen(lstCurrDir,"/"),"/");
            }

        } // not a directory, so take a look
        //if you hit a number, its a file - go ahead and append to the running size
        else if(isnumeric(listGetAt(lstCommand,1," "))){
                intDirSum += listGetAt(lstCommand,1," ");
        }
        //keep track of the last command, because we need to handle multiple cd .. in a row
        prevCommand = lstCommand;
        //if you hit anything else, just continue 
    }
    //final add to the size array 
    //push the last directory name and size onto the array,
    
    if(prevCommand != "$ cd .."){
        ArrayAppend(arSizes,{"dirname"=lstCurrDir,"dirsize"=intDirSum});
    }

writedump(var="#arSizes#")

//what we really need to do is loop through the array, make a tree, iterate the tree, and tally ttoals? 
arTotalDirs = []
for(i=1;i<=arSizes.len();i++){
    arrayAppend(arTotalDirs,arSizes[i]);
    //hold the first directorypath 
    thepath = arSizes[i].dirname;
    //look at the array from here and see if following directories are children
    for(j=i+1;j<=arSizes.len();j++){
        if(find(thepath,arSizes[j].dirname) == 1){
            arTotalDirs[i].dirsize += arSizes[j].dirsize;
        }else{
            break;
        }
    }
}
writedump(var="#arTotalDirs#",label="arTotalDirs")

//what does it look like if we just remove the big directories?
arSmallDirs = [] 
for(i=1;i<=arTotalDirs.len();i++){
    if(arTotalDirs[i].dirsize <= 100000){
        arrayAppend(arSmallDirs,arTotalDirs[i])
    }
}
ourTotal = 0;
writedump(var="#arSmallDirs#", label="arSmallDirs")
for(i=1;i<=arSmallDirs.len();i++){
    ourTotal += arSmalLDirs[i].dirsize;
}
writedump(ourTotal)
</cfscript>