libname IPEDS '~/IPEDS';

/***need to get graduation rates...
    two rows for each institution--one with an incoming cohort size and
                                    number graduating within 150% of standard time

    need to divide the numbers in one row by the numbers in another...

      divide numbers in the completer row by the numbers in the cohort row and 
        output that result for each institution**/


proc sort data=ipeds.graduation out=gradSort;
  by unitId group;
run;

data test1;
  set gradSort;
  by unitId group;/**for any sorted data set, I can use a BY statement, even in a data step**/
    /**when this is active, for each variable in the BY two special variables are created:
          first.variable and last.variable 
        they're automatically dropped, and you can't keep them (but we can see them)**/

  firstUnit=first.unitID; /**first.unitID is created...**/
  LastUnit=last.unitID;/**..and so is last.unitID**/
  
  firstGroup=first.group; /**first.group is also created...**/
  LastGroup=last.group;/**..and so is last.group**/
run;

proc sort data=sashelp.cars out=sortCars;
  by make type;
run;

data test2;
  set sortCars;
  by make type;

  firstMake=first.make; lastMake=last.make;
  firstType=first.type; lastType=last.type;
run;/**these help me track where groups start and end--
      it is tracking grouping, variables in the nested
        sort may start new groups even if values do not change or repeat later**/


data grads cohort;/**It is possible to make more than one data set
                    in a DATA step--if I do this, I will take control of
                    output somewhere inside the DATA step**/
  set gradSort;
  by unitId group;

  if first.unitID then output grads;
  if last.unitID then output cohort;

run;

data all;
  merge grads(rename=(men=GradMen women=GradWomen))
        cohort;/**a merge matches records...**/
  by unitId;/**on a set of BY variables**/

  gradRateM = GradMen/Men;
  gradRateW = GradWomen/Women;

  diff = gradRateM-gradRateW;

  format gradRate: percent8.2;

  drop total group;
run;

/**do the test???**/
ods graphics off;
proc ttest data=all;
  paired gradRateM*gradRateW;
run;
proc ttest data=all;
  var diff;
run;


proc sql;
  create table all2 as  
  select grads.*, cohort.men as incomingMen, cohort.women as incomingWomen,
      grads.women/incomingWomen-grads.men/incomingMen as rateDiff
  from grads full join cohort
      on grads.unitID eq cohort.unitID
  ;
quit;
ods graphics off;
proc ttest data=all2;
  var rateDiff;
run;
  



  
