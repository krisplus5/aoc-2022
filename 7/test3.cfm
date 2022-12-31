<cfscript>
    /*  
     *  test writing to a containing array for fun
     */

    outStruct = [myArray = [33,11,55,88]]

    void function myFunTest(struct inStruct){
        writedump(var="#inStruct#",label="inside 1")
        inStruct.myArray.append("22");
        writedump(var="#inStruct#", label="inside 2")
    }

    myFunTest(outStruct)

    writedump(outStruct)

    </cfscript>