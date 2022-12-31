<cfscript>


// keep history of last 2 vertical & horizontal directional moves (x/y)
string function recordDirection(string dir, string last2) {
    if(dir == 'L' or dir == 'R'){
        last2 = dir & right(last2,1);
    }else{
        last2 = left(last2,1) & dir;
    }
    return last2;
}

//keep a running history of our path - uniquely
struct function recordHistory(struct str,struct hist) {
    //we have to explicitly create a new struct due to pass by reference of the contained struct
    var newstr = {"#str.x##str.y#":{x:"#str.x#",y:"#str.y#"}};
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
struct function moveDiagonal(struct pos, string dirhist) {
    for(d in dirhist.split("")){
        switch (d) {
            case "U":
                pos.y++;
                break;
            case "D":
                pos.y--;
                break;
            case "L":
                pos.x--;
                break;
            case "R":
                pos.x++;
                break;
        }
    }
    return pos;
}

//move the item - only 1 step either vertical/horizontal
struct function moveOne(struct theknot, string dir){
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
struct function moveTail(struct head, struct tail, string dirhist, struct hist){

    //we only move if it is not touching already
    if(!isTouching(head,tail)){
        //is it vertically/horizontally aligned to the head? 
        if(head.x == tail.x || head.y == tail.y){
            tail = moveOne(tail,dirhist);

        }else{ //or is it diagonally distant?
            tail = moveDiagonal(tail,dirhist);
        }
        //record the new position
        hist = recordHistory(tail,hist);
    }
    return tail;
}



/* testing moveTail -----------     */
testdir = "LD";
strhead = {x:-1,y:-1};
strtail = {x:0,y:1};
myhistory = {00:{x:0,y:0}};

writedump(myhistory);
writedump(moveTail(strhead,strtail,testdir,myhistory))
D 1
L 2
D 2
L 1
R 1
D 1
R 2
U 1
R 1
D 2
R 1
L 2
U 1
D 2
R 1
L 2
R 1
U 2
D 2
L 1
U 2
R 2
D 1
R 2
D 1
U 2
D 2
L 1
U 1
R 1

//writeoutput(testdir & " <- testdir<br />")
writedump(var=strhead,label="strhead.1");
writedump(var=strtail,label="strtail.1");
writedump(var="#myhistory#", label="myhistory.1");

strtail = moveTail(strhead,strtail,testdir,myhistory);
writedump(var=strhead,label="strhead.2");
writedump(var=strtail,label="strtail.2");
writedump(var="#myhistory#", label="myhistory.2");

strhead = {x:-2,y:-3};

teststruct = moveTail(strhead,strtail,testdir,myhistory);
writedump(var=strhead,label="strhead.3");
writedump(var=strtail,label="strtail.3");
writedump(var="#myhistory#", label="myhistory.3");


/* testing moveOne ---- SUCCESS
testdir = "L";
teststruct = {x:0,y:0};

writedump(var=teststruct,label="teststruct.1");
teststruct = moveOne(teststruct,testdir);
writedump(var=teststruct,label="teststruct.2");
*/

/* testing moveDiagonal ---- SUCCESS 
testdir = "RU";
teststruct = {x:0,y:0};

writedump(var=teststruct,label="teststruct.1");
teststruct = moveDiagonal(teststruct,testdir);
writedump(var=teststruct,label="teststruct.2");
*/

/* testing isTouching ---- SUCCESS 
struct1 = {x:-1,y:-1};
struct2 = {x:0,y:1};

writedump(var=struct1,label="isTouching.struct1");
writedump(var=struct2,label="isTouching.struct2");
writeoutput(isTouching(struct1,struct2) & " <- isTouching.2<br />");
*/

/* testing recorddirection ------- SUCCESS 
last2Dirs = "LU"

writeoutput(last2Dirs & " <- recordDirection.1<br />");
last2Dirs = recordDirection("L",last2Dirs);
writeoutput(last2Dirs & " <-recordDirection.2<br />");
last2Dirs = recordDirection("U",last2Dirs);
writeoutput(last2Dirs & " <-recordDirection.3<br />");
last2Dirs = recordDirection("R",last2Dirs);
writeoutput(last2Dirs & " <-recordDirection.4<br />");
last2Dirs = recordDirection("D",last2Dirs);
writeoutput(last2Dirs & " <-recordDirection.5<br />");
last2Dirs = recordDirection("R",last2Dirs);
writeoutput(last2Dirs & " <-recordDirection.6<br />");
*/

/* testing recordhistory ---------- SUCCESS 
myhistory = {}

mytail = {x:0,y:0}
myhistory = recordHistory(mytail,myhistory);

mytail = {x:1,y:0}
myhistory = recordHistory(mytail,myhistory);

mytail = {x:2,y:0}
myhistory = recordHistory(mytail,myhistory);

mytail = {x:2,y:1}
myhistory = recordHistory(mytail,myhistory);

mytail = {x:2,y:0}
myhistory = recordHistory(mytail,myhistory);

mytail = {x:1,y:-1}
myhistory = recordHistory(mytail,myhistory);

writedump(var=myhistory,label="myhistory");
*/


</cfscript>