data work.cars; 
  infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
  input Make:$50. Model:$50. Type:$15. Origin:$6. Drivetrain:$6. MSRP:dollar. Invoice:dollar. 
          EngineSize Cylinders Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;

  if origin ne 'USA' then do;
      Weight = round(Weight*2.2,1);
      Wheelbase = round(Wheelbase/2.54,1);
      Length = round(Length/2.54,1);
  end;

  make = propcase(make);/**assign the updated value of Make back into Make**/

  if scan(lowcase(make),1) eq 'mercedes' then make = 'Mercedes-Benz';
  
  *test=find(type,'Ut');

  if find(type,'Ut') then type='SUV';
    /**Find(expression,'Substring') returns 0 if the substring is not present, which is equivalent to FALSE in IF
      If the substring is present, it returns the starting position of the first instance

      The Index function works in a very similar way**/
      

  label CityMPG = 'MPG City' HighwayMPG = 'MPG Highway';
  format MSRP Invoice dollar12. weight comma8.;
run;

proc sort data=work.cars out=CarsCompare nodupkey dupout=dups;
  by make model drivetrain;
run;

proc sort data=sashelp.cars out=CarsBase nodupkey dupout=dups2;
  by make model drivetrain;
run;

proc contents data=CarsCompare;
  ods select variables;
run;

proc contents data=CarsBase;
  ods select variables;
run;