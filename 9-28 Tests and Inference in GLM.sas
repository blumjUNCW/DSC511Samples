proc glm data=sashelp.heart;
  model systolic = weight smoking;
run;

ods graphics off;
proc reg data=sashelp.heart;
  model systolic = weight smoking / clb alpha=0.10 covb;
run;

proc standard data=sashelp.heart mean=0 std=1 out=HeartSTD;
  var weight smoking systolic;
  where weight ne . and smoking ne . and systolic ne .;
run;
ods graphics off;
proc reg data=HeartSTD;
  model systolic = weight smoking / clb alpha=0.10 covb;
run;

ods trace on;
ods graphics off;
proc glm data=sashelp.heart;
  model systolic = weight smoking / clparm alpha=0.10;
run;

ods graphics off;
proc glm data=sashelp.heart;
  model systolic = smoking weight / clparm alpha=0.10;
run;

ods graphics off;
proc glm data=sashelp.heart;
  model systolic = smoking weight / clparm alpha=0.10;
  ods select FitStatistics 'Type III Model ANOVA' ParameterEstimates;
run;


ods graphics off;
proc glm data=sashelp.heart;
  class chol_status;
  model systolic = chol_status|weight / solution;
  ods select 'Type III Model ANOVA' ParameterEstimates;
run;