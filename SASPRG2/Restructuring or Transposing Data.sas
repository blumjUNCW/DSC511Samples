libname pg2 '~/Courses/PG2V2/data';

data class_wide;
  set pg2.class_test_narrow;
  by Name;
  *retain Name Math Reading;
  keep Name Math Reading;
  if TestSubject="Math" then Math=TestScore;
  else if TestSubject="Reading" then Reading=TestScore;
run;


data class_wide;
  set pg2.class_test_narrow;
  by Name;
  retain Math Reading;
  
  if TestSubject="Math" then Math=TestScore;
    else if TestSubject="Reading" then Reading=TestScore;
      /**set a new variable corresponding to the score for
          each different test type**/

  if last.name then output; /**output when complete for each student**/

  keep Name Math Reading;
run;


data work.camping_narrow(keep=ParkName CampType CampCount);
  set pg2.np_2017Camping;

  length campType $12;
  CampType='Tent'; CampCount=Tent; output;/**make a type and count variable and output...***/
  CampType='RV'; CampCount=RV; output;  
  CampType='Backcountry'; CampCount=Backcountry; output; /**...for each of the three camping types**/
  
  format CampCount comma12.;
run;


data work.camping_narrowB(keep=ParkName CampType CampCount);
  set pg2.np_2017Camping;

  CampType='Backcountry'; CampCount=Backcountry; output;
  CampType='RV'; CampCount=RV; output;  
  CampType='Tent'; CampCount=Tent; output;
  
  format CampCount comma12.;
run;

data np_2016CampWide;
  set pg2.np_2016Camping;
  by ParkName;

  retain Tent Backcountry RV;

  select(CampType);
    when('Tent') Tent=CampCount;
    when('RV') RV=CampCount;
    when('Backcountry') BackCountry=CampCount;
  end;

  if last.parkName then output;

  keep ParkName Tent RV BackCountry;
run;

/**Default Transpose**/
proc transpose data=pg2.np_2017Camping;
run;/**columns to rows or rows to columns--numeric variables only, by default**/

proc transpose data=pg2.np_2017Camping;
  var _all_;
run;/**transpose outputs a separate data set even if you don't say out= **/

/**Use Transpose to take np_2016camping to one record per park**/

proc transpose data=pg2.np_2016Camping out=Camp2016T;
  by ParkName; /**groups of rows are identified by the ParkName--transposition occurs within each group**/
  var CampCount; /**values to change (column to row) are in CampCount**/
run;

proc transpose data=pg2.np_2016Camping out=Camp2016T2(drop=_name_);
  by ParkName; 
  var CampCount; 
  id CampType; /**if you have a variable that identifies the rows in 
              each group uniquely, you can use it as a creator for 
              the transposed variable name with the ID statement**/
run;

proc transpose data=camp2016T2 out=GoBack;
  by ParkName;
  var Tent RV BackCountry;
run;

proc transpose data=pg2.np_2017Camping 
               out=Camp2017T(rename=(_name_=CampType col1=CampCount));
  by ParkName;
  var Tent RV BackCountry;
run;
  


  