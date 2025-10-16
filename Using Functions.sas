libname pg2 '~/Courses/PG2V2/data';

data quiz_summary;
  set pg2.class_quiz;
  
  Name = upcase(Name);
  
  Mean1=mean(Quiz1, Quiz2, Quiz3, Quiz4, Quiz5);
  /* Numbered Range: col1-coln where n is a sequential number */ 
  Mean2=mean(of Quiz1-Quiz5);
  /* Name Prefix: all columns that begin with the specified character string */ 
  Mean3=mean(of Q:);
  Mean4=mean(of Quiz1--Quiz5);
      /** varA--varB is all variables between varA and varB in their
          column order (inclusive)**/
run;



/* Step 1 */
data quiz_report;
    set pg2.class_quiz;
  if Name in("Barbara", "James") then do;
    Quiz1=.;
    Quiz2=.;
    Quiz3=.;
    Quiz4=.;
    Quiz5=.;
  end;
run;

/* Step 4 */
data quiz_report;
    set pg2.class_quiz;
  if Name in("Barbara", "James") then call missing(of Quiz:);
run;



data wind_avg;
  set pg2.storm_top4_wide;
  WindAvg1 = round(mean(of Wind1-Wind4),.1); 
  WindAvg2 = mean(of Wind1-Wind4); 
  format windAvg2 5.1;

  Diff=WindAvg1-WindAvg2;
  /**Rounding is not the same as formatting,
      rounding changes the value,
      formatting only changes the display**/

  *WindAvg1 = round(WindAvg1,.1);
      /**round(expression,precision) -- precision is expressed
          with a 1 in the place of desired precision
          e.g. 0.01 is nearest hundredth**/
run;


data storm_length;
  set pg2.storm_final(obs=10);

  Weeks = intck('week', StartDate, EndDate);
    /**intck counts time intervals, default separator is
        "discrete"--traditional boundary
            Saturday/Sunday for weeks
            Last day/first day of month
            Dec 31/Jan 1 for year**/
  WeeksB = intck('week', StartDate, EndDate,'c');
    /**continuous--counts number of days and divides...**/
    
  days = EndDate - StartDate;

  keep Season Name StartDate Enddate StormLength days Weeks:;
  format StartDate EndDate weekdate.;
run;


proc sort data=pg2.storm_final out=StormSort;
  by basin startDate;
  where season eq 2017;
run;

/**use the most recent year's storms to project a 
    first-storm and last-storm start date...
 
  first-storm projected date is the same as the first storm
    moved into the next year
  same idea for last storm**/

data projections;
  set StormSort;
  
  projDate1 = intnx('year',StartDate,1);
  projDate8 = intnx('year',StartDate,8);

  projDate1E = intnx('year',StartDate,1,'end');
  projDate8E = intnx('year',StartDate,8,'end');

  projDate1S = intnx('year',StartDate,1,'same');
  projDate8S = intnx('year',StartDate,8,'same');

  format proj: weekdate.;
  keep startDate proj:;
run;


data projections;
  set StormSort;
  by basin;
  retain ProjFirst;
  
  if first.basin then ProjFirst = intnx('year',StartDate,1,'same');
  if last.basin then do;
      projLast = intnx('year',StartDate,1,'same');
      output;
  end;

  format proj: weekdate.;
  keep basin proj:;
run;

/**make the projected earliest first storm three weeks prior to the 
    current first storm in a basin,
    projected latest three weeks after the last storm**/
data projections;
  set StormSort;
  by basin;
  retain ProjFirst;
  
  if first.basin then ProjFirst = intnx('week',intnx('year',StartDate,1,'same'),-3,'same');
  if last.basin then do;
      projLast = intnx('week',intnx('year',StartDate,1,'same'),3,'same');
      output;
  end;

  format proj: weekdate.;
  keep basin proj:;
run;


proc print data=pg2.np_lodging(obs=10);
  where CL2010>0;
run;

data stays;
  set pg2.np_lodging;

  stayAvg = round(mean(of CL:),1);

  if stayAvg gt 0;

  stay1 = largest(1,of CL:);
  stay2 = largest(2,of CL:);
  stay3 = largest(3,of CL:);

  format Stay: comma11.;
  keep Park Stay:;
run;


data staysB;
  set pg2.np_lodging;

  array stay(3);/**creates stay1 stay2 stay3 as data
                  set variables but you can reference
                  with an index: stay(k)**/
  do i = 1 to 3;
    stay(i) = largest(i,of CL:);
  end;

  format Stay: comma11.;
  keep Park Stay:;
run;


data rainsummary;
  set pg2.np_hourlyrain;
  by Month;

  if first.Month=1 then MonthlyRainTotal=0;
  MonthlyRainTotal+Rain;
  if last.Month;
  date = datepart(datetime);
  MonthEnd = intnx('month',date,0,'end');

  format date MonthEnd mmddyy10.;
  keep StationName MonthlyRainTotal Date MonthEnd;
run;

proc freq data=pg2.weather_japan;
  table Location Station;
run;


data weather_japan_clean;
    set pg2.weather_japan;
    NewLocation = compbl(Location);
    NewStation = compress(Station);
      /**default compression is all spaces...**/
    NewStationB = compress(Station,'-');
      /**you can choose characters to compress...***/
    NewStationC = compress(Station,' -');
      /**it's treated as a list of individual characters if
          more that one is supplied**/
run;



data weather_japan_clean;
  set pg2.weather_japan;
  Location = compbl(Location);
  CityA = scan(Location, 1, ',');
  CityB = propcase(CityA, ' '); 
  CityC = propcase(CityA);
  Prefecture=scan(Location, 2, ',');
  *putlog Prefecture $quote20.;
  if Prefecture=" Tokyo";
run;

data weather_japan_clean;
  set pg2.weather_japan;
  Location = compbl(Location);
  CityA = scan(Location, 1, ',');
  CityB = propcase(CityA, ' '); 
  CityC = propcase(CityA);
  Prefecture=scan(Location, 2);
    /**space is in the default delimiter set,
        but so is dash - **/
  *putlog Prefecture $quote20.;
  *if Prefecture="Tokyo";
run;

data weather_japan_clean;
  set pg2.weather_japan;
  Location = compbl(Location);
  CityA = scan(Location, 1, ',');
  CityB = propcase(CityA, ' '); 
  CityC = propcase(CityA);
  Prefecture=scan(Location, 2, ' ,');
  *putlog Prefecture $quote20.;
  if Prefecture="Tokyo";
run;

data weather_japan_clean;
  set pg2.weather_japan;
  Location = compbl(Location);
  CityA = scan(Location, 1, ',');
  CityB = propcase(CityA, ' '); 
  CityC = propcase(CityA);
  Prefecture=left(scan(Location, 2, ','));
  *putlog Prefecture $quote20.;
  if Prefecture="Tokyo";
run;
