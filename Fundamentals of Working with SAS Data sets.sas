libname SASData '~/SASData';

/***SAS language contains global statements
    --standalone statements like LIBNAME 
      these take effect as soon as they successfully compile (and execute)**/

/**SAS language is also based heavily on steps
    --collections of statements that execute after a set of statements are compiled
    --procedures (PROC) are one type of step

PROC CONTENTS allows you to view metadata**/

proc contents data=sasdata.cdi;  /**PROC statements choose the procedure and start the step**/
    /**data set references are two-level: libref.dataset

        you can also say: dataset -> then Work is presumed to be library**/
run;/**RUN and QUIT are step boundaries, end the step (technically not required)**/


/**Contents creates a minimum of three tables by default...
    I tend to want to have some control over which tables are displayed (or not)
        and maybe some other stuff**/
/**ODS (Output Delivery System) statements can help me with this...**/

ods trace on; /**the trace is a series of messages corresponding to
      each output object placed into the SAS log

      this is a global statement and its effect is also
        global--stays in this state until you change it**/
proc contents data=sasdata.cdi;
run;

proc contents data=sasdata.cdi varnum;
run;

proc contents data=sasdata.cdi;
  ods select variables;
  /**SELECT chooses tables for display**/
run;

proc contents data=sasdata.cdi varnum;
  ods select position;
run;

proc contents data=sasdata.cdi;
  ods exclude Attributes EngineHost;
run;

proc contents data=sasdata.cdi varnum;
  ods exclude Attributes EngineHost;
run;/**EXCLUDE tells what to leave out (everything else stays)
      logically, you should only use one of the two**/

ods exclude Attributes EngineHost;
/**SELECT/EXCLUDE apply to the next step only if specific tables are
    listed**/
proc contents data=sasdata.cdi;
run;

proc contents data=sasdata.cdi varnum;
run;

ods exclude none;
/**SELECT/EXCLUDE ALL or NONE has global effect--turns everything
    on or off until you change it**/
proc contents data=sasdata.cdi;
run;


/***Display the actual data portion--PRINT or REPORT**/
proc print data=sasdata.cdi;
run;

proc print data=sasdata.cdi label noobs;
run;

proc print data=sasdata.cdi label noobs;
  var state county pop land inc_per_cap;
  /**default behavior of PRINT is to display all columns in column order
      VAR lets you choose variables and their ordering**/
run;

proc report data=sasdata.cdi;
run;

proc report data=sasdata.cdi;
  column state county pop land inc_per_cap;
/**COLUMN chooses variables in REPORT (and can make new ones as we will see)**/
run;

/**Basic quantitative statistics--PROC MEANS**/
proc means data=sasdata.projects;
  /**all numeric variables get summarized with default statistics**/
run;

proc means data=sasdata.projects min q1 median q3 max;
  /**statistic keywords can be given in the PROC statement**/
  var equipmnt personel jobtotal;
 /**VAR selects variables**/
run;

proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region ;
 /**class stratifies analyses over levels of the variable
    or combinations of levels if their are multiple**/
run;

proc means data=sasdata.projects min q1 median q3 max;
  where region in ('Beaumont' 'Boston');
  class pol_type region ;
  var equipmnt personel jobtotal;
run;

proc means data=sasdata.projects min q1 median q3 max;
  class pol_type region ;
  var equipmnt personel jobtotal;
  where region in ('Beaumont' 'Boston');
run;/**statement order inside a procedure generally is unimportant**/