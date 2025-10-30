libname pg2 '~/Courses/PG2V2/data';

data work.stocks;
    set pg2.stocks;
    CloseOpenDiff=Close-Open;
    HighLowDiff=High-Low;
    format volume comma18. CloseOpenDiff HighLowDiff dollar12.2
          date monyy7.;
run;

proc means data=stocks maxdec=0 nonobs mean min max;
    class Stock Date;
    var Open; 
    format date year4.; 
run;


proc format;
    value $regfmt 
      'C'='Complete'
      'I'='Incomplete'
      ;
    *modify the following VALUE statement;
    value hrange
      50-57 = 'Below Average'
      58-60 = 'Average'
      61-70 = 'Above Average'
      ;/**applies to whole numbers between 50 and 70,
        anything else is unformatted**/
    value hrangeB
      50-<58 = 'Below Average'
      58-60 = 'Average'
      60<-70 = 'Above Average'
      ;
    value hrangeC
      low-<58 = 'Below Average'
      58-60 = 'Average'
      60<-high = 'Above Average'
      ;
run;

proc print data=pg2.class_birthdate noobs;
    where Age=12;
    var Name Registration Height;
    *add to the following FORMAT statement;
    format Registration $regfmt. height hrangeB.;
run;


proc format;
    value $region 
      'NA'='Atlantic'
      'WP','EP','SP'='Pacific'
      'NI','SI'='Indian'
      ' '='Missing'
      other='Unknown'
      ;
run;

data storm_summary;
    set pg2.storm_summary;
    Basin=upcase(Basin);
    *Delete the IF-THEN/ELSE statements and replace them with an assignment statement;
    if Basin='NA' then BasinGroup='Atlantic';
      else if Basin in ('WP','EP','SP') then BasinGroup='Pacific';
      else if Basin in ('NI','SI') then BasinGroup='Indian';
      else if Basin=' ' then BasinGroup='Missing';
      else BasinGroup='Unknown';
run;

data storm_summaryB;
    set pg2.storm_summary;
    Basin=upcase(Basin);
    BasinGroup = put(Basin,$region.);
run;

proc means data=storm_summaryB maxdec=1 missing;
  class BasinGroup;
  var MaxWindMPH MinPressure;
run;

proc format;
  value decade
    '01JAN2000'd-'31DEC2009'd = '2000-2009'
    '01JAN2010'd-'31DEC2017'd = '2010-2017'
    '01JAN2018'd-'31MAR2018'd = '1st Quarter 2018'
    '01APR2018'd-high = [mmddyy10.]
    ;
run;

title1 'Precipitation and Snowfall';
title2 'Note: Amounts shown in inches';
proc means data=pg2.np_weather maxdec=2 sum mean nonobs;
    where Prcp > 0 or Snow > 0;
    var Prcp Snow;
    class Date Name;
    format date decade.;
run;
title;

data sbdata;
    /**Every data set used to define a format must have three variables
        with controlled attributes:
        1. FmtName -- Names the format (is a character variable), 
                      includes the $ at the start for character formats
        2. Start -- Defines the starting value of a format range 
                    numeric or character, usually character to accomodate
                    all possible values usable in a range
        3. Label -- Value to be displayed for a given format range

        End is optional, if it isn't present End=Start**/
                      
    retain FmtName '$sbfmt';
    set pg2.storm_subbasincodes(rename=(Sub_Basin=Start 
                                        SubBasin_Name=Label));
  
    keep Start Label FmtName;
run;

proc format cntlin=sbdata;
    /**cntlin -- read in a "control" data set to define formats**/
run;

proc format fmtlib library=work;
run;

proc print data=pg2.storm_detail(obs=5);
  format sub_basin $sbfmt.;
run;


/*Create the CATFMT format for storm categories*/
data catdata;
    retain FmtName "catfmt";
    set pg2.storm_categories(rename=(Low=Start 
                                     High=End
                                     Category=Label));
    keep FmtName Start End Label;
run;

proc format cntlin=catdata;
run;
proc format fmtlib library=work;
run;

proc print data=pg2.storm_detail(obs=100);
  format sub_basin $sbfmt. wind catfmt.;
run;

proc freq data=pg2.storm_detail;
  table wind*sub_basin;
  format sub_basin $sbfmt. wind catfmt.;
run;



proc format cntlout=regionFormat;/**can name a data set
                      that has the format information**/
    value $region 
      'NA'='Atlantic'
      'WP','EP','SP'='Pacific'
      'NI','SI'='Indian'
      ' '='Missing'
      other='Unknown'
      ;
run;

proc format cntlin=regionFormat;
run;

libname dummy '~/Demos';
proc format library=dummy;/**can send to a catalog in a library
                        where I have write access--catalog is always
                        named formats.sas7bcat**/
    value $region 
      'NA'='Atlantic'
      'WP','EP','SP'='Pacific'
      'NI','SI'='Indian'
      ' '='Missing'
      other='Unknown'
      ;
run;
proc format fmtlib library=dummy;
run;

options fmtsearch=(dummy);