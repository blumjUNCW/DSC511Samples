data work.cars; 
  infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
    /**DSD -> Delimiter Sensitive Data, invoking this does three things:
              1. Switches the default delimiter to a comma (but you can still change it as we did)
              2. Treats consecutive delimeters as containing a missing value
              3. Ignores delmiters in values embedded in quotes**/
  input Make:$50. Model:$50. Type:$15. Origin:$6. Drivetrain:$6. MSRP:dollar. Invoice:dollar. 
          EngineSize Cylinders Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
  format MSRP Invoice dollar12. weight comma8.;
run;

proc freq data=cars;
  table make type origin drivetrain;
/**need some clean up on make and type, others look ok**/
run;

proc means data=cars;
run;

proc univariate data=cars;
run;

proc means data=cars;
  var weight wheelbase length;
  class origin;
/**units for these are based on units from origin region**/
run;

data work.cars; 
  infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
  input Make:$50. Model:$50. Type:$15. Origin:$6. Drivetrain:$6. MSRP:dollar. Invoice:dollar. 
          EngineSize Cylinders Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;

  /**Put everything in Imperial units (pounds and inches)**/
  if origin ne 'USA' then do;
      Weight = Weight*2.2;/**Convert kg to lbs...**/
      Wheelbase = Wheelbase/2.54;
      Length = Length/2.54;/**Convert cm to in**/
  end;

  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
  format MSRP Invoice dollar12. weight comma8.;
run;


proc means data=cars;
  var weight wheelbase length;
  class origin;
/**units for these are based on units from origin region**/
run;

data work.cars; 
  infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
  input Make:$50. Model:$50. Type:$15. Origin:$6. Drivetrain:$6. MSRP:dollar. Invoice:dollar. 
          EngineSize Cylinders Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;

  if origin ne 'USA' then do;
      /**If I want to round to a certain precision, I can**/
      Weight = round(Weight*2.2,100);
      Wheelbase = round(Wheelbase/2.54,.1);
      Length = round(Length/2.54,.01);
      /**Round(numeric-expression,precision) -> precision is expressed with a 1 in the appropriate position**/
  end;

  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
  format MSRP Invoice dollar12. weight comma8.;
run;

data work.cars; 
  infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
  input Make:$50. Model:$50. Type:$15. Origin:$6. Drivetrain:$6. MSRP:dollar. Invoice:dollar. 
          EngineSize Cylinders Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;

  if origin ne 'USA' then do;
      Weight = round(Weight*2.2,100);
      Wheelbase = round(Wheelbase/2.54,.1);
      Length = round(Length/2.54,.01);
  end;

  if scan(lowcase(make),1) eq 'mercedes' then Merc=1;
    else Merc=0;

  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
  format MSRP Invoice dollar12. weight comma8.;
run;

