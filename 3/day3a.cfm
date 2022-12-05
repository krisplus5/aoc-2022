<cfscript>
/* 
we want a map of the letter scores so that we can quickly reference the value for a given item type
because coldfusion is case-insensitive (for structkeys, and well, almost everything) we'll have to test for uppercase and add 26 to the result
a-z = 1-26 
A-Z = 27-52
*/
values = {"a"=1,"b"=2,"c"=3,"d"=4,"e"=5,"f"=6,"g"=7,"h"=8,"i"=9,"j"=10,"k"=11,"l"=12,"m"=13,"n"=14,"o"=15,"p"=16,"q"=17,"r"=18,"s"=19,"t"=20,"u"=21,"v"=22,"w"=23,"x"=24,"y"=25,"z"=26}
srcfile = expandPath( "./3a-source.txt" )
mistakeValueTotal = 0
sack = ""
pockets = []
pocket1 = []
pocket2 = []

//loop through sourcefile line by line 
cfloop(file=srcfile, index="sack"){ 
    mistake = ""
    pockets = []

    //because CF doesn't treat strings as full-fledged arrays, we have to munge for this
    sack.each(function(inp){arrayappend(pockets,inp)})
//    writeoutput(sack & " -- the sack<br />")

    //split the line in half to get the sacks 
    pocket1 = arrayslice(pockets, 1, arraylen(pockets)/2)
    pocket2 = arrayslice(pockets, arraylen(pockets)/2 + 1)

    //loop through each string until you find the common item type then break 

    for(i=1; i <= pocket1.len(); i++){
//        writeoutput(pocket1[i])
        if(arraycontains(pocket2, pocket1[i])){
            
            mistake = pocket1[i]
            //find the value of the item type and add it to our running total 

            mistakeValueTotal += values[mistake]
            //if the mistake is actually an uppercase letter, we need to add 26 to the value (stupid caseinsensitivity)
            if(asc(mistake) == asc(ucase(mistake))){
                mistakeValueTotal += 26 
            }
//            writeoutput(" : " & pocket1[i] & " = " & values[mistake] & " Total of: " & mistakeValueTotal & "<br/>")

            //go to the next sack
            break;
        }
    }
}
writeoutput(mistakeValueTotal)
</cfscript>
