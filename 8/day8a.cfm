<cfscript>

/* 
Given the grid of tree heights from our forest shown in the source file 
* determine how many trees are visible from the perimeter
* use only horizontal and vertical axis (no diagonals)
* a tree is visible if all trees between it and the perimeter are shorter than it 
* all perimeter trees are visible
*/

srcfile = expandPath( "./8a-source.txt" )
forest = []    // this will hold our forest; it is an array of arrays; 1st element is row, 2nd element is col

    //read in the forest tree heights file
cfloop(file=srcfile, index="line"){
    //get our line, split it into a column array, append to row array
    forest.append(line.split(""));
}
// now go through the rows from 2nd element to next to last elements and determine visibility 

visibleTrees = 0;
fdepth = forest.len();
fwidth = arraylen(forest[1]);
visible = true;

writeoutput("fdepth = #fdepth# || fwidth = #fwidth#<br />");

// for iterating each of the trees, don't look at the perimeters - we know they're visible
for(i=2;i<fdepth;i++){ // iterate rows

    for(j=2;j<fwidth;j++){ // j = iterate columns

        visible = true;
        tree = forest[i][j]; //height of this tree
        
        /* short-circuit if we find visibility 
         * compare to the row to the left and row the right and the top and the bottom;
         * only continue checking each direction if we're NOT visible on the previous
        */
        //check to the left
        for(k=1;k<j;k++){
            if(tree <= forest[i][k]){
                visible = false;
                break;
            }
        }

        //check to the right
        if(!visible){
            visible = true;
            for(k=j+1;k<=fwidth;k++){
                if(forest[i][k]>=tree){
                    visible = false;
                    break;
                }
            }
        }

        //check above 
        if(!visible){
            visible = true;
            for(k=1;k<i;k++){
                if(forest[k][j]>=tree){
                    visible = false;
                    break;
                }
            }
        }

        //check below
        if(!visible){
            visible = true;
            for(k=i+1;k<=fdepth;k++){
                if(forest[k][j]>=tree){
                    visible = false;
                    break;
                }
            }
        }

        if(visible){
            visibleTrees += 1;
        }
    }
}

//remember to add the outside perimeter of the forest to our count 
writeoutput("Total Visible Trees: #visibleTrees# + <br />");

writeoutput("Width = #fwidth#<br />");
writeoutput("Depth = #fdepth#<br />");
visibleTrees += 2*(fwidth);
visibleTrees += 2*(fdepth-2);

writeoutput("Total Visible Trees: #visibleTrees#<br />");
</cfscript>
