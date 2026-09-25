libname SASData '~/SASData';

proc reg data=sasdata.cdi;
  'BA/BS Rate':model inc_per_cap = ba_bs;
  'Pop 18 to 34':model inc_per_cap = pop18_34;
  'BA/BS Rate & Pop 18 to 34':
      model inc_per_cap = ba_bs pop18_34;
  ods select parameterEstimates;
run;

proc corr data=sasdata.cdi;
  var ba_bs;
  with pop18_34;
run;

proc glm data=sasdata.cdi;
  model inc_per_cap = ba_bs|pop18_34;
  ods select parameterEstimates;
run;

proc standard data=sasdata.cdi 
              out=cdiCent mean=0;
  var ba_bs pop18_34;
run;

proc reg data=cdiCent;
  'BA/BS Rate':model inc_per_cap = ba_bs;
  'Pop 18 to 34':model inc_per_cap = pop18_34;
  'BA/BS Rate & Pop 18 to 34':
      model inc_per_cap = ba_bs pop18_34;
  ods select parameterEstimates;
run;
proc glm data=cdiCent;
  model inc_per_cap = ba_bs|pop18_34;
  ods select parameterEstimates;
run;

proc standard data=sasdata.cdi 
              out=cdiSTD mean=0 std=1;
  var ba_bs pop18_34;
run;

proc reg data=cdiSTD;
  'BA/BS Rate':model inc_per_cap = ba_bs;
  'Pop 18 to 34':model inc_per_cap = pop18_34;
  'BA/BS Rate & Pop 18 to 34':
      model inc_per_cap = ba_bs pop18_34;
  ods select parameterEstimates;
run;
proc glm data=cdiSTD;
  model inc_per_cap = ba_bs|pop18_34;
  ods select parameterEstimates;
run;

/*2a*/
ods graphics off;
proc glm data=SASData.cdi;
  class region;
  model inc_per_cap = region / solution;
run;

ods graphics off;
proc glm data=SASData.cdi;
  class region;
  model inc_per_cap = region / noint solution;
run;
ods graphics off;
proc glm data=SASData.cdi;
  class region;
  model inc_per_cap = region / solution;
  lsmeans region;
run;

/*2b*/
proc glm data=SASData.cdi;
  class region;
  model inc_per_cap = region|ba_bs / solution;
  ods select parameterEstimates;
run;

proc standard data=sasdata.cdi 
              out=cdiCenter mean=0;
  var ba_bs;
run;
proc glm data=cdiCenter;
  class region;
  model inc_per_cap = region|ba_bs / solution;
  ods select parameterEstimates;
run;

/*3*/
proc reg data=sasdata.realestate;
  'Square Footage':model price = sq_ft;
  'Bedrooms':model price = bedrooms;
  'Square Footage & Bedrooms':
      model price = sq_ft bedrooms;
  ods select parameterEstimates;
run;
proc glm data=sasdata.realestate;
  model price = sq_ft|bedrooms;
  ods select parameterEstimates;
run;

proc standard data=sasdata.realestate out=realCenter mean=0;
  var sq_ft;
run;

data realCenter;
  set realCenter;
  beds = bedrooms - 3;
run;

proc glm data=realCenter;
  model price = sq_ft|beds;
  ods select parameterEstimates;
run;

proc glm data=sasdata.realestate;
  model price = sq_ft|bedrooms;
  ods select parameterEstimates;
  output out=original p=predictedValue;
run;
proc glm data=realCenter;
  model price = sq_ft|beds;
  ods select parameterEstimates;
  output out=centered p=predictedValue;
run;

/*4*/
proc glm data=sasdata.realestate;
  class quality;
  model price = quality / solution;
  ods select parameterEstimates;
run;
proc glm data=sasdata.realestate;
  model price = quality / solution;
  ods select parameterEstimates;
run;/*Sometimes it can make sense to treat
  an ordinal predictor like a quantitative one, 
  dubious for this one, though...*/

proc glm data=sasdata.realestate;
  class quality;
  model price = quality|sq_ft / solution;
  ods select parameterEstimates;
run;

proc standard data=sasdata.realestate out=realCenter mean=0;
  var sq_ft;
run;

proc glm data=realCenter;
  class quality;
  model price = quality|sq_ft / solution;
  ods select parameterEstimates;
run;