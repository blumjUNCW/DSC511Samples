ods graphics off;
proc glm data=sashelp.heart;
  class chol_status;
  model systolic = chol_status / solution;
  ods select 'Type III Model ANOVA' ParameterEstimates;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status(ref='Desirable');
  model systolic = chol_status / solution;
  ods select 'Type III Model ANOVA' ParameterEstimates;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  ods select 'Type III Model ANOVA' ParameterEstimates;
run;/**to get a full set of pairwise comparisons, I can
      use an LSMEANS statement */

ods graphics off;
ods trace on;
proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status;
  /*LSMEANS -> Means estimated from Least-Squares model
      parameter estimates*/
  ods select 'Type III Model ANOVA' ParameterEstimates LSMeans;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status / diff=all;
  /*For DIFF=All, all pairs of categories have their means compared,
      by default, DIFF=All applies the Tukey adjustment to the 
        comparison p-values*/
  ods select 'Type III Model ANOVA' ParameterEstimates LSMeans Diff;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status / diff;
  /*For DIFF only, it's still all categories compared to each other,
    but there is no adjustment to the p-values*/
  ods select 'Type III Model ANOVA' ParameterEstimates LSMeans Diff;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status / diff adjust=bon;
  /*Adjustments can be manually chosen, Bonferonni multiples the
    raw p-values by the number of comparisons*/
  ods select 'Type III Model ANOVA' ParameterEstimates LSMeans Diff;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status / diff adjust=tukey;
  /*Diff with ADJUST=Tukey is the same as asking for DIFF=All*/
  ods select 'Type III Model ANOVA' ParameterEstimates LSMeans Diff;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status / diff adjust=tukey cl;
  /*You can ask for confidence limits on the means and the differences,
      the difference CIs are adjusted in the same way as the p-values
      (same as what you have selected)*/
  ods select 'Type III Model ANOVA' ParameterEstimates 
              LSMeans Diff LSMeanCL LSMeanDiffCL;
run;


proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status / diff=control cl;
  /**Control is one, fixed category that we want to compare all
    of the others to...by default, SAS assumes that is the first one in*/
  ods select 'Type III Model ANOVA' ParameterEstimates 
              LSMeans LSMeanCL LSMeanDiffCL;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status / diff=control('Non-smoker') cl;
  /**You can choose the control category by putting its literal
    value in. If you are using a format, this must be the formatted
    value.*/
  ods select 'Type III Model ANOVA' ParameterEstimates 
              LSMeans LSMeanCL LSMeanDiffCL;
run;

*ods graphics off;
proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status / diff adjust=tukey lines;
  *ods select 'Type III Model ANOVA' ParameterEstimates LSMeans Diff;
  /**LINES, either graphically or in a table, shows groups that are
      not significantly difference (colors or letters) so you can see
      where significant differences are*/
run;


proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status / solution;
  lsmeans smoking_status;
  ods select 'Type III Model ANOVA' ParameterEstimates 
              LSMeans;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status weight / solution;
  lsmeans smoking_status;
  /**If you have quantitative predictors and you ask for LSMEANS
      on a categorical predictor, the plug-in value for any
        quantitative predictor is its mean */
  ods select 'Type III Model ANOVA' ParameterEstimates 
              LSMeans;
run;

proc standard data=sashelp.heart out=heartCenter mean=0;
  where systolic ne .;
  var weight;
run;

proc glm data=heartCenter;
  class smoking_status;
  model systolic = smoking_status weight / solution;
  lsmeans smoking_status;
  ods select 'Type III Model ANOVA' ParameterEstimates 
              LSMeans;
run;


proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status weight / solution;
  lsmeans smoking_status / diff=all;
  /**You can still ask for diffs and intervals...*/
  lsmeans smoking_status / diff=all at weight=150;
  /**You can choose different values for your covariate... 
      and you can have multiple LSMEANS statements*/
  lsmeans smoking_status / diff=all at weight=200;
  ods select 'Type III Model ANOVA' ParameterEstimates 
              LSMeans diff;
run;

proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status weight / solution;
  lsmeans smoking_status / diff=all cl;
  lsmeans smoking_status / diff=all at weight=150 cl;
  lsmeans smoking_status / diff=all at weight=200 cl;
  ods select 'Type III Model ANOVA' ParameterEstimates 
              LSMeans LSMeanDiffCL;
run;/**None of the comparisons, differences, or intervals for
    the differences across smoking categories change when
      I change the weight value plugged in...
       parallel lines--don't really need to investigate
        if differences change across weight because the model
            doesn't permit it.*/



proc glm data=sashelp.heart;
  class smoking_status;
  model systolic = smoking_status|weight / solution;
  lsmeans smoking_status / diff=all cl;
  lsmeans smoking_status / diff=all at weight=150 cl;
  lsmeans smoking_status / diff=all at weight=200 cl;
  ods select 'Type III Model ANOVA' ParameterEstimates 
              LSMeans LSMeanDiffCL;
run;/**Not parallel, so diffs will change as weight changes... */
