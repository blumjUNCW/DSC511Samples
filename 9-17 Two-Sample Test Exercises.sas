ods rtf file='~/Output/MPG Test.rtf'; 
/**ODS RTF opens a rich text format destination in the folder with
      the name you give... */
ods trace on;
ods noproctitle;
ods graphics off;
title 'MPG Highway/City Difference';
footnote 'All Vehicles';proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
run;

footnote 'Trucks and SUVs Only';
proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
  where type in ('Truck','SUV');
run;
ods rtf close;/**..all output generated from there to the close statement
goes to the file*/

ods pdf file='~/Output/MPG Test.pdf'; 
ods trace on;
ods noproctitle;
ods graphics off;
title 'MPG Highway/City Difference';
footnote 'All Vehicles';proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
run;

footnote 'Trucks and SUVs Only';
proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
  where type in ('Truck','SUV');
run;
ods pdf close;

ods html file='~/Output/MPG Test.html'; 
ods trace on;
ods noproctitle;
ods graphics off;
title 'MPG Highway/City Difference';
footnote 'All Vehicles';proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
run;

footnote 'Trucks and SUVs Only';
proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
  where type in ('Truck','SUV');
run;
ods html close;

ods word file='~/Output/MPG Test.docx'; 
options nodate nonumber; /**turn off the header information*/
ods noproctitle;
ods graphics off;

title 'MPG Highway/City Difference';
footnote 'All Vehicles';proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
run;
proc odstext;
  p ' ';
  p 'The data shows the highway MPG exceeds city MPG by more than 5' / style=[fontsize=14pt textalign=center];
  p 'The 95% confidence interval goes from 6.6 to 7 MPG' / style=[fontsize=12pt textalign=center];
run;

footnote 'Trucks and SUVs Only';
proc ttest data=sashelp.cars h0=5;
  paired mpg_highway*mpg_city;
  where type in ('Truck','SUV');
run;
proc odstext;
  p ' ';
  p 'The data shows the highway MPG does not exceed city MPG by more than 5 for trucks and SUVs' 
      / style=[fontsize=14pt textalign=center];
run;
ods word close;


proc freq data=sasdata.environment;
  weight count;
  table HigherTaxes*CutLivingStandards / agree;
run;
