libname IPEDS '~/IPEDS';
options fmtsearch=(IPEDS);
libname SASData '~/SASData';

/**Exercise 1**/
proc sql;
  create table Exercise1 as 
    select Event, BasinName, StartDate, EndDate, MaxWindMPH, cost format=dollar18.
    from SASData.Storm_Damage as damage inner join
           SASData.Storm_Final as final
              on upcase(scan(Event, -1)) eq Name  
                /**get the equivalent name from Event in Damage, match to Name in Final**/
                  and Year(date) eq Season
                  /**and make an equivalent to Season in Final from Date in Damage**/
  ;
quit;

/**Exercise 2**/
proc sql;
  create table Exercise2 as 
    select Event, BasinName, StartDate, EndDate, MaxWindMPH, cost format=dollar18.
    from SASData.Storm_Damage as damage inner join
           SASData.Storm_Final as final
              on upcase(scan(Event, -1)) eq Name  
                  and Year(date) eq Season
    order by Season desc, cost desc
  ;
quit;

proc sql;
  create table Exercise3 as 
    select np_2015.ParkCode, np_2015.Region, np_2015.State, np_2015.Month, 
            np_2014.DayVisits as Vis2014 label="Visits: 2014",
            np_2015.DayVisits as Vis2015 label="2015",
            np_2016.DayVisits as Vis2016 label="2016",
            Vis2014+Vis2015+Vis2016 as VisTot label='Total Visits'
    from (SASData.np_2014 inner join SASData.np_2015 
              on Park eq ParkCode and np_2014.month eq np_2015.month)
            inner join SASData.np_2016 
              on np_2015.ParkCode eq np_2016.ParkCode 
                    and np_2015.month eq np_2016.month
    order by month, np_2015.ParkCode;
quit;

proc sql;
  create table Exercise4 as 
    select np_2015.ParkCode,  
            sum(np_2014.DayVisits) as Vis2014 label="Visits: 2014" format=comma18.,
            sum(np_2015.DayVisits) as Vis2015 label="2015" format=comma18.,
            sum(np_2016.DayVisits) as Vis2016 label="2016" format=comma18.,
            calculated Vis2014 + calculated Vis2015 + calculated Vis2016
                 as VisTot label='Total Visits' format=comma18.
    from (SASData.np_2014 inner join SASData.np_2015 
              on Park eq ParkCode and np_2014.month eq np_2015.month)
            inner join SASData.np_2016 
              on np_2015.ParkCode eq np_2016.ParkCode 
                    and np_2015.month eq np_2016.month
    group by np_2015.ParkCode
  ;
quit;

proc sql;
  /*create table Exercise5 as */
    select np_2015.ParkCode,  
            sum(np_2014.DayVisits) as Vis2014 label="Visits: 2014" format=comma18.,
            sum(np_2015.DayVisits) as Vis2015 label="2015" format=comma18.,
            sum(np_2016.DayVisits) as Vis2016 label="2016" format=comma18.,
            calculated Vis2014 + calculated Vis2015 + calculated Vis2016
                 as VisTot label='Total Visits' format=comma18.
    from (SASData.np_2014 inner join SASData.np_2015 
              on Park eq ParkCode and np_2014.month eq np_2015.month)
            inner join SASData.np_2016 
              on np_2015.ParkCode eq np_2016.ParkCode 
                    and np_2015.month eq np_2016.month
    group by np_2015.ParkCode
    having VisTot ge 15000000
    order by VisTot desc
  ;
quit;