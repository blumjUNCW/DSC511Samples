libname IPEDS '~/IPEDS';

proc sort data=IPEDS.graduation out=grads;
  by unitID descending Group;
run;

data GradRates;
  set grads;
  by unitID descending Group;
  retain incoming;
  /**RETAIN variable(s); Retain the value across reads of records
      from the data set (usually only applied to variables we create)*/

  if first.unitID then Incoming = total;
    /**Get incoming from the first one...*/

  if last.unitID then do;/*for the last, do the computation and output*/
    Completers = total;
    GradRate = Completers/Incoming;
    output;
  end;
  keep unitID incoming Completers GradRate;
run;

/**Build a GLM relating graduation rate to:
    Control (Public, Private NP, Private FP)
    Average Salary for faculty on 9-month contract
    Out-of-state tuition and fees */
options fmtsearch=(IPEDS);
/*put together this data set on grad rates with some information from
  Characteristics, Salaries, & TuitionAndCosts*/

data use;
  merge GradRates ipeds.characteristics ipeds.salaries ipeds.TuitionAndCosts;
  by unitID;
  /*assuming a common matching variable set across all tables,
      all tables are sorted as specified in BY 
      
      this is a full, outer join by default*/
run;


data use;
  merge GradRates(in=InGrads) 
        ipeds.characteristics(in=InChar) 
        ipeds.salaries(in=InSal) 
        ipeds.TuitionAndCosts(in=InTuit);
        /**DataSetName(in=Varname) 
          VarName is referred to as an In Variable,
            1 if the current record includes information from that table
            0 if not*/
  by unitID;

  if inGrads and InChar and InSal and InTuit;/**Inner join across all 4*/
  /**this ends up as a one-to-many merge since salaries has five
     records per university...*/

run;

/**I only want one of the salary records, the one for all instructional
  staff... */
data use;
  merge GradRates(in=InGrads) 
        ipeds.characteristics(in=InChar keep=unitID control) 
        ipeds.salaries(in=InSal where=(put(rank,arank.) contains 'All') 
                        keep=unitID rank sa09mot sa09mct) 
        ipeds.TuitionAndCosts(in=InTuit keep=unitID tuition3 fee3);
  by unitID;
  *where put(rank,arank.) contains 'All';

  if inGrads and InChar and InSal and InTuit;
  *if rank eq 7;
  *if find(put(rank,arank.),'All');

  avgSalary = sa09mot/sa09mct;
  totalCost = tuition3 + fee3;

run;/**Now I have all of the variables I wanted (plus a few extra) */

/*Fit the model for graduation rate with those three predictors: 
    control, avg. salary, total cost; and no cross-products*/

ods graphics off;
proc glm data=use;
  class control;
  model gradRate = control avgSalary totalCost / solution;
run;

data useB;
  merge GradRates(in=InGrads) 
        ipeds.characteristics(in=InChar keep=unitID control) 
        ipeds.salaries(in=InSal where=(put(rank,arank.) contains 'All') 
                        keep=unitID rank sa09mot sa09mct) 
        ipeds.TuitionAndCosts(in=InTuit keep=unitID tuition3 fee3);
  by unitID;

  if inGrads and InChar and InSal and InTuit;

  avgSalary = (sa09mot/sa09mct)/10000;
  totalCost = (tuition3 + fee3)/10000;

run;

/*Fit the model for graduation rate with those three predictors: 
    control, avg. salary, total cost; and no cross-products*/

ods graphics off;
proc glm data=useB;
  class control;
  model gradRate = control avgSalary totalCost / solution;
run;

proc standard data=useB out=Centered mean=0;
  var avgSalary totalCost;
run;
ods graphics off;
proc glm data=Centered;
  class control;
  model gradRate = control avgSalary totalCost / solution;
run;

ods graphics off;
proc glm data=Centered;
  class control;
  model gradRate = control|avgSalary|totalCost @2 / solution;
run;


