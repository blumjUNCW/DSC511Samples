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
  *ods select lsmlines parameterEstimates;
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
proc sgplot data=sasdata.realestate;
  reg x=sq_ft y=price / group=quality degree=1 markerattrs=(symbol=circle size=4pt);
run;

ods graphics off;
proc glm data=sasdata.realestate;
  class quality;
  model price = quality|sq_ft / solution;
  lsmeans quality / at sq_ft=2200 diff=all lines;
  lsmeans quality / at sq_ft=3300 diff=all lines;
  estimate 'High Quality Price @3300 sq.ft.' intercept 1
                                             quality 1 0 0
                                             sq_ft 3300
                                             sq_ft*quality 3300 0 0;
  estimate 'Medium Quality Price @3300 sq.ft.' intercept 1
                                             quality 0 1 0
                                             sq_ft 3300
                                             sq_ft*quality 0 3300 0;
  estimate 'High - Medium Price @3300 sq.ft.' quality 1 -1 0
                                              sq_ft*quality 3300 -3300 0;
  estimate 'High - Medium Price @2200 sq.ft.' quality 1 -1 0
                                              sq_ft*quality 2200 -2200 0;
  estimate 'High - Medium Price @3300 vs 2200 sq.ft.' 
                                              sq_ft*quality 1100 -1100 0;
  *ods select lsmlines parameterEstimates;
run;


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

ods graphics off;
proc glm data=cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs region|popDensity / solution;   
  lsmeans region / at (ba_bs popDensity)=(15 300) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 300) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 300) lines adjust=tukey;
  ods select lsmlines;
run;

ods graphics off;
proc glm data=cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs region|popDensity / solution;   
  lsmeans region / at (ba_bs popDensity)=(20 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 500) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 650) lines adjust=tukey;
  *ods select lsmlines;
run;

proc sgplot data=cdi;
  reg x=popDensity y=inc_per_cap / group=region degree=1 
                                      markerattrs=(symbol=circle size=4pt);
  where popDensity le 5000;
run;


ods graphics off;
proc glm data=cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs region|popDensity / solution;   
  lsmeans region / at (ba_bs popDensity)=(15 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(15 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(15 500) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 500) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 500) lines adjust=tukey;
  ods select lsmlines diff;
run;

ods graphics off;
proc glm data=cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs region|popDensity / solution;   
  lsmeans region / at (ba_bs popDensity)=(15 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(15 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(15 500) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 500) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 500) lines adjust=tukey;
  ods select lsmlines diff;
  /**with no interaction between the quantitative covariates,
      this grid is unnecessary, the relationships cannot be inconsisent
      across varying combinations of ba/bs and density**/
run;

/*If you put that interaction in, it is significant and then
    the grid is the correct approach**/
ods graphics off;
proc glm data=cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs|popDensity / solution; 
  lsmeans region / at (ba_bs popDensity)=(15 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(15 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(15 500) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 500) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 500) lines adjust=tukey;
  ods select lsmlines;
run;

ods graphics off;
proc glm data=cdi;
  class region;
  format region reg.;
  model inc_per_cap = region|ba_bs|popDensity / solution; 
  lsmeans region / at (ba_bs popDensity)=(15 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(15 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(15 500) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(20 500) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 200) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 350) lines adjust=tukey;
  lsmeans region / at (ba_bs popDensity)=(25 500) lines adjust=tukey;
  ods select lsmlines;
run;

/**Add in crime rate to our potential predictors, but we'll make it categorical.
      Median rate is about 52.5 crimes per 1000 people--make (or format) a predictor
      that is binary, above the median or below.

      put that into a model (for per-capita income) with region and ba/bs rate and 
        all of their interactions. Interpret what is significant...**/

data cdi;
  set sasdata.cdi;
  popDensity = pop/land;
  CrimeRate = crimes/(pop/1000); *or crimes/pop*1000;
run;
proc means data=cdi median;
  var CrimeRate;
run;

proc format;
  value cr
  low-52.5='Bottom Half'
  52.5-high='Top Half'
  ;
run;

ods graphics off;
proc glm data=cdi;
  class region CrimeRate;
  format region reg. CrimeRate cr.;
  model inc_per_cap = region|ba_bs|CrimeRate / solution; 
run;

/**three factor interaction is not important...eliminate it**/
ods graphics off;
proc glm data=cdi;
  class region CrimeRate;
  format region reg. CrimeRate cr.;
  model inc_per_cap = region|ba_bs|CrimeRate @2 / solution; 
run;

ods graphics off;
proc glm data=cdi;
  class region CrimeRate;
  format region reg. CrimeRate cr.;
  model inc_per_cap = ba_bs|region ba_bs|CrimeRate / solution; 
  lsmeans CrimeRate / at ba_bs=10 diff;
  lsmeans CrimeRate / at ba_bs=15 diff;
  lsmeans CrimeRate / at ba_bs=20 diff;
  lsmeans CrimeRate / at ba_bs=25 diff;
  lsmeans CrimeRate / at ba_bs=30 diff;
run;

/**keep crimeRate as is, create a binary pop. density variable below 350 vs above 350,
    make a 4-category ba/bs: below 15 lowest,
                             15-20 low,
                             20-25 high,
                             25+ highest

  for response is inc. per-capita, put all of these three categorical precitors in
    with all interactions and interpret**/

data cdi;
  set sasdata.cdi;
  popDensity = pop/land;
  CrimeRate = crimes/(pop/1000); *or crimes/pop*1000;
run;

proc format;
  value cr
  low-52.5='1. Bottom Half'
  52.5-high='2. Top Half'
  ;
  value density
  low-350 = '1. Low Density'
  350-high = '2. High Density'
  ;
  value babs
  low-15 = '1. Lowest'
  15-20 = '2. Low'
  20-25 = '3. High'
  25-high = '4. Highest'
  ;
run;

ods graphics off;
proc glm data=cdi;
  class CrimeRate ba_bs popDensity;
  format CrimeRate cr. ba_bs babs. popDensity density.;
  model inc_per_cap = CrimeRate|ba_bs|popDensity / solution; 
run;

ods graphics off;
proc glm data=cdi;
  class CrimeRate ba_bs popDensity;
  format CrimeRate cr. ba_bs babs. popDensity density.;
  model inc_per_cap = CrimeRate|ba_bs|popDensity / solution; 
  lsmeans crimeRate*ba_bs*popDensity / lines adjust=tukey;
run;

ods graphics off;
ods trace on;
proc mixed data=cdi;
  class CrimeRate ba_bs popDensity;
  format CrimeRate cr. ba_bs babs. popDensity density.;
  model inc_per_cap = CrimeRate|ba_bs|popDensity; 
  slice crimeRate*ba_bs*popDensity / sliceby=crimeRate lines 
                          adjust=tukey;
  ods select SliceLines;
run;

ods graphics off;
ods trace on;
proc mixed data=cdi;
  class CrimeRate ba_bs popDensity;
  format CrimeRate cr. ba_bs babs. popDensity density.;
  model inc_per_cap = CrimeRate|ba_bs|popDensity; 
  slice popDensity*crimeRate*ba_bs / 
                          sliceby=popDensity*crimeRate lines 
                          adjust=tukey;
  ods select SliceLines;
run;

ods graphics off;
ods trace on;
proc mixed data=cdi;
  class CrimeRate ba_bs popDensity;
  format CrimeRate cr. ba_bs babs. popDensity density.;
  model inc_per_cap = CrimeRate|ba_bs|popDensity; 
  slice popDensity*crimeRate*ba_bs / 
                          sliceby=popDensity*ba_bs lines 
                          adjust=tukey;
  ods select SliceLines;
run;

ods graphics off;
ods trace on;
proc mixed data=cdi;
  class CrimeRate ba_bs popDensity;
  format CrimeRate cr. ba_bs babs. popDensity density.;
  model inc_per_cap = CrimeRate|ba_bs|popDensity; 
  slice popDensity*crimeRate*ba_bs /  
                          sliceby=crimeRate*ba_bs lines 
                          adjust=tukey;
  ods select SliceLines;
run;

