libname SASData '~/SASData';

/**from the MutualFunds data set,
  Get 3mo, 6mo, 1, 2, 3yr returns 
  to year end 2006 for each fund
  
  keep the fund code and the 5 returns
  so, 6 rows, 7 variables*/

/**First, set up the data for processing...*/
proc sort data=sasdata.mutualfunds out=fundSort;
    by indiceCode descending date;
    /**backwards in time for each fund is convenient*/
    where date between 200401 and 200612;
    /**Subset to the time window we are using
      for calculations*/
run;

data returns3mo;
  set fundSort;
  by indiceCode;

  retain TotalReturn;

  /**Get the 3 month return for each fund...*/
  if first.indiceCode then TotalReturn = 1; /**When a fund's data starts */

  TotalReturn = TotalReturn*(1+return);

  /**3 month return??*/

  if mod(_n_,36) eq 3 then output;/**this works, but it is probably more
                                  common to use a custom counter*/

run;


data returns3mo;
  set fundSort;
  by indiceCode;

  retain TotalReturn month;

  /**Get the 3 month return for each fund...*/
  if first.indiceCode then do; /**When a fund's data starts */
    TotalReturn = 1;
    Month = 0;
  end;

  month = month + 1;/**Count Months*/
  TotalReturn = TotalReturn*(1+return);

  if month = 3 then do;
    Ret3Month = TotalReturn - 1;
    output;
  end;

  keep Indice: Ret3Month;
  format Ret3Month percentn8.2;
  label Ret3Month = '3 Month Return';

run;

data returns3And6mo;
  set fundSort;
  by indiceCode;

  retain TotalReturn month Ret3Month;

  /**Get the 3 month return for each fund...*/
  if first.indiceCode then do; /**When a fund's data starts */
    TotalReturn = 1;
    Month = 0;
  end;

  month = month + 1;/**Count Months*/
  TotalReturn = TotalReturn*(1+return);

  if month = 3 then Ret3Month = TotalReturn - 1;

  if month = 6 then do;
    Ret6Month = TotalReturn - 1;
    output;
  end;

  keep Indice: Ret:;
  format Ret: percentn8.2;
  label Ret3Month = '3 Month Return'
        Ret6Month = '6 Month Return';

run;

data returns;
  set fundSort;
  by indiceCode;

  retain TotalReturn month Ret3Month Ret6Month Ret1Year Ret2Year;

  if first.indiceCode then do; 
    TotalReturn = 1;
    Month = 0;
  end;

  month = month + 1;
  TotalReturn = TotalReturn*(1+return);

  if month = 3 then Ret3Month = TotalReturn - 1;
  if month = 6 then Ret6Month = TotalReturn - 1;
  if month = 12 then Ret1Year = TotalReturn - 1;
  if month = 24 then Ret2Year = TotalReturn - 1;

  if month = 36 then do;
    Ret3Year = TotalReturn - 1;
    output;
  end;

  keep Indice: Ret:;
  format Ret: percentn8.2;
  label Ret3Month = '3 Month Return'
        Ret6Month = '6 Month Return'
        Ret1Year = ' 1 Year Return'
        Ret2Year = ' 2 Year Return'
        Ret3Year = ' 3 Year Return';
run;


data returnsB;
  set fundSort;
  by indiceCode;

  retain TotalReturn Ret3Month Ret6Month Ret1Year Ret2Year;

  if first.indiceCode then do; 
    TotalReturn = 1;
    Month = 0;
  end;

  month + 1;
    /* A + expression;  SUM STATEMENT 
      adds the result of the expression to A and updates it
        A is automatically retained
        A is automatically set to 0 when the data step starts*/

  TotalReturn = TotalReturn*(1+return);

  if month = 3 then Ret3Month = TotalReturn - 1;
  if month = 6 then Ret6Month = TotalReturn - 1;
  if month = 12 then Ret1Year = TotalReturn - 1;
  if month = 24 then Ret2Year = TotalReturn - 1;

  if month = 36 then do;
    Ret3Year = TotalReturn - 1;
    output;
  end;

  keep Indice: Ret:;
  drop Return;
  format Ret: percentn8.2;
  label Ret3Month = '3 Month Return'
        Ret6Month = '6 Month Return'
        Ret1Year = ' 1 Year Return'
        Ret2Year = ' 2 Year Return'
        Ret3Year = ' 3 Year Return';
run;

/**What if I wanted it as columns for code and name 
    plus a column for the month and that month's return...*/

data returnsVertical;
  set fundSort;
  by indiceCode;

  retain TotalReturn;

  if first.indiceCode then do; 
    TotalReturn = 1;
    Month = 0;
  end;

  month + 1;
    /* A + expression;  SUM STATEMENT 
      adds the result of the expression to A and updates it
        A is automatically retained
        A is automatically set to 0 when the data step starts*/

  TotalReturn = TotalReturn*(1+return);

  if month = 3 then do;
    Ret = TotalReturn - 1;
    output;
  end;
  if month = 6 then do;
    Ret = TotalReturn - 1;
    output;
  end;
  if month = 12 then do;
    Ret = TotalReturn - 1;
    output;
  end;
  if month = 24 then do;
    Ret = TotalReturn - 1;
    output;
  end;
  if month = 36 then do;
    Ret = TotalReturn - 1;
    output;
  end;

  keep Indice: Month Ret;
  format Ret percentn8.2;

run;