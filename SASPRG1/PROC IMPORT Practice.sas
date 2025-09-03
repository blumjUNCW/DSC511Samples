PROC IMPORT DATAFILE='~/Courses/PG1V2/data/storm_damage.csv' /**Input file, as a path**/
  DBMS=CSV /**File type (CSV,TAB,xlsx,...)**/
  OUT=WORK.StormDamage /**Output table (SAS data set)**/
  replace /**Default behavior is to preserve the out= table if it exists, this changes
            to replacement of the table**/
  ;
  GETNAMES=YES;/**use the first row of data as the variable names**/
RUN;

proc import datafile="~/Courses/PG1V2/data/storm_damage.tab"
            dbms=tab out=storm_damage_tab replace;
  getnames=yes;
run; 

***********************************************************;
*  LESSON 2, PRACTICE 1                                   *;
*    a) Complete the PROC IMPORT step to read             *;
*       EU_SPORT_TRADE.XLSX. Create a SAS table named     *;
*       EU_SPORT_TRADE and replace the table              *;
*       if it exists.                                     *;
*    b) Modify the PROC CONTENTS code to display the      *;
*       descriptor portion of the EU_SPORT_TRADE table.   *;
*       Submit the program, and then view the output data *;
*       and the results.                                  *;
***********************************************************;

proc import datafile="~/Courses/PG1V2/data/eu_sport_trade.xlsx"
            dbms=xlsx out=work.eu_sport_trade replace;
  getnames=yes;
run;

proc contents data=eu_sport_trade;
run;

/**Try this on Class.xlsx ...**/
proc import datafile="~/Courses/PG1V2/data/class.xlsx"
            dbms=xlsx out=work.class replace;
  getnames=yes;
run;/**This workbook has multiple sheets--by default you get the first one...
  try to get a different one (any that you like)**/

proc import datafile="~/Courses/PG1V2/data/class.xlsx"
            dbms=xlsx out=work.test replace;
  getnames=yes;
  sheet=class_test;
run;

/**Practice 2**/
proc import datafile="~/Courses/PG1V2/data/np_traffic.csv"
            dbms=csv out=np_traffic replace;
  getnames=yes;
  guessingrows=max;
run; 

/**Practice 3**/
proc import datafile="~/Courses/PG1V2/data/np_traffic.dat"
            dbms=dlm out=np_traffic2 replace;
            /**DBMS=DLM says it is a delimited file...**/
  getnames=yes;
  guessingrows=max;
  delimiter='|';/**the DELIMITER statement allows you to choose the delimiter(s)**/
run; 

proc import datafile="~/Courses/PG1V2/data/np_traffic.csv"
            dbms=dlm out=np_traffic replace;
  getnames=yes;
  guessingrows=max;
  delimiter=',';
run; 


proc import datafile="~/Courses/PG1V2/data/storm_damage.tab"
            dbms=dlm out=storm_damage_tab replace;
  getnames=yes;
  guessingrows=max;
  delimiter='09'x; /**09 is the ASCII hex code for a tab--can give hex codes as '##'x**/
run; 

PROC IMPORT DATAFILE='~/Courses/PG1V2/data/storm_damage.csv' 
  DBMS=dlm
  OUT=WORK.StormDamage 
  replace
  ;
  GETNAMES=YES;
  guessingrows=max;
  delimiter=',';
RUN;