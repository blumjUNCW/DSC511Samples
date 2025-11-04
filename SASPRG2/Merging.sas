libname pg2 '~/Courses/PG2V2/data';

data storm_damage;
  set pg2.storm_damage;
  Season=Year(date);/**the original storm_damage data set doesn't have a  
                      season, but we can make one...**/
  Name=upcase(scan(Event, -1));
      /**the name in the storm_final data corresponds to the last "word"
          in the event in storm_damage
        and we match casing**/
  format Date date9. Cost dollar16.;
  drop event;
run;

/**now that we have variables that will match records...**/
proc sort data=pg2.storm_final out=storm_final_sort;
  by Season Name;
run;
proc sort data=storm_damage;
  by Season Name;
run;/**sort both data sets by these**/

data damage_detail NoDamageInfo NoStormInfo;
  merge storm_final_sort(in=inFinal) storm_damage(in=inDamage);
      /**in= establishes a variable that is 1 if the current record
          contains a contribution from that table, 0 if not**/
  by Season Name;
  if inDamage and inFinal then output damage_detail;
    /** ^^^^^^^^^^^^^^^^^^^^^ is stating that we have a match
      --contribution from both data sets**/
    else if inFinal then output NoDamageInfo;
      else if inDamage then output NoStormInfo;
 
  keep Season Name BasinName MaxWindMPH MinPressure Cost;
run;

data Full Inner Left Right;
  merge storm_final_sort(in=inFinal) storm_damage(in=inDamage);
  by Season Name;
  output Full;
  if inDamage and inFinal then output Inner;
    /** ^^^^^^^^^^^^^^^^^^^^^ is stating that we have a match
      --contribution from both data sets**/
  if inFinal then output Left;
  if inDamage then output Right;
 
  *keep Season Name BasinName MaxWindMPH MinPressure Cost;
run;


proc sort data=pg2.np_codelookup out=work.codesort;
  by ParkCode;
run;

proc sort data=pg2.np_2016traffic out=work.traf2016Sort(rename=(code=parkCode));
  by Code month;
run;

data trafficStats;
  merge traf2016Sort codesort;
  by ParkCode;

  drop name_code;
run;

data trafficStats;
  merge traf2016Sort(in=inTraffic) codesort;
  by ParkCode;
  if inTraffic;

  drop name_code;
run;

proc sort data=pg2.np_2016 out=Sort2016;
  by ParkCode;
run;

proc sort data=pg2.np_codeLookup out=SortCode;
  by parkCode;
run;

data parkStats(keep=parkCode parkName Year Month DayVisits)
     parkOther(keep=parkCode parkName)
     unknownStats;
  merge Sort2016(in=inStats) SortCode(in=inCode);
  by parkCode;

  if instats and incode then output parkStats;
    else if inCode then output parkOther;
      else output unknownStats;
run;

/*Steps a and b*/
proc sort data=pg2.np_CodeLookup out=sortnames(keep=ParkName ParkCode);
  by ParkName;
run;

proc sort data=pg2.np_final out=sortfinal;
  by ParkName;
run;

data highuse(keep=ParkCode ParkName);
  merge sortfinal sortnames;
  by ParkName;
  if DayVisits ge 5000000;
  *where DayVisits ge 5000000;
run;

data highuseB(keep=ParkCode ParkName);
  merge sortfinal(in=inFinal where=(DayVisits ge 5000000))
        sortnames;
  by ParkName;
  if inFinal;
  *if DayVisits ge 5000000;
  *where DayVisits ge 5000000;
run;

/*Step c*/
proc sort data=pg2.np_species
        out=birds(keep=ParkCode Species_ID Scientific_Name Common_Names);
  by ParkCode Species_ID;
  where Category='Bird' and Abundance='Common';
run;

proc sort data=highuse;
  by ParkCode;
run;

data birdsLP;
  merge highuse(in=HighUse) birds;
  by parkCode;
  if HighUse;
run;


/**could progress the other way...**/
proc sort data=pg2.np_CodeLookup out=sortnames2(keep=ParkName ParkCode);
  by ParkCode;
run;

data one;
  merge birds(in=HasBirds) sortnames2;
  by ParkCode;
  if HasBirds;
run;

proc sort data=one;
  by ParkName;
run;

data highuseC;
  merge one sortfinal;
  by ParkName;
  if DayVisits ge 5000000;
  *where DayVisits ge 5000000;
run;
