proc print data=ipeds.characteristics ;
  format fips best12.;
run; 

proc print data=ipeds.characteristics ;
  *format _numeric_ best12. _character_ $50.;
run;

proc contents data=ipeds.characteristics;
run;

proc format cntlin=ipeds.ipedsformats;/**cntlin is a data set that has format definitions**/
run;

proc print data=ipeds.characteristics ;
  format fips best12.;
run;

options fmtsearch=(IPEDS); /**fmtsearch= sets libraries in which to search for format catalogs**/

proc print data=ipeds.characteristics ;
  format fips best12.;
run;