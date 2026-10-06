libname SASData '~/SASData';

/**for the CDI data, build a model for income per capita that includes,
        1. BA/BS rate
        2. Region
        3. the interaction between these
        
      determine which of these are significant/necessary/useful and give
      your best interpretation of those that are...*/

proc glm data=SASData.cdi;
  class region;
  model inc_per_cap = region|ba_bs / solution;
run;/**Interaction is significant, I want to try to assess that*/

proc means data=sasdata.cdi min q1 median q3 max;
  class region;
  var ba_bs;
run;

ods graphics off;
ods trace on;
proc glm data=SASData.cdi;
  class region;
  model inc_per_cap = region|ba_bs / solution;
  lsmeans region / diff=all at ba_bs=15 cl;
  lsmeans region / diff=all at ba_bs=20 cl;
  lsmeans region / diff=all at ba_bs=25 cl;
  ods output diff=pValues LSMeanDiffCL=Differences;
run;

/**In the Northeast, the large growth rate in per capita income vs. BA/BS
  rate leads to higher per capita incomes in that region than almost all
  other instances, particularly at higher BA/BS rates 
  
  For the North-Central, it starts as significantly higher than south in
    avg Inc per Cap, but that effect diminishes as BA/BS rate increases,
    becoming insignificant at 25% BA/BS
  It is similar for North-Central vs. West, but the effect diminishes more
    rapidly as BA/BS rate increases.

  For South vs. West, inc per cap is not significantly different across
      BA/BS rates.
  */

  /*Take the previous model and add in crime rate and its interactions with
    region and ba/bs rate and determine what is significant and interpret*/

data cdi;
  set sasdata.cdi;

  CrimeRate = crimes/(pop/10000);
  label CrimeRate = 'Crimes per 10,000 people';
run;

ods graphics off;
ods trace on;
proc glm data=cdi;
  class region;
  model inc_per_cap = region|ba_bs|CrimeRate @2 / solution;
run;
/*Interactions involving crime rate are not important...*/

ods graphics off;
proc glm data=cdi;
  class region;
  model inc_per_cap = region|ba_bs CrimeRate  / solution;
run;/*...and it further appears that crime rate is not important--
    does not improve the model with BA/BS and Region from before*/

ods graphics off;
proc glm data=cdi;
  class region;
  model inc_per_cap = CrimeRate  / solution;
run;

/**We will reduce a couple of quantitative predictors to binary... */
proc means data=sasdata.cdi median;
  class region;
  var ba_bs pop18_34;
run;

proc format;
  value baMedian
   low-20 = 'Below Median BA/BS Rate'
   20-high = 'Above Median BA/BS Rate'
   ;
  value popMedian
   low-28 = 'Below Median % 18 to 34'
   28-high = 'Above Median % 18 to 34'
   ;
run;
/**Using these to make binary predictors on ba/bs and
pop 18-34 (above median or not), use those two with region
and all interactions to predict income per capita.

Decide which predictors/interactions are significant and
interpret*/


ods graphics off;
proc glm data=cdi;
  class region ba_bs pop18_34;
  format ba_bs baMedian. pop18_34 popMedian.;
  model inc_per_cap = region|ba_bs|pop18_34 @2 / solution;
  ods select 'Type III Model ANOVA';
run; /*no 3-factor interaction

      all of the 2-factor interactions appear to be significant*/
ods graphics off;
proc glm data=cdi;
  class region ba_bs pop18_34;
  format ba_bs baMedian. pop18_34 popMedian.;
  model inc_per_cap = region|ba_bs|pop18_34 @2 / solution;
  lsmeans region*ba_bs region*pop18_34 ba_bs*pop18_34;
  *ods select 'Type III Model ANOVA';
  ods output lsmeans=means;
run;

title 'Profile Plot for Pop 18 to 34 vs. Region';
proc sgplot data=means;
  where ba_bs eq ' ';
  series x=region y=inc_per_capLSMean / group=pop18_34 markers
          markerattrs=(symbol=circlefilled);
run;
ods graphics off;
ods trace on;
proc mixed data=cdi;
  class region ba_bs pop18_34;
  format ba_bs baMedian. pop18_34 popMedian.;
  model inc_per_cap = region|ba_bs|pop18_34 @2 / solution;
  slice pop18_34*region / sliceby=region;
  slice pop18_34*region / sliceby=pop18_34 diff adjust=tukey;
  ods select sliceTests sliceDiffs;
run;
/**Average per capita income differs across counties with population rates
  above vs below median 18-34 for regions 1, 2, and 3. In each case the 
  average per capita income is higher for counties that are below the 
  median rate. No significant difference is detected in region 4
  
  For counties above the median 18-34 rate, there is little detectable
  difference in per capita income across regions--only regions 1 and 3
  test as significantly different.
  
  For counties below the median 18-34 rate, region 1 has significantly
  higher per capita income than all other regions. Region 2 also shows
  significantly higher per capita income than region 4.*/


title 'Profile Plot for BA/BS Rate vs. Region';
proc sgplot data=means;
  where pop18_34 eq ' ';
  series x=region y=inc_per_capLSMean / group=ba_bs markers
          markerattrs=(symbol=circlefilled);
run;
ods graphics off;
proc mixed data=cdi;
  class region ba_bs pop18_34;
  format ba_bs baMedian. pop18_34 popMedian.;
  model inc_per_cap = region|ba_bs|pop18_34 @2 / solution;
  slice ba_bs*region / sliceby=region;
  slice ba_bs*region / sliceby=ba_bs diff adjust=tukey;
  ods select sliceTests sliceDiffs;
run;
/**Higher BA/BS rate corresponds to higher avg per capita 
  income in any/all region 
  
  For counties above median BA/BS rate, region 1 has significantly
    higher avg. per capita income than the rest--no others are sig. diff.
    
  When below median BA/BS rate, region 3 shows a significantly lower
    avg per capita income than regions 1 and 2--no other sig diffs are
    detected.
  */

title 'Profile Plot for BA/BS vs. Pop 18 to 34';
proc sgplot data=means;
  where region eq ' ';
  series x=ba_bs y=inc_per_capLSMean / group=pop18_34 markers
          markerattrs=(symbol=circlefilled);
run;
ods graphics off;
proc mixed data=cdi;
  class region ba_bs pop18_34;
  format ba_bs baMedian. pop18_34 popMedian.;
  model inc_per_cap = region|ba_bs|pop18_34 @2 / solution;
  slice pop18_34*ba_bs / sliceby=ba_bs;
  slice pop18_34*ba_bs / sliceby=pop18_34;
  ods select sliceTests sliceDiffs;
run;
/**If pop 18-34 is below the median vs. above then per capita income is
    higher when the BA/BS rate is above the median. There is no difference
    in avg. per capita income across pop 18-34 groups when BA/BS rate is
    below the median
    
    When BA/BS rate is above the median, avg per capita income is higher 
      than when BA/BS rate is below the median, irrespective of 
      pop 18-34 */