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

/**additive model for one categorical and one quantitative predictor**/
ods graphics off;
proc glm data=sashelp.heart;
  class chol_status;
  model systolic = weight chol_status / solution;
  lsmeans chol_status / diff adjust=tukey;
  ods select parameterEstimates lsmeans diff;
run;

proc glm data=sashelp.heart;
  class chol_status;
  model systolic = weight chol_status;
  lsmeans chol_status / at weight=100 cl adjust=tukey;
  lsmeans chol_status / at weight=125 cl adjust=tukey;
  lsmeans chol_status / at weight=150 cl adjust=tukey;
  lsmeans chol_status / at weight=200 cl adjust=tukey;
  lsmeans chol_status / at means cl adjust=tukey;
  ods select lsmeans lsmeandiffcl;
run;

proc standard data=sashelp.heart out=heartSTD mean=0;
  var weight;
run;
ods graphics off;
proc glm data=heartSTD;
  class chol_status;
  model systolic = weight chol_status / solution;
  lsmeans chol_status / diff adjust=tukey;
  ods select parameterEstimates lsmeans diff;
run;

ods graphics off;
proc glm data=heartSTD;
  class chol_status;
  model systolic = weight chol_status;
  lsmeans chol_status / at weight=-50 cl adjust=tukey;
  lsmeans chol_status / at weight=-25 cl adjust=tukey;
  lsmeans chol_status / at weight=50 cl adjust=tukey;
  lsmeans chol_status / at means cl adjust=tukey;
  ods select lsmeans lsmeandiffcl;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class sex;
  model systolic = weight|sex / solution;
  lsmeans sex / diff;
  lsmeans sex / diff at weight=100;
  lsmeans sex / diff at weight=125;
  lsmeans sex / diff at weight=150;
  lsmeans sex / diff at weight=200;
  *ods select lsmeans diff;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class sex;
  model systolic = weight|sex AgeAtStart|sex / solution;
  lsmeans sex / at means diff=all;
  lsmeans sex / at weight = 125 diff=all;
  lsmeans sex / at weight = 175 diff=all;
  lsmeans sex / at AgeAtStart = 35 diff=all;
  lsmeans sex / at AgeAtStart = 55 diff=all;
  lsmeans sex / at (weight AgeAtStart) = (125 35) diff=all;
  lsmeans sex / at (weight AgeAtStart) = (175 35) diff=all;
  lsmeans sex / at (weight AgeAtStart) = (125 55) diff=all;
  lsmeans sex / at (weight AgeAtStart) = (175 55) diff=all;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex / solution;
  lsmeans chol_status*sex;
  estimate 'Chol=Desirable, Female' intercept 1 /**include the intercept**/
                                    chol_status 0 1 0 /*inc. desirable chol**/
                                    sex 1 0 /*inc. females*/
                                    chol_status*sex 0 0 1 0 0 0 
                                      /*also include females w/ des. chol*/
                                    ;
  estimate 'Chol=Desirable, Male' intercept 1
                                  sex 0 1
                                  chol_status 0 1 0
                                  chol_status*sex 0 0 0 1 0 0;
  *ods select parameterEstimates estimates;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex / solution;
  lsmeans chol_status*sex chol_status;
  estimate 'Chol=Desirable, Male' intercept 1
                                  sex 0 1
                                  chol_status 0 1 0
                                  chol_status*sex 0 0 0 1 0 0;
  estimate 'Chol=Desirable, Male v2' intercept 1
                                  sex 0 0
                                  chol_status 0 1 0
                                  chol_status*sex 0 0 0 0 0 0;
      /**can't get these coefficients from rows in X, so it does
          not produce an estimate**/
  estimate 'Chol=Desirable, Male v3' intercept 1
                                  chol_status 0 1 0;
    /**this is really the mean for desirable cholesterol across
        both sexes--SAS chooses coefficients for sex and chol_status*sex
        relative to sample size to estimate across sexes**/

  *ods select parameterEstimates estimates;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex / solution;
  lsmeans chol_status*sex / diff cl;
  estimate 'Chol=Desirable, Female' intercept 1 /**include the intercept**/
                                    chol_status 0 1 0 /*inc. desirable chol**/
                                    sex 1 0 /*inc. females*/
                                    chol_status*sex 0 0 1 0 0 0 
                                      /*also include females w/ des. chol*/
                                    ;
  estimate 'Chol=Desirable, Male' intercept 1
                                  sex 0 1
                                  chol_status 0 1 0
                                  chol_status*sex 0 0 0 1 0 0;
  estimate 'Des. Chol, Female-Male' intercept 0
                 sex 1 -1
                 chol_status 0 0 0
                 chol_status*sex 0 0 1 -1 0 0;
                 /**difference in the first set of coefficients and the
                    second**/
  estimate 'Des. Chol, Female-Male v2' sex 1 -1
                                    chol_status*sex 0 0 1 -1 0 0;
  *ods select parameterEstimates estimates;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex;
  lsmeans chol_status*sex;
  estimate 'Borderline: Female-Male' sex 1 -1
                                     chol_status*sex 1 -1 0  0 0 0;
  estimate 'Desirable: Female-Male'  sex 1 -1
                                     chol_status*sex 0  0 1 -1 0 0;
  estimate 'High: Female-Male'       sex 1 -1
                                     chol_status*sex 0  0 0  0 1 -1;
  estimate 'Female, Male diff, Borderline vs Desirable'
                              chol_status*sex 1 -1 -1 1 0 0;
  estimate 'Female, Male diff, Borderline vs High'
                              chol_status*sex 1 -1 0 0 -1 1;
  estimate 'Female, Male diff, Desirable vs High'
                              chol_status*sex 0 0 1 -1 -1 1;
  ods select estimates lsmeans;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex;
  lsmeans chol_status*sex / diff cl;
  estimate 'Borderline-Desirable, Females' chol_status 1 -1 0
                                           chol_status*sex 1 0 -1 0 0 0;
  estimate 'Borderline-Desirable, Males' chol_status 1 -1 0
                                         chol_status*sex 0 1 0 -1 0 0;
  estimate 'Borderline-Desirable, Females-Males'
                                         chol_status*sex 1 -1 -1 1 0 0;
  *ods select estimates lsmeans;
run;


ods graphics off;
proc mixed data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex / solution;
  *estimate 'Borderline: Female-Male' sex 1 -1
                                     chol_status*sex 1 -1 0 0 0 0 / cl;
  *estimate 'Female, Male diff, Borderline vs Desirable'
                                     chol_status*sex 1 -1 -1 1 0 0 / cl;
  /**ESTIMATE in MIXED looks just like it does in GLM, but it
    does let you get a confidence interval as well**/
  lsmestimate chol_status*sex 'Borderline: Female-Male' 
              1 -1 0 0 0 0 / cl e;
  lsmestimate chol_status*sex 'Female, Male diff, Borderline vs Desirable'
              1 -1 -1 1 0 0 / cl e;
    /***LSMESTIMATE is and estimate applied to a set of lsmeans...
          LSMESTIMATE effect "label" coefficients;
          coefficients are applied to the means generated for the chosen
          effect**/
  lsmeans chol_status*sex;
run;


proc mixed data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex / solution;
  lsmestimate sex*chol_status '?' 
              1 -1 0 0 0 0 / cl e;
  lsmestimate chol_status*sex 'Female, Male diff, Borderline vs Desirable'
              1 -1 -1 1 0 0 / cl e;
  lsmeans sex*chol_status;
run;/**lsmeans is always ordered on variable names first, values with variable
        second**/

proc mixed data=sashelp.heart;
  class chol_status sex;
  model systolic = sex|chol_status / solution;
  lsmestimate sex*chol_status '?' 
              1 -1 0 0 0 0 / cl e;
  lsmestimate chol_status*sex 'Female, Male diff, Borderline vs Desirable'
              1 -1 -1 1 0 0 / cl e;
  lsmeans sex*chol_status;
run;/**lsmeans is always ordered on variable names first, values with variable
        second**/

ods graphics off;
proc mixed data=sashelp.heart;
  class chol_status sex;
  model systolic = chol_status|sex / solution;
  lsmestimate chol_status 'Mean for high cholesterol group vs. rest' 
              0.5 0.5 -1 / cl e;
  lsmestimate chol_status 'mean' 
              0.33 0.33 0.33 / cl e;
  lsmestimate chol_status 'mean B' 
              1 1 1 /divisor=3 cl e;
  lsmeans chol_status;
run;


proc mixed data=sashelp.heart;
  class chol_status;
  model systolic = smoking|chol_status / solution cl;
  where sex eq 'Female' and ageAtStart le 50;
  estimate 'Smoking Effect, Borderline Chol'
            smoking 1 smoking*chol_status 1 0 0 / cl;
  estimate 'Smoking Effect, Desirable Chol'
            smoking 1 smoking*chol_status 0 1 0 / cl;
  estimate 'Smoking Effect, High Chol'
            smoking 1 smoking*chol_status 0 0 1 / cl;
  estimate 'Difference in Smoking effect: Borderline vs. Desirable'
            smoking*chol_status 1 -1 0 / cl;
  estimate 'Difference in Smoking effect: Borderline vs. High'
            smoking*chol_status 1 0 -1 / cl;
  estimate 'Difference in Smoking effect: Desirable vs. High'
            smoking*chol_status 0 1 -1 / cl;
  lsmestimate chol_status '??' 1 -1 0 / at means;
  lsmestimate chol_status '??' 1 -1 0 / at smoking=0;
  lsmestimate chol_status '??' 1 -1 0 / at smoking=10;
    /**LSMESTIMATE (and SLICE) will not accept this interaction because
      smoking is quantitative, but LSMESTIMATE does have the AT like 
      LSMEANS, so you could work on Chol_Status at different values 
      of Smoking**/
run;


proc mixed data=sashelp.heart;
  class chol_status;
  model systolic = smoking|chol_status / solution cl;
  where sex eq 'Female' and ageAtStart le 50;
  estimate 'Smoking Effect, Borderline Chol'
            intercept 1 chol_status 1 0 0
            smoking 10 smoking*chol_status 10 0 0 / cl;
  lsmeans chol_status / at smoking=10;
run;
