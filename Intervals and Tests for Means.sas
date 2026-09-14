/**PROC MEANS can give confidence intervals for the mean...*/
proc means data=sashelp.heart clm;
  var systolic;
run; /**CLM -> Confidence limits for the mean -- error/alpha is 0.05 by default*/

proc means data=sashelp.heart n lclm mean uclm alpha=0.01;
  var systolic;
run;/*can split clm into lclm and uclm and include other stats,
      error rate is set with alpha= */

/*Means can give p-values...*/      
proc means data=sashelp.heart n t probt ;
  var systolic;
run;/**It assumes that Ho has mu = 0 
      So, I would not typically use this. */

proc ttest data=sashelp.heart h0=135;
  var systolic;
run;/**In TTEST, we have a VAR statement to select the 
      analysis variable(s) and we can choose a hypothesized
      value  for the mean*/

ods graphics off;
proc ttest data=sashelp.heart h0=135 alpha=0.025;
  var systolic;
run;/**You can turn of the graphics and set error rates for 
      confidence intervals.*/


proc ttest data=sashelp.heart;
  class sex;
  var systolic;
run;/**Class sets up a comparison between 2 groups...*/ 

proc ttest data=sashelp.heart;
  class weight_status;
  /**The class variable must be reduced to two levels, 
      error otherwise...*/
  var systolic;
run;

proc ttest data=sashelp.heart;
  class weight_status;
  where weight_status in ('Normal' 'Overweight');
  var systolic;
run;

proc format;
  value $WS
    'Overweight' = 'Over'
    'Normal','Underweight' = 'Not Over'
    ;
run;
proc ttest data=sashelp.heart;
  class weight_status;
  format weight_status $WS.;
  /**I can reduce any set of categories to two with proper formatting
        Missing/blank is not taken as a class for analysis*/
  var systolic;
run;

/*Exercise:
1. Using the SASHELP.CARS data as if it were a random sample:
(a) Test for a difference in average city MPG between cars from Asia and Europe. Also, construct a
confidence interval for the mean difference, and state a conclusion from these results.
(b) Do the same as the previous for Asia vs. US, and US vs. Europe.
*/
proc ttest data=sashelp.cars;
  class origin;
  where origin in ('Asia','Europe');
  var mpg_city;
run;

proc ttest data=sashelp.cars;
  class origin;
  where origin in ('Asia','USA');
  var mpg_city;
run;

proc ttest data=sashelp.cars;
  class origin;
  where origin in ('Europe','USA');
  var mpg:;
run;

