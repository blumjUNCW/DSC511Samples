libname SASData '~/SASData';

proc means data=sasdata.index n q1 median q3 mean std;
 var r1000value r1000growth;
run;

proc means data=sasdata.index n q1 median q3 mean std;
 var r1000:;
    /** name: references any variable that starts with
        the prefix characters and has any other characters
          (including none) after**/
run;

proc means data=sasdata.index n q1 median q3 mean std nonobs;
  class dt;
  format dt monname.;
  var r1000:;
run;