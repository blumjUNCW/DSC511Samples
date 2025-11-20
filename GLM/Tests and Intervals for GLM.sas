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
  class weight_status;
  model systolic = weight_status;
  lsmeans weight_status / diff=control adjust=dunnett cl;
  *ods select lsmeans lsmeandiffcl;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status;
  lsmeans smoking_status / diff=control('Non-smoker') cl;
  *ods select lsmeans lsmeandiffcl;
run;


ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status sex / solution clparm;
    /**two categorical predictors...**/
  lsmeans chol_status / diff=all cl;
  lsmeans sex / diff cl;
    /**can look at each with a separate LSMEANS**/
  *ods select 'Type III Model ANOVA' lsmeans diff;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status sex / solution clparm;
  lsmeans chol_status sex / diff=all adjust=tukey;
    /**for something like sex with 2 levels, the Tukey
        adjustment is no adjustment at all--
        Tukey adjusts for multiple comparisons, here the 
            "multiple" is 1**/
  lsmeans sex / diff;
  *ods select 'Type III Model ANOVA' lsmeans diff;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex / solution;
  lsmeans chol_status*sex / lines adjust=tukey ;
  lsmeans sex / lines adjust=tukey;
  ods select 'Type III Model ANOVA' lsmlines;
  ods output lsmeans=means;
run;

proc sgplot data=means;
  series y=lsmean x=chol_status / group=sex markers markerattrs=(symbol=circlefilled)
                        lineattrs=(pattern=2);
run;
proc sgplot data=means;
  series y=lsmean x=sex / group=chol_status markers markerattrs=(symbol=circlefilled)
                        lineattrs=(pattern=2) nomissinggroup;
run;


ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex;
  lsmeans chol_status*sex / slice=sex slice=chol_status;
  *ods select slicedANOVA;
run;


ods graphics off;
proc mixed data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex;
  /**in MIXED, the CLASS and MODEL syntax is the same...**/
  slice chol_status*sex / sliceby=sex diff adjust=tukey;
    /**it does have an LSMEANS statement, but for interactions
      it also has this SLICE statement**/
  ods select sliceTests;
  ods output sliceDiffs=slDiff;
run;
proc print data=slDiff;
  by slice;
  id slice;
  var Chol_Status _Chol_Status estimate adjp;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex / solution;
  lsmeans chol_status*sex / diff=all adjust=tukey ;
  ods select lsmeans diff;
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



