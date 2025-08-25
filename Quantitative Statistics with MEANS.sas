libname SASData '~/SASData';

/**Basic quantitative statistics--PROC MEANS**/
proc means data=sasdata.projects;
  /**all numeric variables get summarized with default statistics**/
run;

proc means data=sasdata.projects min q1 median q3 max;
  /**statistic keywords can be given in the PROC statement**/
  var equipmnt personel jobtotal;
 /**VAR selects variables**/
run;

proc means data=sasdata.projects lclm mean uclm alpha=.10;
  var equipmnt personel jobtotal;
run;

proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type;
 /**class stratifies analyses over levels of the variable
    or combinations of levels if their are multiple**/
run;

proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
 /**class stratifies analyses over levels of the variable
    or combinations of levels if their are multiple**/
run;

ods trace on;
proc means data=sasdata.projects min q1 median q3 max;
  class pol_type region;
  var equipmnt personel jobtotal;
 /**order of statements generally is unimportant**/
run;

ods select none;
proc means data=sasdata.projects min q1 median q3 max;
  class pol_type region;
  var equipmnt personel jobtotal;
  ods output summary=FiveNumSummary;
/**ODS OUTPUT table-name1=dataset-name1 table-name2=dataset-name2 ...;
      need to know ^^^      ^^^choose this one**/    
run;
/**so we can use procedures to make data only...no output**/

ods select all;
proc sgplot data=fivenumsummary;
  hbar region / group=pol_type groupdisplay=cluster response=jobtotal_q1;
run;
