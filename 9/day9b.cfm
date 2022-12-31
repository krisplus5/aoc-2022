<cfscript>

    /* 
        * We're doing a head & tail following exercise 
        * head and tail start at the same position, overlapping
        * don't let the tail get more than 1 step away 
        * head and tail move 1 step at a time until each instruction is complete
        * finally, we have to count the number of unique spaces that the TAIL has touched
        * AND now we're introducing 9 knots to the rope - so only track the 9th knot
    */
    
    // determine new required tail position 
    struct function newPosition(struct head, struct tail) {
        // if head.x & tail.x aren't equal, we are moving tail.x in a specific direction; similarly for .y
        // we only move a max of 1 position in x/y axis at a time
        var dir = {x:tail.x,y:tail.y};

        if(head.x != tail.x){
            if(head.x > tail.x){
                dir.x += 1;
            }else{
                dir.x -= 1;
            }
        }
        if(head.y != tail.y){
            if(head.y > tail.y){
                dir.y += 1;
            }else{
                dir.y -= 1;
            }
        }
        return dir;
    }
    
    //keep a running history of our path - uniquely
    struct function recordHistory(struct str,struct hist) {
        //we have to explicitly create a new struct due to pass by reference of the contained struct
        var newstr = {"#str.x#|#str.y#":{x:"#str.x#",y:"#str.y#"}};
        hist.append(newstr,true);
        return hist;
    }
    
    // is head touching tail - within 1 block surrounding the head
    boolean function isTouching(struct head, struct tail){
        var x = [head.x,tail.x];
        var y = [head.y,tail.y];
    
        x.sort("numeric","asc");
        y.sort("numeric","asc");
        return(x[2]-x[1] <= 1 && y[2]-y[1] <= 1);
    }
       
    //move the item - only 1 step either vertical/horizontal
    struct function moveOne(struct theknot, string dir){
        //move the knot
        switch (dir) {
            case "U":
            theknot.y++;
                break;
            case "D":
            theknot.y--;
                break;
            case "L":
            theknot.x--;
                break;
            case "R":
            theknot.x++;
                break;
        }
        //writedump(var=theknot,label="moveOne.theknot2");
        return theknot;
    }
    
    //move the tail so that it is touching the head
    boolean function moveTail(struct head, struct tail, string dir, struct hist, boolean rechist){
    /*  writedump(var=head,label="moveTail.head")
        writedump(var=tail,label="moveTail.tail1")
        //writedump(var=hist, label="moveTail.hist")*/
        newtail = newPosition(head,tail);
        //we only move if it is not touching already
        if(!isTouching(head,tail)){
            tail.x = newtail.x;
            tail.y = newtail.y;
            if(rechist){
                hist = recordHistory(tail,hist);
            }
            return true;
        }
        return false;
    }

    //our head movement instructions
    srcfile = expandPath( "./9a-source.txt" )
    
    //the grid is an infinite matrix starting from a center x,y coordinate of 0,0
    //we have head/tail for each of the 10 knots
    knots = [{"x"=0,"y"=0},{"x"=0,"y"=0},{"x"=0,"y"=0},{"x"=0,"y"=0},{"x"=0,"y"=0},{"x"=0,"y"=0},{"x"=0,"y"=0},{"x"=0,"y"=0},{"x"=0,"y"=0},{"x"=0,"y"=0}]
       
    //keep a history of tail movement - the tail only please
    allPositions = recordHistory(knots[10],{});
    //writedump(var=allPositions,label="allPositions.root");
    
    instruction = {dir:"",steps:0}//the current head move sinstruction
    tmpInstruct = [] // a place to split the instruction to - just temporary holding array
    
    //process the head commands line by line
    cfloop(file=srcfile, index="line"){
        //read the instruction 
        tmpInstruct = line.split(" ");
        instruction.dir = tmpInstruct[1];
        instruction.steps = tmpInstruct[2];
    
        //hold pre-action value to compare 
        strCompare = knots[2];

        for(j=1;j<=instruction.steps;j++){
            //PRIME THE HEAD: the head moves every time
            knots[1] = moveOne(knots[1],instruction.dir);

            //PROCESS THE ROPE; only move subsequent knots if we move the preceding knot
            if(moveTail(knots[1],knots[2],instruction.dir,allPositions,false)){
                if(moveTail(knots[2],knots[3],instruction.dir,allPositions,false)){
                    if(moveTail(knots[3],knots[4],instruction.dir,allPositions,false)){
                        if(moveTail(knots[4],knots[5],instruction.dir,allPositions,false)){
                            if(moveTail(knots[5],knots[6],instruction.dir,allPositions,false)){
                                if(moveTail(knots[6],knots[7],instruction.dir,allPositions,false)){
                                    if(moveTail(knots[7],knots[8],instruction.dir,allPositions,false)){
                                        if(moveTail(knots[8],knots[9],instruction.dir,allPositions,false)){
                                            moveTail(knots[9],knots[10],instruction.dir,allPositions,true);
                                        } // tail 9
                                    } //tail 8
                                } //tail 7
                            } //tail 6
                        } //tail 5
                    } //tail 4
                } //tail 3
            } //tail 2
        } //each step iteration & initial head move
    } //looping file
    //writedump(allPositions);
    writedump(var=structkeyarray(allPositions),label="keyarray");
    </cfscript>
    