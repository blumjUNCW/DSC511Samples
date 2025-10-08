libname pg2 '~/Courses/PG2V2/data';

data forecast;
  set sashelp.shoes;
  Year=1;
  ProjectedSales=Sales*1.05;/**5% increase**/
  putlog Year= ProjectedSales= _N_=;
  Year=2;
  ProjectedSales=ProjectedSales*1.05;
  ProjectedSalesB=Sales*1.05**2;
  putlog Year= ProjectedSales= ProjectedSalesB= _N_=;
  Year=3;
  ProjectedSales=ProjectedSales*1.05;
  ProjectedSalesB=Sales*1.05**3;
  putlog Year= ProjectedSales= ProjectedSalesB= _N_=;
  /**output effectively occurs here, only the projection
    for year 3 goes to the final data set**/

  keep Region Product Subsidiary Year ProjectedSales;
  format ProjectedSales dollar10.;
run;

data forecast;
  set sashelp.shoes;
  Year=1;
  ProjectedSales=Sales*1.05;/**5% increase**/
  output;/**output a projection each time it is made...***/
  Year=2;
  ProjectedSales=ProjectedSales*1.05;
  output;/**here also...**/
  Year=3;
  ProjectedSales=ProjectedSales*1.05;
  output; /**need this one also--any explicit output statement anywhere
      in a DATA step turns off all implicit output
        This occurs during compilation**/
  keep Region Product Subsidiary Year ProjectedSales;
  format ProjectedSales dollar10.;
run;

data OK ReallyBad;
  set sashelp.heart;
  if chol_status eq 'Really Bad' then output ReallyBad;
    /**this if is never true, but there is still no implicit output**/
run;

data monument park other;
  set pg2.np_yearlytraffic;

  if ParkType eq 'National Monument' then output Monument;
    else if ParkType eq 'National Park' then output Park;
        else output other;

run;

data monument park other;
  set pg2.np_yearlytraffic;

  if find(ParkType,'Monument') ne 0 then output Monument;
    else if find(ParkType,'Park') then output Park;
        else output other;
  /**Find(expression,target)  searches for the target string  
    in the expression and returns the first position where the
    target is found. If it's not found, it returns 0

    the Index function works in a similar way**/

run;

data monument park other;
  set pg2.np_yearlytraffic;

  if scan(ParkType,2) eq 'Monument' then output Monument;
    else if scan(ParkType,2) eq 'Park' then output Park;
        else output other;

  /**scan(expression,word) picks the word from the given position in
    the string based on a default set of delimiters (which you can change)**/

run;


data monument(drop=ParkType) park(drop=ParkType) other;
  set pg2.np_yearlytraffic(drop=region);

  if scan(ParkType,2) eq 'Monument' then output Monument;
    else if scan(ParkType,2) eq 'Park' then output Park;
        else output other;
  *drop region;
run;


data camping(keep=ParkName Month DayVisits CampTotal)
     lodging(keep=ParkName Month DayVisits LodgingOther);
  set pg2.np_2017;
  
  CampTotal = sum(of camping:); /**sum(arg1,arg2,...) or sum(of varlist) adds up columns, ignoring missings**/

  if camptotal gt 0 then output camping;
  if lodgingOther gt 0 then output lodging;
run;

/**rewrite this replacing the if-then-else with a select block**/
data monument(drop=ParkType) park(drop=ParkType) other;
  set pg2.np_yearlytraffic(drop=region);

  if scan(ParkType,2) eq 'Monument' then output Monument;
    else if scan(ParkType,2) eq 'Park' then output Park;
        else output other;
  *drop region;
run;

data monument(drop=ParkType) park(drop=ParkType) other;
  set pg2.np_yearlytraffic(drop=region);

  select(scan(ParkType,2));
    when('Monument') output Monument;
    when('Park') output Park;
    otherwise output other;
  end;
  *drop region;
run;


