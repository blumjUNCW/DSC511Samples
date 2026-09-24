proc glm data=sashelp.heart;
  class chol_status;
  model systolic = weight chol_status / solution;
  ods select parameterEstimates;
run;

proc glm data=sashelp.heart;
  class chol_status;
  model systolic = weight chol_status / noint solution;
  ods select parameterEstimates;
run;/**Parallel lines models--each cholesterol
    status category gets a different intercept,
    same slope/relation to weight in each*/

proc standard data=sashelp.heart out=heartCenter mean=0;
  var weight;
run;

proc glm data=heartCenter;
  class chol_status;
  model systolic = weight chol_status / solution;
  ods select parameterEstimates;
run;

proc glm data=heartCenter;
  class chol_status;
  model systolic = weight chol_status / noint solution;
  ods select parameterEstimates;
run;

/*I am not limited to parallel lines...*/
proc glm data=sashelp.heart;
  class chol_status;
  model systolic = weight|chol_status  
                  / solution;
  ods select parameterEstimates;
run;

proc glm data=sashelp.heart;
  class chol_status;
  model systolic = chol_status weight*chol_status  
                  / noint solution;
  ods select parameterEstimates;
run;

proc glm data=heartCenter;
  class chol_status;
  model systolic = chol_status weight*chol_status  
                  / noint solution;
  ods select parameterEstimates;
run;

proc glm data=sashelp.heart;
  class chol_status weight_status;
  model systolic = weight_status|chol_status  
                  / solution;
  ods select parameterEstimates;
run;