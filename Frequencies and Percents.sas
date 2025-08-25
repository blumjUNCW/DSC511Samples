libname SASData '~/SASData';

/***Frequencies and percents are done with PROC FREQ***/
proc freq data=sasdata.projects;
run;/**categorizes every variable and gives frequency and percent--may not be a good idea for some...**/

proc freq data=sasdata.projects;
  table pol_type region;/**table chooses variables...**/
run;

proc freq data=sasdata.projects;
  table pol_type region / nocum;
  /**options for the table are specified after a / character--
      in general, internal statements in a procedure separate elements and options with the / **/
run;


proc freq data=sasdata.projects;
  table pol_type*region; 
    /**table A*B; gives a cross-tabulation, 
      levels of A as rows, B as columns**/
run;

proc freq data=sasdata.projects;
  table region*pol_type / nocol chisq; 
    /**some special options are available for these
      types of tables**/
run;

proc freq data=sashelp.cars;
  table drivetrain*origin*type;
run;

proc freq data=sasdata.projects;
  table (stname region)*pol_type;
run;

