libname IPEDS '~/IPEDS';

proc sort data=ipeds.graduation out=gradSort;
  by unitId group;
run;

data grads cohort;
  set gradSort;
  by unitId group;

  if first.unitID then output grads;
  if last.unitID then output cohort;

run;

data gradRates1;
  merge grads(rename=(men=GradMen women=GradWomen total=GradTotal))
        cohort;
  by unitId;

  gradRate = GradTotal/Total;
  gradRateM = GradMen/Men;
  gradRateW = GradWomen/Women;

  format gradRate: percent8.2;

  drop total group;
run;

data gradRates2;
  set gradSort;
  by unitId group;
  retain GradWomen GradMen GradTotal;

  if first.unitID then do; 
     GradWomen=Women;
     GradMen=Men;
     GradTotal=Total;
  end;

  if last.unitID then do; 
    RateMen=GradTotal/Total;
    RateWomen=GradWomen/Women;
    RateMen=GradMen/Men;
    output;
  end;
  format Rate: percent8.2;
run;