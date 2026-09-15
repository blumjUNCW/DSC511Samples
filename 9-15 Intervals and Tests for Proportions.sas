/**We typically get proportions from PROC FREQ...*/
proc freq data=sashelp.heart;
  table bp_status;
run;

proc freq data=sashelp.heart;
  table bp_status / binomial;
run;

proc freq data=sashelp.heart;
  table bp_status / binomial(p=0.4);
run;

proc freq data=sashelp.heart;
  table bp_status / binomial(p=0.43);
run;

proc freq data=sashelp.heart;
  table bp_status / binomial(level='Normal' p=0.4);
run;

proc format;
  value $bp
  'Normal'='1. Normal'
  Other='2. Other'
  ;
run;
proc freq data=sashelp.heart order=formatted;
  table bp_status / binomial;
  format bp_status $bp.;
run;

proc freq data=sashelp.heart;
  table bp_status / binomial(level='1. Normal' p=0.4);
      /**If you do have a format, the formatted value goes in LEVEL= */
  format bp_status $bp.;
run;

proc freq data=sashelp.heart;
  table bp_status*chol_status / binomial;
run;

proc format;
  value $chol
  'High'='1. High'
  Other='2. Other'
  ;
  value $bp
  'High'='1. High'
  Other='2. Other'
  ;
run;

proc freq data=sashelp.heart order=formatted;
  where chol_status ne ' ';
  table bp_status*chol_status / binomial;
  format bp_status $bp. chol_status $chol.;
run;/**Binomial only applies to single-variable
        or one-way tables */

proc freq data=sashelp.heart order=formatted;
  where chol_status ne ' ';
  table bp_status*chol_status / chisq;
  /**The two independent samples proportion test is 
      equivalent to the chi-square test for independence*/
  format bp_status $bp. chol_status $chol.;
run;

proc freq data=sashelp.heart order=formatted;
  where chol_status ne ' ';
  table chol_status*bp_status / chisq riskdiff relrisk;
  /**The two independent samples proportion test is 
      equivalent to the chi-square test for independence*/
  format bp_status $bp. chol_status $chol.;
run;