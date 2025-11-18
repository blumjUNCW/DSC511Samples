ods graphics off;
proc reg data=sashelp.heart;
  model systolic = weight height;
  *ods exclude NObs;
run;

ods trace on;
ods graphics off;
proc glm data=sashelp.heart;
  model systolic = weight height;
run;

ods graphics off;
proc glm data=sashelp.heart;
  model systolic = weight height;
  ods select 'Type III Model ANOVA';
run;

ods graphics off;
proc reg data=sashelp.heart;
  model systolic = weight height / covb clb;
  ods exclude NObs;
run;

ods graphics off;
proc reg data=sashelp.heart;
  model systolic = weight height / covb clb alpha=0.10;
  ods exclude NObs;
run;

proc glm data=sashelp.heart;
  model systolic = weight height / clparm;
  *ods select FitStatistics 'Type III Model ANOVA'
      parameterEstimates;
  *ods output parameterEstimates=parms;
run;

proc glm data=sashelp.heart;
  model systolic = height weight / clparm;
  *ods select FitStatistics 'Type III Model ANOVA'
      parameterEstimates;
  *ods output parameterEstimates=parms;
run;

proc means data=sashelp.heart mean;
  var weight height;
run;
proc standard data=sashelp.heart out=heartCent mean=0;
  var weight height;
run;
proc glm data=heartCent;
  model systolic = weight height / clparm;
  ods select parameterEstimates;
run;

