data projects;
  infile '~/SASData/projects.txt' dlm='09'x dsd missover;  
  input State:$2. JobID:$5. Date:mmddyy. Region:$10. Equipment Personnel PollutionCode;

  JobTotal = Equipment + Personnel;

  length Pollutant $4; 
  select(PollutionCode); /**SELECT(expression) -> check equality of expression against conditions in WHEN clauses
                            if no expression (and no parentheses) are given, each WHEN must contain a complete condition**/
    when(1) Pollutant='TSP';
    when(2) Pollutant='LEAD';
    when(3) Pollutant='CO';
    when(4) Pollutant='SO2';
    otherwise Pollutant='O3';
  end;/**SELECT is a block, uses an END to terminate**/

  format date weekdate. Equipment Personnel JobTotal dollar12. ;
    
run;