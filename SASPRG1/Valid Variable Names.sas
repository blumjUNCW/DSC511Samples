libname try2 xlsx '/export/viya/homes/blumj@uncw.edu/Test.xlsx';

proc print data=try2.sheet1;
  var First Name;
run;

proc print data=try2.sheet1;
  var 'First Name'n;
run;
/*by default, VALIDVARNAME=ANY
  still has 32 characters max
  no restrictions on characters
  must reference with 'name-of-variable'n or "name-of-variable"n
  */
  