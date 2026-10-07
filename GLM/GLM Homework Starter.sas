libname IPEDS '~/IPEDS';
options fmtsearch=(IPEDS);

/**Build graduation rates (find some prior code we did)
  merge onto characteristics, tuitionAndCosts (and later Salaries) */


proc transpose data=IPEDS.graduation 
               out=GradsTr(drop=_: rename=(col1=Incoming col2=Completers));
  by unitID;
  var total;
run;

data use;
  merge GradsTr(in=inGrads) 
        ipeds.characteristics(keep=unitid cbsatype locale hloffer) 
        ipeds.tuitionAndCosts(keep=unitid tuition2) 
        ipeds.salaries(keep=unitid sa09mot sa09mct rank
                        where=(put(rank,arank.) contains 'All'));
  by unitid;
  if inGrads; /*Left joint to grads, basically*/

  /**Compute graduation rate and average salary...*/
  gradRate = completers/incoming;
  avgSalary = sa09mot/sa09mct;
run;