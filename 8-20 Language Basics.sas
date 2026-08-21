title 'Summary Statistics for MPG';
proc means data=sashelp.cars;
  var mpg:; /*Specifying VAR: uses : as a wildcard--can only be used as as suffix*/
  class origin;
run;

proc means data=sashelp.cars;
  class origin;
  var mpg:; 
  /*For the most part, statement order inside a procedure does not
    matter*/
run;

proc print data=sashelp.heart(obs=10);
run;

/*statements like TITLE are global...statements that are:
  1. standalone--do not need to be inside a step
  2. are executed/placed into effect as soon as they are compiled
  3. stay in effect until they are altered (caveat, in Studio a new
    submission may constitute a reset of some of those statements)*/

/*ODS -> Output Delivery System gives certain control/info on output objects*/
ods trace on; 
/**ODS TRACE ON -> sets up a delivery of details for each output object
                  created to the log */
proc univariate data=sashelp.heart;
  var systolic;
run;


proc univariate data=sashelp.heart;
  var systolic;
  ods select quantiles extremeObs;
  /**ODS SELECT or ODS EXCLUDE are used to choose output objects*/
run;


ods select quantiles extremeObs;
/**can put this here, but only applies to next procedure*/
proc contents data=sashelp.heart;
run;
proc univariate data=sashelp.heart;
  var systolic;
run;

proc univariate data=sashelp.cars;
  var mpg_city;
run;

proc means data=sashelp.cars;
  var mpg:; 
  class origin;
  ods output summary=MPGMeans;
run;

ods select none;/**this does behave in a fully global fashion,
                  output is off until you turn it back on*/
proc means data=sashelp.cars;
  var mpg:; 
  class origin;
  ods output summary=MPGMeans;
run;