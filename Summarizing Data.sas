libname pg2 '~/Courses/PG2V2/data';

data zurich2017;
  set pg2.weather_zurich;

  *if _n_ eq 1 then TotalRain = 0;
  retain TotalRain 0;
  TotalRain=TotalRain+Rain_mm;
run;

data zurich2017;
  set pg2.weather_zurich;

  *if _n_ eq 1 then TotalRain = 0;
  retain TotalRain 0;
  TotalRain=sum(TotalRain,Rain_mm);
run;

data zurich2017;
  set pg2.weather_zurich;

  TotalRain+Rain_mm;
  /**Sum statement:
      a+b;

      a is variable, b is an expression

      a is automatically retained and intialized to zero
      a+b does the operation, ignoring missings, and stores back in a**/
run;

data totalTraffic;
    set pg2.np_yearlyTraffic;

    totTraffic+count;

    keep ParkName Location Count totTraffic;
    format totTraffic comma15.;
run;

data ParkTypeTraffic;
    set pg2.np_yearlyTraffic;

    where scan(ParkType,2) in ('Monument','Park');

    if scan(ParkType,2) eq 'Monument' then MonumentTraffic+count;
      else ParkTraffic+count;
    
    format MonumentTraffic ParkTraffic comma15.;
run;

/**If I really just want the grand totals...**/
data ParkTypeTraffic;
    set pg2.np_yearlyTraffic end=finish;
        /**end=variable is an indicator for the final record--1 on final record, 0 otherwise**/

    where scan(ParkType,2) in ('Monument','Park');

    if scan(ParkType,2) eq 'Monument' then MonumentTraffic+count;
      else ParkTraffic+count;

    if finish then output;
    
    format MonumentTraffic ParkTraffic comma15.;
    keep MonumentTraffic ParkTraffic;
run;

proc means data=pg2.np_yearlytraffic sum;
    where scan(ParkType,2) in ('Monument','Park');
    class ParkType;
    var count;
    ods output summary=TrafficSums;
run;
  
data cuy_maxTraffic;
  set pg2.np_monthlytraffic;
  where scan(ParkName,1) eq 'Cuyahoga';

  retain TrafficMax 0 MonthMax LocationMax;

  if count gt TrafficMax then do;/**if the new one is the largest...**/
    TrafficMax = count;
    MonthMax = month;
    LocationMax = location;
  end;
  
  format count TrafficMax comma12.;
  keep Location Month Count TrafficMax MonthMax LocationMax;
run;


proc sort data=pg2.storm_2017 out=storm2017_sort;
  by Basin descending MaxWindMPH;
run;

data storm2017_max;
  set storm2017_sort;
  by Basin;
  where first.Basin eq 1;
      /**First. and Last. variables are created during execution,
        they are not part of the input table, which is what WHERE 
        always references**/
  StormLength=EndDate-StartDate;
  MaxWindKM=MaxWindMPH*1.60934;
run;

data storm2017_max;
  set storm2017_sort;
  by Basin;
  if first.Basin eq 1;
      /**subsetting IF (IF with no THEN)--
      process the remaining statements 
      (and implicit output, if active) when
      the statement is true**/
  StormLength=EndDate-StartDate;
  MaxWindKM=MaxWindMPH*1.60934;
run;


proc contents data=pg2.weather_houston;
run;

data houston_monthly;
  set pg2.weather_houston;
  by Month;

  if first.Month=1 then MTDRain=0;
  MTDRain+DailyRain;
  if last.month then output;

  keep Date Month DailyRain MTDRain;
run;      



proc sort data=pg2.np_yearlyTraffic   
          out=sortedTraffic(keep=ParkType ParkName 
                                      Location Count);
   by parkType parkName;
run;

data TypeTraffic;
    set sortedTraffic;
    by parkType;

    if first.parkType then TypeCount = 0; /**reset count for each different type**/

    TypeCount+Count;/**add to my accumulator**/

    if last.parkType then output;/**at the end of each type, output the result**/

    format TypeCount comma12.;
    keep ParkType TypeCount;
run; 

proc sort data=sashelp.shoes out=shoeSort;
  by region product;
run;

data profitSummary;
  set shoeSort;
  by region product;

  if first.product then TotalProfit = 0;

  totalProfit+(sales-returns);

  if last.product then output;
  
  keep Region Product TotalProfit;
  format TotalProfit dollar15.;
run;


/**redo the one below to get the same set of 
    max variables for all parks, of any type**/
data cuy_maxTraffic;
  set pg2.np_monthlytraffic;
  where scan(ParkName,1) eq 'Cuyahoga';

  retain TrafficMax 0 MonthMax LocationMax;

  if count gt TrafficMax then do;/**if the new one is the largest...**/
    TrafficMax = count;
    MonthMax = month;
    LocationMax = location;
  end;
  
  format count TrafficMax comma12.;
  keep Location Month Count TrafficMax MonthMax LocationMax;
run;