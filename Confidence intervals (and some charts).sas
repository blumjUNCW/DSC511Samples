libname SASData '~/SASData';

proc sgplot data=SASData.ipums2005mini;
  histogram MortgagePayment / scale=proportion binstart=100 binwidth=100
            dataskin=gloss;
  /**reference point for any bar/bin is its center,
      binstart is where to place the center of the first bar**/
  xaxis label='Mortgage Payment' valuesformat=dollar8.
            values=(50 to 550 by 100);
  yaxis display=(nolabel) valuesformat=percent7.;
  where MortgagePayment gt 0;
run;


proc sgplot data=sashelp.heart;
  vbox systolic / group=chol_status groupdisplay=cluster extreme
                    whiskerattrs=(color=red) grouporder=ascending;
  keylegend / across=1 position=topleft location=inside title=''
            noborder;
  yaxis label='Systolic BP';
  where not missing(chol_status);/**missings are included as a separte group
      level, but I don't want them**/
    /**missing(variable)  is 1 if the record contains a missing value, 0 otherwise**/
run;


proc sgplot data=sashelp.heart;
  vbox systolic / group=chol_status groupdisplay=cluster outlierattrs=(symbol=squarefilled size=4pt)
                    meanattrs=(color=black symbol=X) 
                    whiskerattrs=(color=red) grouporder=ascending;
  keylegend / across=1 position=topleft location=inside title=''
            noborder;
  yaxis label='Systolic BP';
  where not missing(chol_status);
run;

proc means data=sashelp.heart lclm mean uclm alpha=0.10;
  var systolic;
  class chol_status;
run;

proc format;
  value $DesOrNot
    'Desirable'='Desirable'
     other = 'not Desirable'
      ;
run;
proc freq data=sashelp.heart;
  table chol_status / binomial;/**binomial gives intervals and hypothesis tests for
                                  proportions**/
  format chol_status $desOrNot.;
  where not missing(Chol_status);/**missings behave strangely
      in FREQ if they are included in a format bin...*/
run;


proc freq data=sashelp.heart;
  table chol_status / binomial alpha=.1;/**binomial gives intervals and hypothesis tests for
                                  proportions**/
  format chol_status $desOrNot.;
  where not missing(Chol_status);/**missings behave strangely
      in FREQ if they are included in a format bin...*/
run;


proc freq data=sashelp.heart;
  table weight_status*chol_status / binomial alpha=.1;/**binomial is only valid in one-way tables**/
  format chol_status $desOrNot.;
  where not missing(Chol_status);
run;

proc sort data=sashelp.heart out=heartSort;
  by weight_status;
run;
proc freq data=heartSort;
  by weight_status;/**stratification is still available with BY**/
  table chol_status / binomial alpha=.1;
  format chol_status $desOrNot.;
  where not missing(Chol_status);
  ods select binomial;
run;

proc freq data=sashelp.heart;
  table chol_status / binomial alpha=.1;
    /**If it's not two categories and you use binomial,
        FREQ makes it two...first category is the target, all others are not**/
  where not missing(Chol_status);
run;
