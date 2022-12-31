<cfscript>

    /* 
    Given the grid of tree heights from our forest shown in the source file 
    * determine how many trees are visible from each tree
    * use only horizontal and vertical axis (no diagonals)
    * a tree is visible if it and intervening trees have height <= the point of view tree 
    * what is the largest tree-view available from any tree in our forest?
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
    scenicScore = 1;
    maxScenicScore = 0;
    fdepth = forest.len();
    fwidth = arraylen(forest[1]);
    
    writeoutput("fdepth = #fdepth# || fwidth = #fwidth#<br />");
    
    // iterating trees
    for(i=1;i<=fdepth;i++){ // iterate rows
    
        for(j=1;j<=fwidth;j++){ // j = iterate columns
    
            tree = forest[i][j]; //height of this tree
            visibleTrees = 0;
            scenicScore = 1;
            /* short-circuit when the view is blocked by a tree of same or greater height 
             * add to the row to the left and row the right and the top and the bottom;
            */
            //check to the left
            for(k=j-1;k>0;k--){
                visibleTrees += 1;
                if(tree <= forest[i][k]){
                    break;
                }
            }
            scenicScore *= (visibleTrees == 0 ? 1 : visibleTrees)
            visibleTrees = 0;
    
            //check to the right
            for(k=j+1;k<=fwidth;k++){
                visibleTrees += 1;
                if(forest[i][k]>=tree){
                    break;
                }
            }
            scenicScore *= (visibleTrees == 0 ? 1 : visibleTrees);
            visibleTrees = 0;
    
            //check above 
            for(k=i-1;k>0;k--){
                visibleTrees += 1;
                if(forest[k][j]>=tree){
                    break;
                }
            }
            scenicScore *= (visibleTrees == 0 ? 1 : visibleTrees);
            visibleTrees = 0;
            
            //check below
            for(k=i+1;k<=fdepth;k++){
                visibleTrees += 1;
                if(forest[k][j]>=tree){
                    break;
                }
            }
            scenicScore *= (visibleTrees == 0 ? 1 : visibleTrees);

            //writeOutput("num visibleTrees [#i#][#j#] = #scenicScore#<br />");

            if(scenicScore > maxScenicScore){
                maxScenicScore = scenicScore;
            }
        }
    }
 //writeOutput("<br />");
   
    writeoutput("Max Visible Trees: #maxScenicScore# <br />");
        
</cfscript>
    