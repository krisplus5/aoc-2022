<cfscript>
/*  TASK: we're given console commands that iterate a file directory tree 
          we need to find directories that have total content sizes of <= 100000 

    APPROACH: build a tree (Maybe in a struct(?))
        then iterate through the tree 
        note that directories containing directories w/ files will be counted twice !!!

    ALTERNATIVELY: we could literally build the filesystem on disk, name the files with the size in the name and brute-force it
        that is kind of cheating though 
    
*/
/** generally looking for an 'ls' command. 
    But we need the line before it to know where we are.
    Sometimes there are more than 1 'cd' command prior to the 'ls' command 
    A recursive function is probably the nices thing to use here, but icky
** in general, we have: 
    * $cd / (root) : return to our outermost filetree{} 
    * $cd 'dir' : create a new struct called 'dir', and navigate into it 
    * $cd '..', : navigate to our current struct's parent struct
    * $ls : create nodes in the current struct for each item until the next command - and this is recursive 

** our function should 
   * for anything that isn't a command (doesn't start with a $)
       - for a file, create a text node with numeric size in current struct
       - for a directory, create a struct node with name in current struct 
       - for a command: 
   * for anything that is a command 
   *   - $ cd 'name' goes into that struct and calls function again the the current array index
   *   - $ cd '..' (or the end of the file) ends current function recursive call (while....)
   *   - $ ls continues to next 
**/
/* 
    what do we want this to look like on output? 
    we've got input of an array: 
        [cd /]
        [ls]
        [cd dir]
        [num file]
        [some other command]
    
    we've want a structure (because everything is different) for output to iterate later 
        {dirname, totalsize inclusive
            [filename, size]
            [filename, size]
            {dirname, totalsize inclusive 
                [filename, size]
                {dirname, totalsize inclusive
                    [filename, size]
                    [filename, size]
                }
                [filename, size]
                [filename, size]
                [filename, size]
            }
        }
*/

/* we need the directories and their inclusive content size - this includes other subdirectories
        so, write a node for the directory, and return a sum of filesize 
        when you hit a directory, call the function again; always return the contents filesize
*/

/* we will need to pass the console commands from a '$ ls' to the next '$ cd' into the function 
    - Q: is this just passing in the current iteration id of the file-array? 
         We let it continue to iterate until it gets to another $ command? 
         ($cd .. which ends the function or $cd <dir> which calls the function again)
*/

srcfile = expandPath( "./7a2-source.txt" )
console = []    // this will hold the contents of the srcfile in an array by line
DirSizes = []

//read in the cli commands we execute to build our tree
cfloop(file=srcfile, index="line"){
    console.append(line)
}

/* our recursive function to get inclusive directory sizes
    * pass in the commandList as an array, and the current node index (the cd call); start from the next element
    * commandArray is the array of commands from the position of execution for this iteration of the function
    *  - commandArray is our overarching array of commands from the file 
    *  - DirSizes is the commandArray from from the _next_ command
*/ 
public array function getDirSize(required array commandArray, required array DirSizes){
    thisdir = listgetat(commandArray[1],3," ");
    thissum = 0
    thisArray = []

    writedump(var="#DirSizes#", label="Inside Top DirSizes")
    for(i=1;i<=commandArray.len();i++){
        writeoutput(commandArray[i] & "<br />")
        //go to thenext command,ls is inconsequential, dir notates a directory only
        if(listfindnocase("dir |$ ls",left(commandArray[i],4),"|")){    
            continue;
        }
        // return to parent directory level
        else if(left(commandArray[i],6) == "$ cd /") {
            continue;
        }
        // return to parent directory level
        else if(left(commandArray[i],7) == "$ cd ..") {
            break;
        // go into a subdirectory and recurse
        } else if(left(commandArray[i],5) == "$ cd ") { 
            // send the array from the current index to the end
            thisArray = getDirSize(commandArray.slice(i),DirSizes);
            thissum += int(thisArray[thisArray.len()].dirsize)
            thisdir &= thisArray[thisArray.len()].dirname
        } else {  // add to the sum of content sizes
            thissum += int(listgetat(commandArray[i],1," "))  // append the filesize sum
        }
        writeoutput("thisdir = " & thisdir & " | " & "thissum = " & thissum & "<br />")
    }
    DirSizes.append({"dirname"=thisdir,"dirsize"=thissum});
    return DirSizes;

}

returnedArray = getDirSize(console,DirSizes)

writeDump(var=returnedArray, label="returnedArray")
</cfscript>