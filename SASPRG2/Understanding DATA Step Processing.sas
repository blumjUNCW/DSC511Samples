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



data storm_complete;
  set pg2.storm_summary_small(obs=10); 
    putlog "PDV after SET statement";
  putlog _all_; 
  length Ocean $ 8;
  drop EndDate;
  where Name is not missing;
  Basin=upcase(Basin);
  StormLength=EndDate-StartDate;
  putlog StormLength=;
  if substr(Basin,2,1)="I" then Ocean="Indian";
  else if substr(Basin,2,1)="A" then Ocean="Atlantic";
  else Ocean="Pacific";
  putlog "NOTE: PDV at the end of an iteration";
  putlog _all_;
run;


data np_parks;
  set pg2.np_final;
  where Type="PARK";
  
  Type=propcase(Type);
  AvgMonthlyVisitors=sum(DayVisits,Campers,OtherLodging)/12;
  if Acres<1000 then Size="Small";
    else if Acres<100000 then Size="Medium";
      else Size="Large";

  format AvgMonthlyVisitors Acres comma10.;
  keep Region ParkName AvgMonthlyVisitors Acres Size;
run;

data np_parks;
  set pg2.np_final;
  putlog "NOTE: Start of DATA Step Iteration";
  putlog _all_;
  where Type="PARK";
  
  Type=propcase(Type);
  AvgMonthlyVisitors=sum(DayVisits,Campers,OtherLodging)/12;
  putlog Type= AvgMonthlyVisitors=;

  length Size $6;
  if Acres<1000 then Size="Small";
    else if Acres<100000 then Size="Medium";
      else Size="Large";

  putlog _all_;
  putlog 'NOTE: End of Iteration';
  format AvgMonthlyVisitors Acres comma10.;
  keep Region ParkName AvgMonthlyVisitors Acres Size;
run;


