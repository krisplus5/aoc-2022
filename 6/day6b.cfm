<cfscript>
    srcfile = expandPath( "./6a-source.txt" )
    isMarker = false
    packet = ""
    numunique = 14

    //we're having fun with element quotas - cf won't let me have an array with more than 4k indices :(
    //read in the signal
    cfloop(file=srcfile, index="line"){
        writedump(line)
        writedump("<br />")
//
        for(i=1;i<=line.len();i++){ 
            packet = arraytolist(line.mid(i,numunique).split("")) // get 4 chars in a list at a time
            packetcount = 0
            for(j=1;j<=listlen(packet);j++){
                packetcount += listvaluecount(packet,listgetat(packet,j))
            }

            if(packetcount==numunique){
                writeoutput("ANSWER : " & packet & " : " & i+numunique-1 & "<br /> ")
                break;
            }
            writeoutput(packet & " : " & packetcount & "<br />")
        }
    }
        
</cfscript>
    