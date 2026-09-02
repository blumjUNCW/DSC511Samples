/**the Cars data in the SASData repo is supposed to be the same as
  the Cars data in the SASHelp library, but it has some issues that
  we will fix... */

  libname SASData '~/SASData';

  data step1;
    set SASData.cars;

    /**Fix the casing issues with Make*/
    make = propcase(make);/**works for everything but BMW, GMC, MINI...*/

  run;

  data step1;
    set SASData.cars;

    /**Fix the casing issues with Make*/
    if upcase(make) in ('BMW', 'GMC', 'MINI') then make=upcase(make);
      else make = propcase(make);

    /*Fix the "Sport Ut" thing...*/
    *type = tranwrd(type,'Sport Ut','SUV');

    /*Be careful with some things...*/
    *if find(type,'Sport') then type = 'SUV';
    /*This is OK*/
    if find(type,'Ut') then type = 'SUV';

  run;


  
data step2;
  set SASData.cars;

  if upcase(make) in ('BMW', 'GMC', 'MINI') then make=upcase(make);
    else make = propcase(make);

  type = tranwrd(type,'Sport Ut','SUV');

  /**Put the units for weight, wheelbase, and length all
      in imperial units as they are in SASHelp.cars*/
  if origin ne 'USA' then do;
    weight = weight*2.2;
    wheelbase = wheelbase/2.54;
    length = length/2.54;
  end;/**lots of decimals there--could leave them and format... */
run;

data step2B;
  set SASData.cars;

  if upcase(make) in ('BMW', 'GMC', 'MINI') then make=upcase(make);
    else make = propcase(make);

  type = tranwrd(type,'Sport Ut','SUV');

  /**May want to round to the nearest whole number...*/
  if origin ne 'USA' then do;
    weight = round(weight*2.2,1);
    wheelbase = round(wheelbase/2.54,1);
    length = round(length/2.54,1);
  end;
run;

/**How can I check and see if this is the same as the SASHelp.cars table
  with a bit more efficiency?
  
PROC COMPARE can help you with this...*/

proc compare base=sashelp.cars compare=step2B;
    /**You get to pick two data sets for comparison--base and compare
    
      It compares the common variables--same name and type
        on each record in their current order*/

    /**You are expected to match column names and types and
        sort each data set on a primary key*/
run; 

proc sort data=step2b out=unique dupout=dups nodupkey;
  by model;
run;

proc sort data=sashelp.cars out=uniqueB dupout=dupsB nodupkey;
  by model drivetrain;
run;

proc sort data=sashelp.cars out=SASHelpVersion;
  by model drivetrain;
run;

proc sort data=step2b 
          out=MyVersion(rename=(MPGCity=MPG_City MPGHighway=MPG_Highway));
          /*rename=(old-name=new-name ...) can be used as a data set option
              to fix my naming issues*/
  by model drivetrain;
run;

proc compare base=SASHelpVersion compare=MyVersion;
run;/*model is problematic because of the spacing--see if you can get around
  that problem so we can solve any others...*/

/*remove the artifact in Model from the SASHelp version...*/
data HelpCars;
    set sashelp.cars;
    model = left(model);
run;

proc sort data=HelpCars;
  by make model drivetrain;/*I'll also preserve the sorting on make
                            just for ease of inspection...*/
run;
proc sort data=step2b 
          out=MyVersion(rename=(MPGCity=MPG_City MPGHighway=MPG_Highway));
          /*rename=(old-name=new-name ...) can be used as a data set option
              to fix my naming issues*/
  by make model drivetrain;
run;
proc compare base=HelpCars compare=MyVersion 
              out=comparison outall outnoequal;
    /**You can send the results to an OUT= data set 
      some modifiers:
      OUTALL -> outputs all records--each table and differences
      OUTNOEQUAL -> only sends out the record set if there is one comparison
                    that shows a difference across the variables*/
run;

/**Looks like I still have issues on Make and Model... */
data step3;
  set SASData.cars;

  if upcase(make) in ('BMW', 'GMC', 'MINI') then make=upcase(make);
    else make = propcase(make);

  if find(make,'Mercedes') then make = 'Mercedes-Benz';/*fix Mercedes stuff*/

  /*Fix the DR -> dr thing in Model...*/
  model = tranwrd(model,'DR','dr');

  type = tranwrd(type,'Sport Ut','SUV');

  /**May want to round to the nearest whole number...*/
  if origin ne 'USA' then do;
    weight = round(weight*2.2,1);
    wheelbase = round(wheelbase/2.54,1);
    length = round(length/2.54,1);
  end;

  rename MPGCity=MPG_City MPGHighway=MPG_Highway;
run;
proc sort data=step3 out=MyVersion;
  by make model drivetrain;
run;
proc compare base=HelpCars compare=MyVersion 
              out=comparison outall outnoequal;
run;

data step3NoRounding;
  set SASData.cars;

  if upcase(make) in ('BMW', 'GMC', 'MINI') then make=upcase(make);
    else make = propcase(make);

  if find(make,'Mercedes') then make = 'Mercedes-Benz';/*fix Mercedes stuff*/

  /*Fix the DR -> dr thing in Model...*/
  model = tranwrd(model,'DR','dr');

  type = tranwrd(type,'Sport Ut','SUV');

  /**May want to round to the nearest whole number...*/
  if origin ne 'USA' then do;
    weight = weight*2.2;
    wheelbase = wheelbase/2.54;
    length = length/2.54;
  end;

proc sort data=step3NoRounding out=MyVersion;
  by make model drivetrain;
run;
proc compare base=HelpCars compare=MyVersion 
              out=comparison outall outnoequal;
run;/**default method is exact... */

proc compare base=HelpCars compare=MyVersion 
              out=comparison outall outnoequal
              method=percent criterion=0.1;
              /**Percent difference is helpful,
                the default criterion is really precise, will likely set it */
run;