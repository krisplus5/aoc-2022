<cfscript>
    /*  
     *  test a small recursion 
     *  sum up an array recursively until such that:
     *  **** - 4 numeric elements summed
     *  ***  - take the return from above, and add 3 numeric elements 
     *  **   - take the return from above, and add 82 numeric elements... 
     *  *    - finally last element from which we sum and return
     *  
     */

    numeric function myArrSum(array numArray){
        writedump(var="#numArray#",label="inside 1")
        if(numArray.len() == 1){
            writeoutput("inside if <br />")
            return numArray[1]
        }
        else if(numArray.isEmpty() || numArray.len() == 0){
            writeoutput("inside else if <br />")
            return 0
        }
        else{
            writeoutput("inside else <br />")
            return arraysum(numArray)+(myArrSum(numArray.slice(1,numArray.len()-1)))
        }
    }

    writeoutput(myArrSum([2,4,6]))
    writeoutput("<br />")
    writeoutput(myArrSum([55]))
    writeoutput("<br />")
    writeoutput(myArrSum([]))
    writeoutput("<br />")
    writeoutput(myArrSum(['a','b']))
    writeoutput("<br />")

    </cfscript>