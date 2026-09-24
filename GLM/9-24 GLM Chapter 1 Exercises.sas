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