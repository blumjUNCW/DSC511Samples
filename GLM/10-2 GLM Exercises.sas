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