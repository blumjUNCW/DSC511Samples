libname IPEDS '~/IPEDS';
options fmtsearch=(IPEDS);

proc sql;
  create table GradRates as 
    select Grads.UnitId, Grads.Total/Cohort.Total as GradRate
    from ipeds.Graduation(where=(group contains 'Completers')) as Grads
            inner join
         ipeds.Graduation(where=(group contains 'Incoming')) as Cohort
      on Grads.UnitID eq Cohort.UnitID
  ;
  create table UseGLM as
    select  GradRate, iclevel, tuition2/1000 as Tuition1K
    from GradRates inner join ipeds.characteristics as ch on gradRates.unitID eq ch.UnitID
              inner join ipeds.TuitionAndCosts as tc on ch.unitId eq tc.UnitID
    ;
quit;

ods graphics off;
proc glm data=UseGLM;
  class iclevel;
  model GradRate = iclevel Tuition1K / solution;
    /**our graduation data only includes 4-year institutions, so iclevel
        cannot be a predictor for this response**/
run;
ods graphics off;
proc glm data=UseGLM;
  model GradRate = Tuition1K;
run;

proc sql;
  create table UseGLMB as
    select  GradRate, control, tuition2/1000 as Tuition1K
    from GradRates inner join ipeds.characteristics as ch on gradRates.unitID eq ch.UnitID
              inner join ipeds.TuitionAndCosts as tc on ch.unitId eq tc.UnitID
    ;
quit;

ods graphics off;
proc glm data=UseGLMB;
  class control;
  model GradRate = control Tuition1K / solution;
run;

ods graphics off;
proc glm data=UseGLMB;
  class control;
  model GradRate = control|Tuition1K / solution;
run;

proc standard data=UseGLMB out=GLMSTD mean=0;
  var Tuition1K;
run;
ods graphics off;
proc glm data=GLMSTD;
  class control;
  model GradRate = control|Tuition1K / solution;
run;

/**Can you do the centering in your SQL query instead of invoking
  another procedure?

  What if we wanted to use biological sex as a predictor? Can you set
    the data up to do that?**/