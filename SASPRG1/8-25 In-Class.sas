libname SASData '~/SASData';

ods noproctitle;
title 'Five Number Summaries';
title2 'Income per Capita and BA/BS Rate';
proc means data=sasdata.cdi n min q1 median q3 max maxdec=1;
  /*statistics are controlled in the PROC MEANS statement*/
  class region; /*CLASS chooses any stratification variables*/
  var inc_per_cap ba_bs;/*VAR chooses analysis variables (must be numeric)*/

  footnote h=10pt 'Stratified on Region';
  footnote2 h=10pt 'From CDI Table';
run;

Title 'Listing of County Information';
Title2 'for Counties of 1.5 Million or Greater Population';
footnote 'From CDI Table';
proc print data=sasdata.cdi label;
  where pop ge 1.5*1000000;
  var pop county state land inc_per_cap unemp poverty;
run;
