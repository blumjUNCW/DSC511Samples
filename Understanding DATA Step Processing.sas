libname pg2 '~/Courses/PG2V2/data';


data storm_complete;
  drop EndDate;  
    /**drop is a compile-time statement, and flags 
      column(s) to be dropped from the output data set,
      this/these are available during processing/execution**/
  set pg2.storm_summary_small; 
  length Ocean $ 8;
  *drop EndDate;
  where Name is not missing;
  Basin=upcase(Basin);
  StormLength=EndDate-StartDate;
  if substr(Basin,2,1)="I" then Ocean="Indian";
  else if substr(Basin,2,1)="A" then Ocean="Atlantic";
  else Ocean="Pacific";
  *drop EndDate;
run;

proc contents data=storm_complete;
run;

data problem;
  set pg2.storm_summary_small(drop=EndDate); 
    /**here I'm dropping it from the input data...bad idea**/
  length Ocean $ 8;
  where Name is not missing;
  Basin=upcase(Basin);
  StormLength=EndDate-StartDate;
  if substr(Basin,2,1)="I" then Ocean="Indian";
  else if substr(Basin,2,1)="A" then Ocean="Atlantic";
  else Ocean="Pacific";
run;

data NoProblem(drop=EndDate);/**same effect as DROP EndDate;**/
  set pg2.storm_summary_small; 
  length Ocean $ 8;
  where Name is not missing;
  Basin=upcase(Basin);
  StormLength=EndDate-StartDate;
  if substr(Basin,2,1)="I" then Ocean="Indian";
  else if substr(Basin,2,1)="A" then Ocean="Atlantic";
  else Ocean="Pacific";
run;
