proc means data=sashelp.heart n mean std stderr;
  var systolic;
  where weight_status eq 'Normal';
run;

proc means data=sashelp.heart n lclm mean uclm;
  var systolic;
  where weight_status eq 'Normal';
run;

proc means data=sashelp.heart t probt;
    /**t and probt are t-statistic and its p-value, 
      respectively assuming the null mean is 0
        (and you cannot change that)**/
  var systolic;
  where weight_status eq 'Normal';
run;

/**can make it work...**/
data heartMod;
  set sashelp.heart;
  where weight_status eq 'Normal';
  systolicAdj = systolic-130;
run;
proc means data=heartMod t probt;
    /**move 130 to 0 as an adjustment**/
  var systolicAdj;
run;

/**t-test allows you to pick the null value...**/
ods graphics off;
proc ttest data=sashelp.heart h0=130;
  var systolic;
  where weight_status eq 'Normal';
run;

proc format;
  value $hbp
  'High'='High'
  other='Not High'
  ;
run;
proc freq data=sashelp.heart;
  format BP_status $hbp.;
  where weight_status eq 'Normal';
  table BP_status / binomial(h0=0.3);
  *ods select onewayfreqs binomialTest;
run;

/**get the upper bound for proportion w/95% 
    confidence...***/
proc freq data=sashelp.heart;
  format BP_status $hbp.;
  where weight_status eq 'Normal';
  table BP_status / binomial(h0=0.3) alpha=0.10;
    /**90% confidence in both directions = 95% confidence 
          in only one (upper or lower)**/
  *ods select onewayfreqs binomialTest;
run;

proc freq data=sashelp.heart;
  table BP_status / binomial(h0=0.45);
  format BP_status $hbp.;
  *ods select onewayfreqs binomialTest;
run;
