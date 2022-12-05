<cfscript>
/*  
A X  -- rock / lose 
B Y   -- paper / draw
C Z   -- scissors / scissors

This strategy guide predicts and recommends the following:
Tool:
    rock = 1
    paper = 2
    scissors = 3
Outcome:
    win = 6
    lose = 0
    draw = 3

In the first round, your opponent will choose Rock (A), and you should choose Paper (Y). This ends in a win for you with a score of 8 (2 because you chose Paper + 6 because you won).
In the second round, your opponent will choose Paper (B), and you should choose Rock (X). This ends in a loss for you with a score of 1 (1 + 0).
The third round is a draw with both players choosing Scissors, giving you a score of 3 + 3 = 6.
In this example, if you were to follow the strategy guide, you would get a total score of 15 (8 + 1 + 6).

What would your total score be if everything goes exactly according to your strategy guide?
*/

/* calculate the round 
    // what tool did you pick? 1=rock, 2=paper, 3=scissors
    //did you win the round? win=6, 0=lose, 3=draw 

    // what tool did your opponent pick? 
        * rock kills scissors
        * paper kills rock
        * scissors kill paper
       
        Here's a scoring matrix 
        * A/X=4      B/X=1      C/X=7  
        * A/Y=8      B/Y=5      C/Y=2  
        * A/Z=3      B/Z=9      C/Z=6  
*/
scores = {A={X=4,Y=8,Z=3},B={X=1,Y=5,Z=9},C={X=7,Y=2,Z=6}}
total = 0
//read the file in and loop through the lines
srcfile = expandPath( "./2a-source.txt" )
line = ""

//loop over the file line by line
cfloop(file=srcfile, index="line"){ 
    //writeOutput(scores[line[1]][line[3]])
    total += scores[line[1]][line[3]]
}
writeOutput(total)
</cfscript>