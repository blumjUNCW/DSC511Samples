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
  

/**Repeat for institutions that enrolled at least 100 men and 100 women**/
ods graphics off;
proc ttest data=all;
  paired gradRateM*gradRateW;
  where men ge 100 and women ge 100;
run;

/***Build the data without splitting into tables that you rejoin**/
proc sort data=ipeds.graduation out=gradSort;
  by unitId group;
run;

data gradRates;
  set gradSort;
  by unitId group;

  if first.unitID then do; /**this is the number(s) of graduates**/
     GradWomen=Women;
     GradMen=Men;
  end;

  if last.unitID then do; /**now I have the cohort, can compute the rate**/
    RateWomen=GradWomen/Women;
    RateMen=GradMen/Men;
  end;/**these are all missing because GradMen and GradWomen are missing....
        each time a record is read, the Program Data Vector (PDV)--memory area--
          is wiped; all variables are reset to missing
          no information is carried over, unless you tell it to**/
run;

data gradRates;
  set gradSort;
  by unitId group;
  retain GradWomen GradMen;/**retain tells the data step to hold the value
        from one iteration into subsequent ones**/

  if first.unitID then do; /**this is the number(s) of graduates**/
     GradWomen=Women;
     GradMen=Men;
  end;

  if last.unitID then do; /**now I have the cohort, can compute the rate**/
    RateWomen=GradWomen/Women;
    RateMen=GradMen/Men;
    output;/**calculation complete, output the record**/
  end;
run;

ods graphics off;
proc ttest data=gradRates;
  paired RateWomen*RateMen;
run;
proc ttest data=gradRates;
  paired RateWomen*RateMen;
  where men ge 100 and women ge 100;
run;

/**add in Yes/No on 50% or more for each of women and men**/
data gradRatesB;
  set gradSort;
  by unitId group;
  retain GradWomen GradMen;

  if first.unitID then do;
     GradWomen=Women;
     GradMen=Men;
  end;

  if last.unitID then do; 
    if men ne 0 and women ne 0;/**subsetting if (if with no then) continues if true, returns to top if not**/
    RateWomen=GradWomen/Women;
    if RateWomen ge 0.5 then GE50Women='Yes';
      else GE50Women='No';
    RateMen=GradMen/Men;
    if RateMen ge 0.5 then GE50Men='Yes';
      else GE50Men='No';
    *if RateWomen ne . and RateMen ne . then output;
    output;
  end;
run;

proc freq data=gradRatesB;
  table ge50Women*ge50Men / agree;
  where men ge 100 and women ge 100;
run;

/**Do it without adding the GE50 variables--use the original gradRates...**/
proc format;
  value GeHalf
    0-<0.5='No'
    0.5-high='Yes'
    ;
run;


ods graphics off;
proc freq data=gradRates;
  table RateWomen*RateMen / agree;
  format RateWomen RateMen GeHalf.;
  where men ge 100 and women ge 100;
run;


  
