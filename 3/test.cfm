<cfscript>

srcfile = expandPath( "./3b-source.txt" )

//srcarray1 = listtoarray(srcfile,"#chr(10)#",true,true)
srcarray = []
temparray = []

//loop through the array of lines, converting each line to an array of chars
cfloop(file=srcfile,index="line"){
    line.each(function(inp){arrayappend(temparray,inp)})
    arrayappend(srcarray,temparray)
    temparray = []
}
//writedump(srcarray)
//now loop through our groups - every 3 array elements
for(i=1; i<arraylen(srcarray); i=i+3){
//writeoutput("element #i#<br/>")
    for(j=1; j<=arraylen(srcarray[i]); j++){
        if(srcarray[i+1].contains(srcarray[i][j]) and srcarray[i+2].contains(srcarray[i][j])){
            writeoutput("element " & i & " badge-ID: " & srcarray[i][j] & "<br />")
            break;
        }else{
            writeoutput(srcarray[i][j] & ": no-match<br />")
        }
    }

}
/* 
   srcarray[i].each(function(inp){
        if(srcarray[i+1].contains(inp) and srcarray[i+2].contains(inp)){
            writeoutput("element " & i & " badge-ID: " & inp & "<br />")
            break;
        }else{
            writeoutput(inp & ": no-match<br />")
        }

    })
*/
//writedump(srcarray)
</cfscript>
