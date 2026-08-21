libname SASData '~/SASData';

/**PROC FREQ generates frequency tables and does some stats,
  like chi-square test for independence, but it can also be useful
  as a data exploration procedure...*/

proc freq data=SASData.cars;
  table make;
run;
/*freq treats each distinct value of a variable as a separate category,
 different casings of character values are different, and I can see in
 the table, that I have some inconsistent casing...**/

proc sort data=SASData.cars out=CarsSort;
  /**Sort allows you to sort data sets by any set of variables in BY,
    default is to replace original data set with sorted version--usually
    don't want that so we use OUT= to choose the destination for the
    sorted data */
  by make;
 run;

 proc sort data=SASData.cars out=CarsCheck nodupkey;
  /**NODUPKEY -- remove duplicates on the "key",
    the key is the set of BY variables*/
  by make;
 run;

proc means data=SASData.cars min q1 median q3 max;
   var length wheelbase weight;
run;