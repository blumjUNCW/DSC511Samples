libname SASData '~/SASData';

ods graphics off;
proc ttest data=SASData.DrugTrial1;
  paired endValue*baseline;
  /**PAIRED A*B; does A-B as a one-sample test**/
run;
/**Highly significant evidence that the drug is effective,
    reduction appears to be at least 18mmhg, on average 
    (with 95% confidence)**/

ods graphics off;
proc ttest data=sashelp.cars h0=-5;
    /**testing to see if the difference is more/less than 5
        with respect to how we are doing the difference in
        PAIRED**/
  paired mpg_city*mpg_highway;
  where type eq 'Truck';
run;

data diffs;
  set sashelp.cars;
  where type eq 'Truck';
  mpgDiff=mpg_city-mpg_highway;
run;

proc means data=diffs;
  var mpgDiff;
run;

ods graphics off;
proc ttest data=SASData.DrugTrial2;
  class group;
    /**for independent groups, the grouping variable
      goes in a class statement (can only have 2 levels)**/
  var reduction;
    /**var is the response variable**/
run;

ods graphics off;
proc ttest data=SASData.WeightLoss;
  class group;
  var loss;
run;


















