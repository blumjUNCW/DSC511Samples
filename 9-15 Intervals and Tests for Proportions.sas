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
  table chol_status*bp_status / binomial nocol;
  format bp_status $bp. chol_status $chol.;
run;/**Binomial only applies to single-variable
        or one-way tables */

proc freq data=sashelp.heart order=formatted;
  where chol_status ne ' ';
  table chol_status*bp_status / expected deviation nocol;
  format bp_status $bp. chol_status $chol.;
run;/**EXPECTED--Expected cell counts under independence
        and DEVIATIONS from Expected */

proc freq data=sashelp.heart order=formatted;
  where chol_status ne ' ';
  table chol_status*bp_status / expected deviation nocol cellchi2;
  format bp_status $bp. chol_status $chol.;
run;/*Individual contributions to the chi-square stat are also
      available*/

proc freq data=sashelp.heart order=formatted;
  where chol_status ne ' ';
  table bp_status*chol_status /nocol cellchi2 chisq deviation;
  /**The two independent samples proportion test is 
      equivalent to the chi-square test for independence*/
  format bp_status $bp. chol_status $chol.;
run;

proc freq data=sashelp.heart order=formatted;
  where chol_status ne ' ';
  table bp_status*chol_status /nocol cellchi2 chisq deviation;
run;

ods trace on;
proc freq data=sashelp.heart order=formatted;
  where chol_status ne ' ';
  table chol_status*bp_status / chisq riskdiff nocol nopercent alpha=0.10;
  /**RISKDIFF - difference in "risk"
      Risk - row percent value (does for each colum)
      Diff - is across the two rows
      typically the success/target is on the first column*/
  format bp_status $bp. chol_status $chol.;
  ods select crosstabfreqs RiskDiffCol1 ;
run;

ods trace on;
proc freq data=sashelp.heart order=formatted;
  where chol_status ne ' ';
  table chol_status*bp_status / chisq riskdiff relrisk nocol nopercent;
  /***/
  format bp_status $bp. chol_status $chol.;
  ods select crosstabfreqs RiskDiffCol1 RelativeRisks;
run;

libname SASData '~/SASData';
proc freq data=sasdata.mi;
  weight count;
  table group*mi / chisq riskdiff relrisk cellchi2;
run;
