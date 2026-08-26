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


proc sort data=sasdata.cdi out=CDISort;
    by descending pop;
run;

Title 'Listing of County Information';
Title2 'for Counties of 1.5 Million or Greater Population';
footnote 'From CDI Table';
proc print data=CDISort label noobs;
  where pop ge 1.5*1000000;
  var pop county state land inc_per_cap unemp poverty;
  label pop='Population' 
        state='State Postal Code'
        land='Land Area, Square Miles' 
        inc_per_cap='Per Capita Income'
        ;
  format inc_per_cap dollar7. pop land comma9.;
run;

options label;
title 'Number of Counties where Poverty Rate Exceeds BA/BS Rate';
title2 'Stratified on Region';
proc freq data=sasdata.cdi;
  table region / nocum;
  where poverty gt ba_bs;
run;

/**You can make your own format definitions with PROC FORMAT...

  Typically we would use:
  PROC FORMAT;
    value format-name rules;  --this will often be many lines--
  run;
  */

proc format;
    /**When you name the format, do not include the dot,
      if it is for character values it must start with $,
      if it is for numeric it must not use the $ 
      it can have any legal name you want, unless it is
        already the name of a SAS-provided format*/  
    value region 
      1 = 'Northeast'
      2 = 'North Central'
      3 = 'South'
      4 = 'West'
      ;/*after all of the rules are defined, the VALUE statement ends*/
run;

title 'Number of Counties where Poverty Rate Exceeds BA/BS Rate';
title2 'Stratified on Region';
proc freq data=sasdata.cdi;
  table region / nocum;
  where poverty gt ba_bs;
  format region region.;
  /*format the region variable with the region format we created*/
run;

proc format;
    value regionB 
      1 - 2 = 'North' /*ranges can be used in rules..*/
      3 = 'South'
      4 = 'West'
      ;
      value regionC 
      1,2 = 'North' /*and comma-separated lists can be also*/
      3 = 'South'
      4 = 'West'
      ;
      value regionD 
      1 = 'North' 
      2 = 'North' /*can do this, but a bit cumbersome for many values*/
      3 = 'South'
      4 = 'West'
      ;
  run;

title 'Number of Counties where Poverty Rate Exceeds BA/BS Rate';
title2 'Stratified on Region';
proc freq data=sasdata.cdi;
  table region / nocum;
  where poverty gt ba_bs;
  format region regionB.;
run;

title 'Number of Counties where Poverty Rate Exceeds BA/BS Rate';
title2 'Stratified on Region';
proc freq data=sasdata.cdi;
  table region / nocum;
  where poverty gt ba_bs;
  format region regionC.;
run;

title 'Number of Counties where Poverty Rate Exceeds BA/BS Rate';
title2 'Stratified on Region';
proc freq data=sasdata.cdi;
  table region / nocum;
  where poverty gt ba_bs;
  format region regionD.;
run;


proc format;
    value regionE 
      1 - 2 = 'North' 
      other = 'Not North' /*other -> all other values not assigned
                            a rule in the format definition*/
      ;
run;
title 'Number of Counties where Poverty Rate Exceeds BA/BS Rate';
title2 'Stratified on Region';
proc freq data=sasdata.cdi;
  table region / nocum;
  where poverty gt ba_bs;
  format region regionE.;
run;

proc format;
    value regionF 
      1 - 2 = 'North' 
       /*if I don't give all values a rule...
          those appear unformatted*/
      ;
run;
title 'Number of Counties where Poverty Rate Exceeds BA/BS Rate';
title2 'Stratified on Region';
proc freq data=sasdata.cdi;
  table region / nocum;
  where poverty gt ba_bs;
  format region regionF.;
run;

proc format;
    value region 
      1 = 'Northeast'
      2 = 'North Central'
      3 = 'South'
      4 = 'West'
      ;
    value povCat
      low - <6 = 'Low (<6%)'
      6 - 10  = 'Moderate (6 - 10%)'
      10< - high = 'High (> 10%)'
      ;/*in addition to the - in ranges, you can use < 
          to leave off either end
          
        You also have two more useful keywords...
            low: smallest data value
            high: largest data value
            (this works for character as well, alphabetical order)*/
    value povCatB
      low - <5 = 'Low (<5%)'
      5 - 10  = 'Moderate (5 - 10%)'
      10< - high = 'High (> 10%)'
      ;
run;

title 'Poverty Level vs. Region';
proc freq data=sasdata.cdi;
  table region*poverty / nocol;
  format region region. poverty povCat.;
run;

title 'Poverty Level vs. Region';
proc freq data=sasdata.cdi;
  table region*poverty / nocol;
  format region region. poverty povCatB.;
run;


proc means data=sasdata.cdi;
  var ba_bs inc_per_cap;
  class region poverty;
  format region region. poverty povCat.;
run;

proc means data=sasdata.cdi;
  var ba_bs inc_per_cap;
  class poverty;
  format poverty povCat.;
run;


proc sgplot data=sasdata.cdi;
  hbar poverty / response=ba_bs stat=mean;
  format poverty povCat.;
run;

proc sgplot data=sasdata.cdi;
  hbar region / response=ba_bs stat=mean
                group=poverty groupdisplay=cluster;
  format poverty povCat. region region.;
run;