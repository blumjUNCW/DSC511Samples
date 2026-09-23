proc reg data=sashelp.heart; /**REG-> regression, expects quantitative response and predictors*/
  model systolic = weight; /**MODEL response = predictor(s); */
run;

proc glm data=sashelp.heart; /**GLM-> general linear model, expects quantitative response 
                                  and accepts quantitative or categorical predictors*/
  model systolic = weight; /**MODEL response = predictor(s); */
run;

proc glm data=sashelp.heart; 
  model systolic = weight smoking; 
run;

proc sgplot data=sashelp.heart;
  scatter x=weight y=smoking /
      colorresponse=systolic colormodel=(blue green yellow red)
          markerattrs=(symbol=circlefilled) 
          jitter jitterwidth=8;
  yaxis values=(-5 to 65 by 10);
  where systolic le 200;
run;

libname SASData '~/SASData';
ods graphics off;
proc glm data=sasdata.realestate;
  model price = sq_ft;
  ods select parameterEstimates;
run;
proc glm data=sasdata.realestate;
  model price = bedrooms;
  ods select parameterEstimates;
run;

proc glm data=sasdata.realestate;
  model price = sq_ft bedrooms;
  ods select parameterEstimates;
run;

proc sgplot data=sasdata.realestate;
  scatter x=sq_ft y=bedrooms /
      colorresponse=price colormodel=(blue green yellow red)
          markerattrs=(symbol=circlefilled) 
          jitter jitterwidth=0.6;
run;

proc sgplot data=sasdata.realestate;
  scatter x=sq_ft y=bedrooms /
      colorresponse=price colormodel=(blue green yellow red)
          markerattrs=(symbol=circlefilled) 
          jitter jitterwidth=0.6;
  where sq_ft le 2500;
run;

proc glm data=sasdata.realestate;
  model price = sq_ft bedrooms sq_ft*bedrooms;
  ods select parameterEstimates;
run;

proc glm data=sashelp.heart; 
  model systolic = weight smoking weight*smoking; 
run;

proc glm data=sashelp.heart; 
  model systolic = weight weight*weight smoking smoking*smoking weight*smoking; 
run;


/**Some modifications we may want to employ with any predictors are centering
  and standardization.
  Centering--subtract a value from all data points, typically the mean,
              that becomes the new "center" for that predictor
  Standardization--centering and scaling (dividing by a value that
                  restricts the data range, often the standard deviation)*/

proc standard data=sashelp.heart out=heartCentered mean=0;
    /**mean=0 subtracts the mean from each value so that the original
        mean has value zero in the transformed data */
  var weight; 
run;

proc glm data=heartCentered; 
  model systolic = weight smoking weight*smoking; 
run;

proc standard data=SASData.realestate out=realEstCent mean=0;
  var sq_ft;
run;

data realEstCent;
  set realEstCent;
  beds = bedrooms-2;
run;

proc glm data=realEstCent;
  model price = sq_ft beds sq_ft*beds;
  ods select parameterEstimates;
run;


proc standard data=sashelp.heart out=heartSTD mean=0 std=1;
  /**std=1 says make the variable have standard deviation 1,
      i.e. divide by the original standard deviation
      mean=0, std=1, is the z-score transformation */
  var weight smoking; 
run;


proc glm data=heartSTD; 
  model systolic = weight smoking weight*smoking; 
run;


proc glm data=sashelp.heart;
  model systolic = weight_status;
run;


proc reg data=sashelp.heart;
  model systolic = weight_status;
run;/*on there own, character variables are not permitted in 
    the predictor set for either GLM or REG*/

data heart2;
  set sashelp.heart;

  Underweight = 0; Normal = 0; Overweight = 0;
  select(lowcase(weight_status));
    when ('underweight') Underweight = 1;
    when ('normal') Normal = 1;
    when ('overweight') Overweight = 1;
    otherwise delete;/*DELETE -> removes the current record and returns to
                        read the next record*/
  end;
run;

proc means data=sashelp.heart;
    class weight_status;
    var systolic;
run;
ods graphics off;
title 'Means Model';
proc reg data=heart2;
  ods select parameterEstimates;
  model systolic = Underweight Normal Overweight / noint; /**NOINT -> no intercept*/
run;/*Means model--the parameter estimates are the means for each 
        category*/

/**What happens if I put the intercept in?*/
Title 'Overweight removed from paramter list';
ods graphics off;
proc reg data=heart2;
  ods select parameterEstimates;
  model systolic = Underweight Normal Overweight;
run;

ods graphics off;
Title 'Underweight removed from paramter list';
proc reg data=heart2;
  ods select parameterEstimates;
  model systolic = Normal Overweight Underweight;
run;/**With the intercept, we introduce some redundancy...
      I only need 3 parameters for 3 categories and now
      I have 4. It eliminates one to fit the model*/

ods graphics off;
Title 'Normal removed from paramter list';
proc reg data=heart2;
  ods select parameterEstimates;
  model systolic = Underweight Overweight;
run;/**With the intercept, I only need two of the dummy variables
        (any 2 will work)
        
        Reference category models--intercept is the mean
          for the reference category, other parameters are 
          mean differences for a given category vs. ref. category*/

Title 'Dummy parameter restriction - sum to zero';
ods graphics off;
proc reg data=heart2;
  ods select parameterEstimates;
  model systolic = Underweight Normal Overweight;
  restrict Underweight + Normal + Overweight = 0;
      /*restrict -> some combination of variables = constant
          applies to the parameter estimates associated with the variables*/
run;  /*Effects model:
        Intercept is the overall mean, 
          each parameter estimate is how much above/below the category
            mean is*/
            
proc glm data=sashelp.heart;
  class weight_status;
  /**CLASS -> treat variable(s) as categorical, dummy encoding is automatic
      GLM does reference category, last one in is reference cat.*/
  model systolic = weight_status / solution;
    /**If you only have categorical predictors, you have to ask for the model
        estimate via SOLUTION */
run;

proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status / noint solution;
  /**with NOINT, you get the means model just like in REG*/
run;

proc glm data=sashelp.heart;
  class weight_status / ref=first;
  model systolic = weight_status / solution;
run;/*you can change reference category to first one in (for all variables)*/

proc glm data=sashelp.heart;
  class weight_status(ref='Overweight');
  /*you can set a specific category attached to a class variable*/
  model systolic = weight_status / solution;
run;

ods graphics off;
proc glm data=sashelp.heart;
  class weight_status;
  model systolic = weight_status;
  lsmeans weight_status;
  /**In GLM I can ask for the estimated means in each category via
      LSMEANS -> Least-squares estimated means */
run;




