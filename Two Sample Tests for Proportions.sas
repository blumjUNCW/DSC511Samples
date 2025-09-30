libname SASData '~/SASData';

proc sort data=SASData.DrugTrial3 out=Trial3;
  by descending group descending response;
run;

proc freq data=Trial3 order=data;
  table group*response /nocol;
run;

proc freq data=Trial3 order=data;
  table group*response /nocol expected;
  /**Expected gives expected cell counts
    under the independence assumption**/
run;


proc freq data=Trial3 order=data;
  table group*response /nocol expected chisq;
  /**chisq produces several chi-square
  stats and p-values...**/
run;

proc freq data=Trial3 order=data;
  table group*response /nocol expected chisq
                      deviation cellchi2 ;
  /**individual cell contributions can be put
    into the table**/
run;

proc freq data=Trial3 order=data;
  table group*response /nocol chisq riskdiff alpha=.10;
  ods exclude fishersexact;
  /****/
run;

ods graphics off;
ods trace on;
proc freq data=SASData.DiagnosticTest order=freq; 
    /**order=freq starts with highest frequency...**/
  table test1*test2 / agree;
  /**agree conducts McNemar's test for dependent proportions (among other things)**/
  ods exclude KappaStatistics;
run;

/***Exercises***/
/*1a*/
ods graphics off;
Title 'Asia v. Europe';
proc ttest data=sashelp.cars;
  class origin;
  where origin ne 'USA';
  var mpg_city;
run;

/*1b*/
ods graphics off;
Title 'US v. Europe';
proc ttest data=sashelp.cars;
  class origin;
  where origin ne 'Asia';
  var mpg_city;
run;
Title 'Asia v. US';
proc ttest data=sashelp.cars;
  class origin;
  where origin ne 'Europe';
  var mpg_city;
run;

/*2a*/
title 'Highway v. City MPG--All';
ods graphics off;
proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
run;

/*2b*/
title 'Highway v. City MPG--Trucks and SUVs';
ods graphics off;
proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
  where type in ('Truck' 'SUV');
run;

/*3a*/
title 'High Cholesterol Proportion--High BP v. Normal BP';
proc format;
  value $chol
    'High'='High'
    other='Not High'
    ;
run;

ods graphics off;
proc freq data=sashelp.heart order=formatted;
  table bp_status*chol_status / chisq riskdiff;
  format chol_status $chol.;
  where chol_status ne '' and bp_status in ('High' 'Normal');
  ods exclude fishersExact;
run;

/*4*/
proc freq data=SASData.Environment;
  table HigherTaxes*CutLivingStandards;
run;