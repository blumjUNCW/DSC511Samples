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
