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