libname IPEDS '~/IPEDS';
options fmtsearch=(IPEDS); /**fmtsearch= sets libraries in which to search for format catalogs**/

proc sort data=ipeds.graduation out=gradSort;
  by unitId group;
run;

data gradRates;
  merge gradSort ipeds.characteristics(keep=unitID control);
  by unitId;
  retain GradWomen GradMen Grads;/**retain tells the data step to hold the value
        from one iteration into subsequent ones**/

  if first.unitID then do; /**this is the number(s) of graduates**/
     GradWomen=Women;
     GradMen=Men;
     Grads=Total;
  end;

  if last.unitID then do; /**now I have the cohort, can compute the rate**/
    RateWomen=GradWomen/Women;
    RateMen=GradMen/Men;
    Rate=Grads/Total;
    output;/**calculation complete, output the record**/
  end;
run;

proc ttest data=Gradrates;
  class control;
  var Rate;
  *where control in ('Public','Private, not for Profit');
    /**control is numeric, not character**/
  where control in (1 2);
run;

proc ttest data=Gradrates;
  class control;
  var Rate;
  where put(control,control.) contains 'Public' or put(control,control.) contains 'not';
      /**put(variable, format.); converts a numeric variable to character using
          the specified format**/
run;

proc ttest data=Gradrates;
  class control;
  var Rate;
  where (put(control,control.) contains 'Public' or put(control,control.) contains 'not') 
          and total ge 100;
run;

proc format;
  value GeHalf
    0-<0.5='no'
    0.5-high='Yes'
    ;
run;

proc freq data=gradRates order=formatted;
  where (put(control,control.) contains 'Public' or put(control,control.) contains 'not') 
          and total ge 100;
  table control*rate / chisq riskdiff;
  format rate geHalf.;
  ods exclude fishersExact;
run;




