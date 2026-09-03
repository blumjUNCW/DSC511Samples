libname IPEDS '~/IPEDS';

/*For each institution, calculate a total graduation rate
  (incoming/completers as a %)*/

proc contents data=IPEDS.graduation;
run;/**sort is not validated...*/

proc sort data=IPEDS.graduation out=grads;
  by unitID descending Group;
run;/*So I will make sure the record order is something reasonable*/

/*So, I am trying to do a computation based on values in two consecutive rows
  when I am in the second of those two rows...*/
data lagging;
  set grads;

  lag1 = lag(total);
  lag2 = lag2(total);
  lag3 = lag3(total);

run;


data try1;
  set grads;

  GradRate = total/lag(total);
  /**Want this, but only for the last (second) record 
    for an institution */

run;

data try1;
  set grads;

  GradRate = total/lag(total);
  if index(group,"Completers") then output;
  /*the second record is identified by the Completers group...*/

run;

data try1;
  set grads;

  GradRate = total/lag(total);
  if index(group,"Completers") then output;
  /*the second record is identified by the Completers group...*/

  keep unitID GradRate;

run;

data try1B;
  set grads;

  GradRate = total/lag(total);
  if mod(_n_,2) eq 0 then output;
  /*Do only even numbered records*/

  keep unitID GradRate;

run;

/*What if I want it to have the following columns:
    UnitID, Incoming, Completers, Rate*/

data try2;
  set grads;

  Incoming = lag(total);
  Completers = total;
  GradRate = Completers/Incoming;
  if index(group,"Completers") then output;

  keep unitID incoming Completers GradRate;

run;/**This works well when there are simple pairs of records,
      but it would be hard to generalize...*/

/**Most of the time, we would use the sorting structure
  to handle these issues...*/

data FirstAndLast;
  set grads;
  by unitID descending Group;

  /**If you use a BY statement in a DATA step--data must be sorted--
     automatic tracking variables are created for each BY variable
     
     first.var and last.var
     However, they are automatically dropped, so you will not see them
        without some effort*/
  
  StartUnit = first.UnitID;
  EndUnit = last.UnitID;

  StartGroup = first.Group;
  EndGroup = last.Group;
run;

proc sort data=sashelp.cars out=carSort;
    by make type Model;
run;

data FirstAndLastB;
  set carSort;
  by make type;

  /**If you use a BY statement in a DATA step--data must be sorted--
     automatic tracking variables are created for each BY variable
     
     first.var and last.var
     However, they are automatically dropped, so you will not see them
        without some effort*/
  
  StartMake = first.Make;
  EndMake = last.Make;

  StartType = first.Type;
  EndType = last.Type;
run;


data try3;
  set grads;
  by unitID descending Group;

  if first.unitID then Incoming = total;
    /**Get incoming from the first one...*/

  if last.unitID then do;/*for the last, do the computation and output*/
    Completers = total;
    GradRate = Completers/Incoming;
    output;
  end;/*Unfortunately, Incoming gets reset to missing each time the 
        following record is read...
        we need to avoid that*/
run;


data try3;
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

/**In some sense, we used the DATA step to transpose column vectors 
    of two values in Total to row vectors across the two variables
      Incoming and Completers (for each UnitID) */
proc transpose data=grads 
               out=GradsTr(drop=_: rename=(col1=Incoming col2=Completers));
  by unitID;
  var total;
run;/**This rotates the data to the form I want, still have to compute the rates*/
