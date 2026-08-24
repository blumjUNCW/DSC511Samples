proc contents data=sashelp.stocks varnum;
run;

proc print data=sashelp.stocks(obs=10);
run;


proc print data=sashelp.stocks(obs=10);
    format date mmddyy10. low high open close 6.2;
    /**FORMAT variable-list formatA. variable-list formatB. ....; */
run;

/**format names look like
    1. numeric -- nameW.D and name can be null (i.e. W.D is a legal name)
            W is the total width available for formatted values
            D (if applicable) number of digits to display after decimal
    2. character -- $nameW. */
/*Format naming conventions--
    1. Up to 32 characters
    2. Letters, digits, underscores, and the dollar sign
    3. Dollar sign must start all character format names,
        Letter, underscore, or null for numeric
    4. When defining a format, you may not include digits at the end
        of the name (and you really should not include them at all)
 */
proc print data=sashelp.stocks(obs=10);
    format date mmddyy8. low high open close 14.2;
    /**FORMAT variable-list formatA. variable-list formatB. ....; */
run;

proc print data=sashelp.stocks(obs=10);
    format date weekdate. low high open close 14.2;
run;

proc print data=sashelp.stocks(obs=10);
    format date year. low high open close 14.2;
run;

proc freq data=sashelp.stocks;
  table date*stock;
  format date month.;
  /**Any time SAS treats a variable as categorical, it
    uses the active format to determine the categories*/
run;


proc means data=sashelp.stocks;
  var high;
  class stock date;
  format date year.;
run;
