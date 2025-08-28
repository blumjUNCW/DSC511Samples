libname SASData '~/SASData';

ods noproctitle;
Title 'Exercise 1';
proc means data=sasdata.index n q1 median q3 mean std;
 var r1000value r1000growth;
run;

Title 'Exercise 1B';
proc means data=sasdata.index n q1 median q3 mean std;
 var r1000:;
    /** name: references any variable that starts with
        the prefix characters and has any other characters
          (including none) after**/
run;

Title 'Exercise 2';
proc means data=sasdata.index n q1 median q3 mean std nonobs;
  class dt;
  format dt monname.;
  var r1000:;
run;

Title 'Exercise 3';
proc freq data=sasdata.realestate;
   table pool*quality / nocol;
run;

Title 'Exercise 4';
proc freq data=sasdata.projects;
  table date*region;
  format date qtr.;
  label date='Quarter';
run;

Title 'Exercise 5';
proc freq data=sasdata.projects;
  table pol_type*date*region;
  format date qtr.;
  label date='Quarter';
  where pol_type in ('LEAD','TSP');
run;

Title 'Exercise 6';
proc means data=sasdata.index n q1 median q3 mean std nonobs;
  class dt;
  format dt year.;
  var r1000:;
  where dt ge '01JAN2000'd;
    /**SAS date constant: 'ddMONyyyy'd converts to a SAS date**/
run;


