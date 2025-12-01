libname SASData '~/SASData';

proc format;
  value reg
    1='Northeast'
    2='North-central'
    3='South'
    4='West'
    ;
run;

ods graphics off;
proc glm data=sasdata.cdi;
  class region;
  format region reg.;
  model inc_per_cap = region / solution;
  lsmeans region / lines adjust=tukey;
run;

ods graphics off;
proc glm data=sasdata.cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs / solution;
  *lsmeans region / lines adjust=tukey;
run;
/**because the cross-product: region*ba_bs is
    significant, we analyze it as it indicates
    there is an inconsistency of the ba/bs relationship
    to per capita income across regions**/

ods graphics off;
proc glm data=sasdata.cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs / solution;
  lsmeans region / lines adjust=tukey;
  lsmeans region / at means lines adjust=tukey;
run;/**If we ask for a region comparison now,
      it is done at the average value of ba_bs rate
      for the whole data set...useful, but perhaps
      not the whole picture

      I'll want to look at the comparisons for some other
      values of ba_bs rate...**/

proc means data=sasdata.cdi min q1 median q3 max;
  class region;
  var ba_bs;
  ways 0 1;
run;/**check out the distribution of the quantitative
    predictor to help you choose...**/

ods graphics off;
proc glm data=sasdata.cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs / solution;
  lsmeans region / at ba_bs=10 lines adjust=tukey;
  lsmeans region / at ba_bs=15 lines adjust=tukey;
  lsmeans region / at ba_bs=20 lines adjust=tukey;
  lsmeans region / at ba_bs=25 lines adjust=tukey;
  lsmeans region / at ba_bs=30 lines adjust=tukey;
  ods select lsmlines;
run;

ods graphics off;
proc glm data=sasdata.realestate;
  class quality;
  model price = quality / solution;
  lsmeans quality / diff=all lines;
run;

ods graphics off;
proc glm data=sasdata.realestate;
  class quality;
  model price = quality|sq_ft / solution;
  lsmeans quality / at means diff=all lines;
run;

proc means data=sasdata.realestate min q1 median q3 max;
  class quality;
  var sq_ft;
  ways 0 1;
run;

ods graphics off;
proc glm data=sasdata.realestate;
  class quality;
  model price = quality|sq_ft / solution;
  lsmeans quality / at sq_ft=1600 diff=all lines;
  lsmeans quality / at sq_ft=2100 diff=all lines;
  lsmeans quality / at sq_ft=2600 diff=all lines;
  lsmeans quality / at sq_ft=3100 diff=all lines;
  ods select lsmlines parameterEstimates;
run;/**average price stays in its ordinal ranking
    vs quality for all square footages, but the 
    differences appear to change...

    Estimate the difference in average price between
      high quality homes and medium quality homes at
        3300 sqft (median for high) - 2200 sqft (median 
          for medium quality).**/

/**Estimate the difference in mean price between 
    high and medium quality homes at 3300 sqft.
   Estimate that difference at 2200 sqft.
   Estimate the difference in those differences**/

/**Going back to the CDI data, construct a population density
    variable and include it with region and ba_bs, putting in each
    individual effect and cross-products between region and 
    each of the quantitative variables. Interpret the result.**/
 
data cdi;
  set sasdata.cdi;
  popDensity = pop/land;
run;

ods graphics off;
proc glm data=cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs region|popDensity / solution;   
run;

proc means data=cdi min q1 median mean q3 max;
  class region;
  var ba_bs popDensity;
  ways 0 1;
run;

proc sgplot data=cdi;
  scatter x=ba_bs y=popDensity / group=region markerattrs=(symbol=circlefilled size=5pt);
  where popDensity le 5000;
run;


ods graphics off;
proc glm data=cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs region|popDensity / solution;   
  lsmeans region / at ba_bs=10 lines adjust=tukey;
  lsmeans region / at ba_bs=15 lines adjust=tukey;
  lsmeans region / at ba_bs=20 lines adjust=tukey;
  lsmeans region / at ba_bs=25 lines adjust=tukey;
  lsmeans region / at ba_bs=30 lines adjust=tukey;
  /**we can set one of the covariates, the other is at the mean--
      that happens to be a rather poor choice for population
      density because of skewness***/
  ods select lsmlines;
run;

ods graphics off;
proc glm data=cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs region|popDensity / solution;   
  lsmeans region / at (ba_bs popDensity)=(10 300) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(15 300) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 300) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 300) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(30 300) lines adjust=tukey;
  /**Of course, we can set both--perhaps changing both or possibly
      changing one and holding the other steady***/
  ods select lsmlines;
run;
