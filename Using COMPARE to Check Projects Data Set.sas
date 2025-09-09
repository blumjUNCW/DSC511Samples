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

libname SASData '~/SASData';

/**PROC COMPARE compares two data sets**/
proc compare base=sasdata.projects compare=work.projects;
run;/***Base= and Compare= name the two tables to be compared,
      records from the two tables will be labeled this way in output data sets**/

/**Comparison is done on matching variables only--Matching = same name and type
    record comparison is a matched on row number...
      first record in base is compared to first record in compare
      second record from each is compared, and so on...

  Sort order is expected to be the same for both**/

/**Check out variable names...**/
proc contents data=sasdata.projects;
  ods select variables;
run;
proc contents data=work.projects;
  ods select variables;
run;

proc compare base=sasdata.projects(rename=(equipmnt=equipment personel=personnel 
                                          pol_code=PollutionCode pol_type=Pollutant
                                          stname=state))   
                        /**rename=(oldname1=newname1 oldname2=newname2 ...)**/
             compare=work.projects;
run;/**variables now align...**/

/**Row order? Find a primary key -> Set (minimal) of variables that uniquely identifies a record
      and therefore produces a unique sort**/

proc sort data=sasdata.projects out=BaseProjects nodupkey dupout=dups;/**nodupkey is going to tell me if I have successfully found the primary key**/
  by jobID;
run;/**Not quite**/

proc sort data=sasdata.projects out=BaseProjects nodupkey dupout=dups;
  by jobID pol_type;
run;/**Closer...**/

proc sort data=sasdata.projects out=BaseProjects nodupkey dupout=dups;
  by jobID date pol_type jobtotal;
run;

proc sort data=work.projects out=CompareProjects nodupkey dupout=dups;
  by jobID date Pollutant jobtotal;
run;

/**row ordering is the same, so now we have a reasonable basis for 
    comparison**/
proc compare base=BaseProjects(rename=(equipmnt=equipment personel=personnel 
                                          pol_code=PollutionCode pol_type=Pollutant
                                          stname=state))   
             compare=CompareProjects;
run;

proc compare base=BaseProjects(rename=(equipmnt=equipment personel=personnel 
                                          pol_code=PollutionCode pol_type=Pollutant
                                          stname=state))   
             compare=CompareProjects out=Comparison;/**can make an out= dataset...
                                                      by default it only shows differences (subtraction for numeric
                                                        individual character comparison for text -> . is equal, X is unequal**/
run;

proc compare base=BaseProjects(rename=(equipmnt=equipment personel=personnel 
                                          pol_code=PollutionCode pol_type=Pollutant
                                          stname=state))   
             compare=CompareProjects out=Comparison outall;/**OUTALL is base, compare, and dif record for each observation...**/
run;

proc compare base=BaseProjects(rename=(equipmnt=equipment personel=personnel 
                                          pol_code=PollutionCode pol_type=Pollutant
                                          stname=state))   
             compare=CompareProjects out=Comparison outall outnoequal;/**OUTNOEQUAL only sends out sets for comparisons with unequal variables**/
run;/***Try this with our cars.datfile read in data**/
