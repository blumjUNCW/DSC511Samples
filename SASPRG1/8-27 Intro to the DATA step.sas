data heart; /*In the DATA statement, name the data set(s) to create*/
  set sashelp.heart; /*set allows you to choose the data set(s) to read*/
run;/**As the DATA step executes...
        Read each record from the table listed in SET--one a time
        Execute any statements on that record
        Output the final record
        Return to read another (if any remain)*/

data carsAsia;
  set sashelp.cars;
  where origin eq 'Asia';
  /*where processing is available in the DATA step*/
run;

data carsAsiaB;
  set sashelp.cars(where=(origin eq 'Asia'));
  /*where processing is available as an option on the
      table in SET*/
run;
/**Using the WHERE statement is equivalent to putting
  the WHERE option on the input data table*/

data carsAsiaC(where=(origin eq 'Asia'));
  /*where processing is available as an option on the
      table in DATA*/
  set sashelp.cars;
run;

data cars;
  set sashelp.cars;

  /**I can use artithmetic/mathematical expressions to define new variables*/
  mpg_combo = 0.6*mpg_city + 0.4*mpg_highway;
  /* variable = expression; */
  /* I am not required to declare/type a new variable (I can),
      compiler reviews the expression to determine the variable's attributes*/ 
run;


data carsB;
  set sashelp.cars;

  mpg_combo = 0.6*mpg_city + 0.4*mpg_highway;
  PriceRatio = MSRP/Invoice;

  format priceRatio percentn8.1;
  label mpg_combo = "EPA Combined MPG" priceRatio = "MSRP:Invoice Ratio";
  /**When you make data, you can set default labels and formats*/
run;

proc means data=carsB;
  class origin;
  var priceRatio mpg_combo;
run;

data carsC;
  format priceRatio percentn8.1;
  label mpg_combo = "EPA Combined MPG" priceRatio = "MSRP:Invoice Ratio";
  /**Things like FORMAT and LABEL are what are called compile-time
    statments--they're reviewed by compiler and attributes are assigned...*/

  set sashelp.cars;

  mpg_combo = 0.6*mpg_city + 0.4*mpg_highway;
  PriceRatio = MSRP/Invoice;

run;

data carsD;
  format priceRatio MSRPIncrease percentn8.1;
  label mpg_combo = "EPA Combined MPG" priceRatio = "MSRP:Invoice Ratio"
        MSRPIncrease = '% Increase of MSRP Over Invoice';

  set sashelp.cars;

  PriceRatio = MSRP/Invoice;
  MSRPIncrease = PriceRatio - 1;
  mpg_combo = 0.6*mpg_city + 0.4*mpg_highway;
  
run;

data carsE;
  format priceRatio MSRPIncrease percentn8.1;
  label mpg_combo = "EPA Combined MPG" priceRatio = "MSRP:Invoice Ratio"
        MSRPIncrease = '% Increase of MSRP Over Invoice';

  set sashelp.cars;

  mpg_combo = 0.6*mpg_city + 0.4*mpg_highway;
  MSRPIncrease = PriceRatio - 1;
  PriceRatio = MSRP/Invoice;
  /**Execution-time statements can be order sensitive*/
  
run;

data AnyNot;
  set sashelp.cars;

  AnyAlpN = anyalnum(left(model));
  NotAlpN = notalnum(left(model));

  Digit = anydigit(left(model));
  Punctuation = anypunct(left(model));
  
run;

data concatenate;
  set sashelp.cars;

  OriginType = cat(origin,type);
  /**CAT sticks things together with any leading and trailing blanks 
      preserved */
  OriginTypeS = cats(origin,type);
  /*CATS Strips leading and trailing blanks, then concatenates*/
  OriginTypeX = catx('-',origin,type);
  /*CATX -- first argument is a delimiter, used between all other chosen
      variables after applying CATS*/
run;


data scan;
  set sashelp.cars;

  scan1 = scan(left(model),1);
  scan2 = scan(left(model),2);

  scan1space = scan(left(model),1,' ');
  scan2space = scan(left(model),2,' ');
run;
