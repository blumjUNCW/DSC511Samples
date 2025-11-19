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

proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status / solution clparm;
  ods select none;
  ods output ParameterEstimates=parms;
run;
ods select all;
proc print data=parms noobs;
  var Parameter Estimate StdErr tValue Probt LowerCl UpperCl;
  format Estimate StdErr tValue LowerCL UpperCL 8.2;
run;

proc glm data=sashelp.heart;
  class weight_status(ref='Normal');
  model systolic = weight_status / solution clparm;
  ods select none;
  ods output ParameterEstimates=parms;
run;
ods select all;
proc print data=parms noobs;
  var Parameter Estimate StdErr tValue Probt LowerCl UpperCl;
  format Estimate StdErr tValue LowerCL UpperCL 8.2;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution clparm;
  ods select none;
  ods output ParameterEstimates=parms;
run;
ods select all;
proc print data=parms noobs;
  var Parameter Estimate StdErr tValue Probt LowerCl UpperCl;
  format Estimate StdErr tValue LowerCL UpperCL 8.2;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status / solution clparm;
  lsmeans weight_status;
  /**lsmeans -> least-squares means = mean estimates
      derived from least-squares model parameter estimates

     can only put categorical/class stuff in here 
      (quantitative stuff can be included in the options)**/
run;

ods graphics off;
proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status / solution clparm;
  lsmeans weight_status / cl;
  /**many options are available...
    cl, confidence intervals for the means (alpha= is available)**/
run;

ods graphics off;
proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status / solution clparm;
  lsmeans weight_status / diff=all adjust=t;
  /**many options are available...
    diff or diff=all is all pairwise comparisons 
    by default it adjusts the comparisons
    adjust=T is default t-tests, no adjustment**/
run;

ods graphics off;
proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status / solution clparm;
  lsmeans weight_status / diff;
  /**many options are available...
    diff is all pairwise, unadjusted **/
run;


ods graphics off;
proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status / solution clparm;
  lsmeans weight_status / diff cl;
  /**many options are available...
    diff and cl together 
      get conf limits for means
          table of p-values for differences
          estmated differences in means with confidence limits**/
run;

ods trace on;
ods graphics off;
proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status / solution clparm;
  lsmeans weight_status / diff;
  lsmeans weight_status / diff adjust=tukey;
  lsmeans weight_status / diff adjust=bon;
  lsmeans weight_status / diff adjust=sidak;
  *ods select diff;
  /****/
run;

ods graphics off;
proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status / solution clparm;
  lsmeans weight_status / diff;
  lsmeans weight_status / diff adjust=tukey lines;
  *ods select diff;
  /****/
run;

ods graphics off;
proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution clparm;
  lsmeans smoking_status / diff;
  lsmeans smoking_status / diff adjust=tukey;
  lsmeans smoking_status / diff adjust=tukey lines;
  *ods select diff;
  /****/
run;

ods graphics off;
proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = weight smoking_status / solution clparm;
  lsmeans smoking_status; /**No AT setting, it plugs in the mean of the quantitative
                            predictor(s)**/
  lsmeans smoking_status / at weight = 125;
  lsmeans smoking_status / at weight = 150;
  lsmeans smoking_status / at weight = 175;
run;


ods graphics off;
proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = weight smoking_status / solution clparm;
  lsmeans smoking_status /  diff=all; 
  lsmeans smoking_status / at weight = 125 diff=all;
  lsmeans smoking_status / at weight = 150 diff=all;
  lsmeans smoking_status / at weight = 175 diff=all;
  ods select diff;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = weight|smoking_status / solution clparm;
  lsmeans smoking_status /  diff=all; 
  lsmeans smoking_status / at weight = 125 diff=all;
  lsmeans smoking_status / at weight = 150 diff=all;
  lsmeans smoking_status / at weight = 175 diff=all;
  ods select diff;
run;



