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

ods trace on;
ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  /*two categorical predictors...*/
  model systolic = chol_status sex;
  /*...no interaction*/
  lsmeans chol_status / diff=all lines;
  lsmeans sex / diff;
  /**can do comparisons on each individually... */
  ods select 'Type III Model ANOVA' lsmeans lsmlines diff;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  /*two categorical predictors...*/
  model systolic = chol_status sex;
  /*...no interaction*/
  lsmeans chol_status sex / diff=all ;
  /*could also put both in the same LSMEANS, but
      the Tukey adjustment is not really applied for
        Sex, because there's only one comparison*/
  ods select 'Type III Model ANOVA' lsmeans diff;
run;

proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex;
  /*with interaction--which tests as significant ->
      the relationship between
            1. systolic and cholStatus is inconsistent
                  across males and females
            2. systolic and sex is inconsistent 
                  across cholesterol status*/
  lsmeans chol_status*sex;
  /*we look at them together -- almost as if they 
      are one factor coded together*/
  ods select 'Type III Model ANOVA' lsmeans;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex;
  lsmeans chol_status*sex / diff=all lines cl;
  ods output lsmeans=means;
  /*when I put in an interaction, I can still ask for
      comparisons*/
  *ods select 'Type III Model ANOVA' lsmeans;
run;
/**We see that the cholesterol - systolic relationship is
    direct in the female group: worse cholesterol corresponds
      to worse average systolic,
      for the males, only the worst cholesterol corresponds
        to significantly higher systolic bp
        
    Among those with the worst cholesterol, females have
        higher avg. systolic BP,
    Among those with the best, the relationship is reversed
    For borderline cholesterol, no difference is discernable
      for avg BP for males and females*/
proc sgplot data=means;
  series x=sex y=lsmean / group=chol_status markers;
run;

proc format;
    value $chol
    'Desirable' = '1. Desirable'
    'Borderline' = '2. Borderline'
    'High' = '3. High'
    ;
run;

data means;
  set means;
  select(chol_status);
    when('Desirable') cholCode=1;
    when('Borderline') cholCode=2;
    when('High') cholCode=3;
  end;
run;

proc sort data=means;
    by cholcode sex;
run;

proc sgplot data=means;
  series x=cholCode y=lsmean / group=sex markers;
run;


ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex;
  lsmeans chol_status*sex / slice=chol_status slice=sex;
run;

ods graphics off;
proc mixed data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex;
  slice chol_status*sex / sliceby=sex diff=all;
run;

