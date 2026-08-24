proc print data=sashelp.cars;
  where msrp ge 50000;
  /* ge same as >= */
run;

/*data set options are permitted any time you reference a data set
they are contained in parentheses and appended to the data set name*/
/*WHERE is one of them
    dataSetName(where=(conditions)) 
    */
proc print data=sashelp.cars(where=(msrp ge 50000));
run;

proc sort data=sashelp.cars(where=(msrp ge 50000)) out=carsSort(keep=Make Model MSRP);
  by descending MSRP;
run;

proc sort data=sashelp.cars out=carsSort(where=(msrp ge 50000) keep=Make Model MSRP);
  by descending MSRP;
run;

proc sort data=sashelp.cars(where=(msrp ge 50000) keep=Make Model MSRP) out=carsSort;
  by descending MSRP;
run;

proc print data=sashelp.cars;
  where msrp ge 50000 and origin eq 'Asia';
run;

proc print data=sashelp.cars;
  where msrp ge 50000 or origin eq 'Asia';
run;/*AND / OR are available (and so are parentheses)*/

proc print data=sashelp.cars;
  where model contains '4dr';
  /**contains 'substring' is true if the substring is found in the 
      value of the character variable*/
run;

proc print data=sashelp.cars;
  where model contains '4DR';
  /**all character matching is case-sensitive*/
run;

proc print data=sashelp.cars;
  where type eq 'Sedan' or type eq 'Wagon' or 'Sports';
run;

proc print data=sashelp.cars;
  where type in ('Sedan' 'Wagon' 'Sports');
run;

proc print data=sashelp.cars;
  where type in ('Sedan','Wagon','Sports');
run;/*IN is true for a match of any list element,
      lists can be comma or space separated*/

proc print data=sashelp.cars;
  where type not in ('Sedan','Wagon','Sports');
run;

proc print data=sashelp.cars;
  where msrp between 40000 and 60000;
  /** between A and B is equivalent to ge A and le B */
run;

proc print data=sashelp.cars;
  where model like '%4dr%';
  /**LIKE allows for wildcard characters, 
      % is any set of characters, including none... */
run;

proc print data=sashelp.cars;
  where model like '%4dr';
  /**LIKE allows for wildcard characters, 
      % is any set of characters, including none... */
run;

proc print data=sashelp.cars;
  where make like '_o%';
  /**_ is a single character*/
run;

/**Behaviors*/
proc print data=sashelp.cars;
  where msrp ge 40000 and 60000 > msrp;
run;

proc print data=sashelp.cars;
  where msrp ge 40000 and le 60000;
run;

proc print data=sashelp.cars;
  where msrp ge 40000 and < 60000;
run;


proc print data=sashelp.cars;
  where msrp ge 40000 or 60000;
run;
/*for evaluation, missing or 0 is false,
                everything else is true
                msrp ge 40000 or true...*/

proc print data=sashelp.cars;
  where msrp ge 40000 and 60000;
        /*msrp ge 40000 and true -> msrp ge 40000*/
run;

proc means data=sashelp.cars;
  where msrp ge 50000;
run;

data myCars;
  set sashelp.cars;
  where msrp ge 50000;
run;