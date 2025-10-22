ods graphics off;
proc reg data=sashelp.heart;
  model systolic = weight;
  /*** model response-variable = predictor-variables; 

    systolic:y, weight:x ***/
run;

proc standard data=sashelp.heart out=heartCentered mean=0;
      /**mean=0 says transform to mean zero (subtract the mean)**/
  var weight;
run;

ods graphics off;
proc reg data=heartCentered;
  model systolic = weight;
run;

proc glm data=sashelp.heart;
  model systolic = weight;
  /*** model response-variable = predictor-variables; 

    systolic:y, weight:x ***/
run;


proc glm data=heartCentered;
  model systolic = weight;
run;

/**Concept Questions 3.1**/

proc glm data=sashelp.heart;
  model weight = systolic;
run;


ods graphics off;
proc reg data=sashelp.heart;
  model systolic = weight height;
  /*** model response-variable = predictor-variables; 

    systolic:y, weight:x1, height:x2 ***/
run;

ods graphics off;
proc glm data=sashelp.heart;
  model systolic = weight height;
  /*** model response-variable = predictor-variables; 

    systolic:y, weight:x1, height:x2 ***/
run;

proc standard data=sashelp.heart out=heartCentered mean=0;
      /**mean=0 says transform to mean zero (subtract the mean)**/
  var weight height;
run;

ods graphics off;
proc reg data=heartCentered;
  model systolic = weight height;
  ods exclude anova;
run;


proc glm data=sashelp.heart;
  model systolic = weight height weight*height;
    /**products of predictors are allowed in PROC GLM using *
        **/
  ods select parameterEstimates;
run;

/**PROC REG does not support any modifications
      to predictors in the column statement**/
data heart;
  set sashelp.heart;
  weightXheight = weight*height;
  /**make a version of the data with the product 
      in there...**/
run;
ods graphics off;
proc reg data=heart;
  model systolic = weight height weightXheight;/**...use it**/
  ods select parameterEstimates;
run;

proc glm data=heartCentered;
  model systolic = weight height weight*height;
    /**products of predictors are allowed in PROC GLM using *
        **/
  ods exclude anova modelAnova;
run;

data heart;
  set sashelp.heart;
  where weight_status ne '';/**don't want these (there aren't any)**/
 
  underweight=0; normal=0; overweight=0;/**start with all zero**/
  select(weight_status);
    when('Underweight') underweight=1;
    when('Normal') normal=1;
    when('Overweight') overweight=1;
  end;/**flip on the right one**/
  sum=sum(of underweight--overweight);
run;
proc reg data=heart;
  'Means':model systolic = underweight normal overweight / noint;
      /**NOINT removes the intercept from the equation before estimating--
        no column of 1 in the X matrix**/
  'Effects':model systolic = underweight normal overweight;
      restrict underweight+normal+overweight=0;
      /**intercept is included with a restriction--restriction is written
          in terms of the variables but applies to their associated parameters**/
  'Reference': model systolic = underweight normal;
      /**removed overweight, it becomes the reference category**/
  ods select ParameterEstimates;
run;

proc means data=sashelp.heart;
  class weight_status;
  var systolic;
  ways 0 1;
run;

proc glm data=sashelp.heart;
  class weight_status; /**class -> treat these as nominal**/
  model systolic = weight_status / solution;
    /**solution shows the estimated model even when
      only categorical stuff is used**/
  ods select ParameterEstimates;
run;

proc glm data=sashelp.heart;
  class weight_status; /**class -> treat these as nominal**/
  model systolic = weight_status / solution noint;
    /**solution shows the estimated model even when
      only categorical stuff is used**/
  ods select ParameterEstimates;
run;

