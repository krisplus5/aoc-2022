<cfscript>

/* 
    * We're doing a head & tail following exercise 
    * head and tail start at the same position, overlapping
    * don't let the tail get more than 1 step away 
    * head and tail move 1 step at a time until each instruction is complete
    * finally, we have to count the number of unique spaces that the TAIL has touched
*/

// keep history of last 2 directional moves
struct function recordDirection(string dir, struct last2) {
    if(dir == 'L' or dir == 'R'){
        last2.x = dir;
    }else{
        last2.y = dir;
    }
    return last2;
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

// move diagonally given last 2 directional moves and current position - always just 1 in each direction
struct function moveDiagonal(struct pos, struct dirhist) {
    pos = moveOne(pos,dirhist.x);
    pos = moveOne(pos,dirhist.y);
    return pos;
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
    return theknot;
}

//move the tail so that it is touching the head
struct function moveTail(struct head, struct tail, string dir, struct dirhist, struct hist){
/*    writedump(var=dirhist,label="moveTail.dirhist");
    writedump(var=head,label="moveTail.head")
    writedump(var=tail,label="moveTail.tail1")
    //writedump(var=hist, label="moveTail.hist")*/

    //we only move if it is not touching already
    if(!isTouching(head,tail)){
        //is it vertically/horizontally aligned to the head? 
        if(head.x == tail.x || head.y == tail.y){
            tail = moveOne(tail,dir);

        }else{ //or is it diagonally distant?
            tail = moveDiagonal(tail,dirhist);
        }
        //record the new position
        hist = recordHistory(tail,hist);
    }
    //writedump(var=tail,label="moveTail.tail2")

    return tail;
}

//our head movement instructions
srcfile = expandPath( "./9a-source.txt" )

//the grid is an infinite matrix starting from a center x,y coordinate of 0,0
thehead = {"x"=0,"y"=0}
thetail = {"x"=0,"y"=0}

//last2Dirs = "LD"; //the last 2 directions we moved
last2Dirs = {x:"L",y:"D"} // the last 2 directions we moved - an x and y

//keep a history of tail movement
allPositions = recordHistory(thetail,{});
//writedump(var=allPositions,label="allPositions.root");

instruction = {dir:"",steps:0}//the current head move sinstruction
tmpInstruct = [] // a place to split the instruction to - just temporary holding array

//process the head commands line by line
cfloop(file=srcfile, index="line"){
    //read the instruction 
    tmpInstruct = line.split(" ");
    instruction.dir = tmpInstruct[1];
    instruction.steps = tmpInstruct[2];

    //record the direction for this instruction item
    last2Dirs = recordDirection(instruction.dir,last2Dirs);

    //move the head and then the tail as appropriate
    for(i=1;i<=instruction.steps;i++){
        //move the head
        thehead = moveOne(thehead,instruction.dir);
        //move the tail as required 
        thetail = moveTail(thehead,thetail,instruction.dir,last2Dirs,allPositions);
    }
}
//writedump(allPositions);
writedump(var=structkeyarray(allPositions),label="keyarray");
</cfscript>
