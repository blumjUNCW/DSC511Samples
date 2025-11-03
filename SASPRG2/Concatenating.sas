libname pg2 '~/Courses/PG2V2/data';

proc contents data=sashelp.class varnum;
  ods select Position;
run;

proc contents data=pg2.class_new2 varnum;
  ods select position;
run;

data class_current;
    set sashelp.class pg2.class_new2;
    /**read all records from sashelp.class, once finished
        read all records from pg2.class_new2**/

    /**At compilation, the set of variables is determined
        by sequentially looking at attributes (metadata)
        for each table.

      Columns are aligned on name and type
        (same name + different types = error)
      Other attributes are set by first encounter (null is NOT
          an attribute)
        Length, Label, Format**/
run;

proc contents data=class_current varnum;
  ods select position;
run;

data class_currentB;
    set sashelp.class pg2.class_new2(rename=(student=name));
    /**rename= can be used for realignment of names**/
run;
proc contents data=class_currentB varnum;
  ods select position;
run;

data class_currentC;
    length name $10;
    set sashelp.class pg2.class_new2(rename=(student=name));
    /**rename= can be used for realignment of names**/
run;
proc contents data=class_currentC varnum;
  ods select position;
run;

proc contents data=pg2.np_2015 varnum;
  ods select position;
run;
proc contents data=pg2.np_2016 varnum;
  ods select position;
run;


data work.np_combine;
    set pg2.np_2016 pg2.np_2015;
    where month in (6,7,8); /**This applies to the tables all the way
                            through processing**/
    CampTotal = sum(of Camping:);
    drop Camping:;
    format campTotal comma15.;
run;

proc sort data=np_combine;
  by ParkCode;
run;


proc contents data=pg2.np_2014 varnum;
  ods select position;
run;
proc contents data=pg2.np_2015 varnum;
  ods select position;
run;
proc contents data=pg2.np_2016 varnum;
  ods select position;
run;

data work.np_combineB;
    set pg2.np_2014(rename=(Park=ParkCode Type=ParkType)) 
        pg2.np_2015 pg2.np_2016;
    where month in (6,7,8) and ParkType eq 'National Park'; 
    CampTotal = sum(of Camping:);
    drop Camping:;
    format campTotal comma15.;
run;

proc sort data=np_combineB;
  by ParkType ParkCode Year Month;
run;

proc sort data=np_combineB out=HowAboutThis;
  by ParkCode;
run;
