<cfscript>
    /*  
     *  test whether I can write back to an attribute 
     * 
     */
    
   numeric function testFunc(numeric testCount){
        thisCount = 0;
        
        for(i=testCount;i<=testCount+10;i++){
            thisCount += i;
            writeoutput(i & " ");
        }
        testCount = thisCount
        return thisCount;
    }

    testNum = testFunc(5)
    writeDump(testNum)

    </cfscript>