/**At times, it can be helpful to use a SELECT block/group for conditioning */

libname SASData '~/SASData';

data cdi;
  set sasdata.cdi;

  length RegionName $15;

  if region eq 1 then RegionName = 'Northeast';
    else if region eq 2 then RegionName = 'North Central';
      else if region eq 3 then RegionName = 'South';
        else RegionName = 'West';
run;


data cdi2;
  set sasdata.cdi;

  length RegionName $15;
  select(region);
    when(1) RegionName = 'Northeast';
    when(2) RegionName = 'North Central';
    when(3) RegionName = 'South';
    otherwise RegionName = 'West';
  end;

run;


data cdi3;
  set sasdata.cdi;

  length RegionName $15;
  select(region);
    when(1,2) RegionName = 'North';
    /*lists are legal in the WHEN*/
    when(3) RegionName = 'South';
    otherwise RegionName = 'West';
  end;

run;

data cdi4;
  set sasdata.cdi;

  length RegionName $15;
  select(region);
    when(1,2) RegionName = 'North';
    when(3) RegionName = 'South';
  end;
  /*an OTHERWISE is required unless...**/
run;

data cdi5;
  set sasdata.cdi;

  length RegionName $15;
  select(region);
    when(1,2) RegionName = 'North';
    when(3) RegionName = 'South';
    when(4) RegionName = 'West';
    /**...the set of WHENs covers all possibilities*/
  end;

run;


data heart;
  set sashelp.heart;

  select (scan(smoking_status,1));
    when('Non') smokeCat = 1;
    when('Light') smokeCat = 2;
    when('Moderate') smokeCat = 3;
    when('Heavy') smokeCat = 4;
    when('Very') smokeCat = 5;
    otherwise smokeCat = .;
  end;
run;

proc format;
    value regFormat
       1 = 'Northeast'
       2 = 'North Central'
       3 = 'South'
       4 = 'West'
        ;
run;
/*used for display, but can also do the conditional logic...*/

data FMTConditioning;
  set sasdata.cdi;

  RegionName = put(region,regFormat.);
    /**PUT converts numeric to character using the
        specified format */
run;

data try;
  set sashelp.stocks;

  dateChar = put(date,best12.);
  dateChar2 = put(date,weekdate.);
run;

  