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
  
