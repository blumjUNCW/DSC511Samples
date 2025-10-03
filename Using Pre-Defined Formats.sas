libname IPEDS '~/IPEDS';

proc print data=ipeds.characteristics ;
run; 

proc print data=ipeds.characteristics label;
  format _numeric_ best12. _character_ $50.;
run;

proc contents data=ipeds.characteristics;
run;

options fmtsearch=(IPEDS); /**fmtsearch= sets libraries in which to search for format catalogs**/
proc format lib=IPEDS fmtlib;
run;

proc print data=ipeds.characteristics ;
  format fips best12.;
run;


proc format cntlin=ipeds.ipedsformats;/**cntlin is a data set that has format definitions**/
run;

proc print data=ipeds.characteristics ;
  format fips best12.;
run;

