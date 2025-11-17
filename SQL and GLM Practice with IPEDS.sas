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
proc sql;
  create table GradRates as 
    select Grads.UnitId, Grads.Total/Cohort.Total as GradRate
    from ipeds.Graduation(where=(group contains 'Completers')) as Grads
            inner join
         ipeds.Graduation(where=(group contains 'Incoming')) as Cohort
      on Grads.UnitID eq Cohort.UnitID
  ;
  create table UseGLMB as
    select  GradRate, control, tuition2/1000 as Tuition1K
    from GradRates inner join ipeds.characteristics as ch on gradRates.unitID eq ch.UnitID
              inner join ipeds.TuitionAndCosts as tc on ch.unitId eq tc.UnitID
    ;
  *create table test as  
    select mean(tuition2/1000) as MeanTu1K
    from ipeds.tuitionandcosts
    ;
  create table GLMBStd as
    select  GradRate, control, tuition2/1000 as Tuition1K, mean(tuition2/1000) as MeanTu1K,
            calculated Tuition1K - calculated MeanTu1K as TuCentered
    from GradRates inner join ipeds.characteristics as ch on gradRates.unitID eq ch.UnitID
              inner join ipeds.TuitionAndCosts as tc on ch.unitId eq tc.UnitID
    ;
quit;



ods graphics off;
proc glm data=SomeNewData;
  class control sex;
  model GradRate = control sex Tuition1K / solution;
run;/***set up a data set to do this...***/

proc sql;
  create table GradRatesB as 
    select Grads.UnitId, Grads.Men/Cohort.Men as Men, Grads.Women/Cohort.Women as Women
    from ipeds.Graduation(where=(group contains 'Completers')) as Grads
            inner join
         ipeds.Graduation(where=(group contains 'Incoming')) as Cohort
      on Grads.UnitID eq Cohort.UnitID
    order by Grads.UnitID
  ;
quit;

proc transpose data=GradRatesB out=GradRatesWM(rename=(col1=GradRate _name_=Sex));
  var Men Women;
  by UnitID;
run;

proc sql;
  create table UseWM as
    select  GradRate, sex, control, tuition2/1000 as Tuition1K, mean(tuition2/1000) as MeanTu1K,
            calculated Tuition1K - calculated MeanTu1K as TuCentered
    from GradRatesWM inner join ipeds.characteristics as ch on GradRatesWM.unitID eq ch.UnitID
              inner join ipeds.TuitionAndCosts as tc on ch.unitId eq tc.UnitID
  ;
quit;

ods graphics off;
proc glm data=UseWM;
  class control sex;
  model GradRate = control sex TuCentered / solution;
run;

ods graphics off;
proc glm data=UseWM;
  class control sex;
  model GradRate = control|TuCentered sex|TuCentered/ solution;
run;

proc means data=useWM min q1 mean median q3 max;
  class control sex;
  var Tuition1K;
  ways 0 1 2;
run;


proc sql;
  create table GradRatesB as 
    select Grads.UnitId, Grads.Men/Cohort.Men as Men, Grads.Women/Cohort.Women as Women
    from ipeds.Graduation(where=(group contains 'Completers')) as Grads
            inner join
         ipeds.Graduation(where=(group contains 'Incoming')) as Cohort
      on Grads.UnitID eq Cohort.UnitID
    order by Grads.UnitID
  ;
  create table JoinWithMW as
    select  GradRatesB.UnitID, Men, Women, control, tuition2/1000 as Tuition1K, mean(tuition2/1000) as MeanTu1K,
            calculated Tuition1K - calculated MeanTu1K as TuCentered
    from GradRatesB inner join ipeds.characteristics as ch on GradRatesB.unitID eq ch.UnitID
              inner join ipeds.TuitionAndCosts as tc on ch.unitId eq tc.UnitID
    order by GradRatesB.UnitID
  ;
quit;

proc transpose data=JoinWithMW out=Try1(rename=(col1=GradRate _name_=Sex));
  var Men Women;
  by UnitID;
run;/**only the variables used in the statements, plus the rename of _name_ appear...**/

proc transpose data=JoinWithMW out=Try1(rename=(col1=GradRate _name_=Sex));
  var Men Women;
  by UnitID control Tuition1K TuCentered; /**any other variables are also unique to the BY groups
                                          useful for copying over other variables to the transposed data**/
run;

/**Can you create that data in SQL only? No transpose or anything else...**/
proc sql;
  create table GradRatesMen as 
    select Grads.UnitId, Grads.Men/Cohort.Men as Men
    from ipeds.Graduation(where=(group contains 'Completers')) as Grads
            inner join
         ipeds.Graduation(where=(group contains 'Incoming')) as Cohort
      on Grads.UnitID eq Cohort.UnitID
    order by Grads.UnitID
  ;
  create table GradRatesWomen as 
    select Grads.UnitId, Grads.Women/Cohort.Women as Women
    from ipeds.Graduation(where=(group contains 'Completers')) as Grads
            inner join
         ipeds.Graduation(where=(group contains 'Incoming')) as Cohort
      on Grads.UnitID eq Cohort.UnitID
    order by Grads.UnitID
  ;
quit;

proc sql;
  create table GradWomenMen as
    select Grads.UnitId, 'Men' as Sex, Grads.Men/Cohort.Men as GradRate
      from ipeds.Graduation(where=(group contains 'Completers')) as Grads
              inner join
           ipeds.Graduation(where=(group contains 'Incoming')) as Cohort
        on Grads.UnitID eq Cohort.UnitID
  union
    select Grads2.UnitId, 'Women' as Sex, Grads2.Women/Cohort2.Women as GradRate
      from ipeds.Graduation(where=(group contains 'Completers')) as Grads2
              inner join
           ipeds.Graduation(where=(group contains 'Incoming')) as Cohort2
        on Grads2.UnitID eq Cohort2.UnitID
  ;
quit;