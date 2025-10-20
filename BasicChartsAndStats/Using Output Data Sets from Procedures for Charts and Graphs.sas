/**Suppose we want to chart a quantitative statistic other than mean, median, or sum (the ones you get in SGPLOT)...**/

/**I want a chart of third quartiles of MPG City across origin for cars data**/
ods trace on;
proc means data=sashelp.cars q3;
  class origin;/**your charting (and group) variable is the stratification variable in MEANS**/
  var mpg_city;
  ods output summary=ThirdQ;
run;

proc sgplot data=ThirdQ;
  hbar origin / response=mpg_city_q3 stat=median;
  /**use that summary stat as the response
    it's reduced to one summary stat, so the STAT= option is irrelevant**/
run;

proc means data=sashelp.cars q3;
  class origin type;/**your charting (and group) variable is the stratification variable in MEANS**/
  var mpg_city;
  ods output summary=ThirdQ;
run;

proc sgplot data=ThirdQ;
  hbar origin / response=mpg_city_q3 group=type groupdisplay=cluster;
  /**If you stratify by a second variable, it can be used as the group
      variable**/
run;

proc sgplot data=ThirdQ;
  hbar type / response=mpg_city_q3 group=origin groupdisplay=cluster;
  /**If you stratify by a second variable, it can be used as the group
      variable**/
run;

proc means data=sashelp.cars q3;
  class origin;
  var mpg_city;
  output out=Q3Info;
  /**OUTPUT OUT=data-set-of info...
    ignores the stat-keywords listed in the PROC MEANS statement**/
run;


proc means data=sashelp.cars noprint;
  class origin;
  var mpg_city;
  output out=Q3Info q1=FirstQ q3=ThirdQ;
  /**can make requests keyword=varname...**/
run;/**why do I get a blank orgin (and _type_ of 0)?**/

proc means data=sashelp.cars q3;
  class origin type;
  var mpg_city;
  ways 0 1 2; /**ways N; N->number of class variables to use in the stratification**/
  ods output summary=ThirdQ;
run;


proc means data=sashelp.cars noprint;
  class origin;
  var mpg_city;
  ways 1;/**OUTPUT does respect a WAYS request, if present**/
  output out=Q3Info q1=FirstQ q3=ThirdQ;
run;

proc sgplot data=Q3Info;
  hbar origin / response=ThirdQ;
  /**use that summary stat as the response**/
run;

proc sgplot data=sashelp.cars;
  hbar origin / group=type groupdisplay=cluster stat=percent;
  where type ne 'Hybrid';
run;

proc freq data=sashelp.cars;
  table origin*type;
  where type ne 'Hybrid';
  ods output crosstabfreqs=Percents;
run;

proc sgplot data=percents;
  hbar origin / group=type response=rowpercent groupdisplay=cluster;
run;

proc freq data=sashelp.cars;
  table origin*type;
  where type ne 'Hybrid';
  ods output 
    crosstabfreqs=Percents(keep=origin type rowpercent _type_ where=(_type_ eq '11'));
run;

