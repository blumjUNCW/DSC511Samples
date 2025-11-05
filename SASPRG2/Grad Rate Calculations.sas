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

data gradRates1B;
  merge gradSort(where=(group contains 'Completers') 
               rename=(men=GradMen women=GradWomen total=GradTotal))
        gradSort(where=(group contains 'Incoming'));
  by unitId;

  gradRate = GradTotal/Total;
  gradRateM = GradMen/Men;
  gradRateW = GradWomen/Women;

  format gradRate: percent8.2;

  drop group;
run;


data gradRates1;
  merge grads(rename=(men=GradMen women=GradWomen total=GradTotal))
        cohort;
  by unitId;

  gradRate = GradTotal/Total;
  gradRateM = GradMen/Men;
  gradRateW = GradWomen/Women;

  format gradRate: percent8.2;

  drop group;
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
    RateTotal=GradTotal/Total;
    RateWomen=GradWomen/Women;
    RateMen=GradMen/Men;
    output;
  end;
  format Rate: percent8.2;
  drop group;
run;

proc transpose data=gradsort out=gradsortT(rename=(col1=Grads col2=Incoming) drop=_label_) name=Type;
  by unitID;
  var Total Women Men;
  *id group;
run;

data gradRates3;
  set gradSortT;
  Rate = Grads/Incoming;

  format rate percent8.2;
run;

proc sgplot data=gradrates3;
  hbar type / response=rate stat=mean;
run;



