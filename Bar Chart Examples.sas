/**SGPLOT is used to make individual graphs...**/

proc sgplot data=sashelp.cars;
  hbar origin;
  /**hbar--horizontal bar chart**/
run;
proc sgplot data=sashelp.cars;
  vbar type;
  /**vbar-vertical
    each summarizes frequency in each category of the listed variable**/
run;

proc sgplot data=sashelp.stocks;
  hbar date;
  where high gt 100;
run;/**for the charting variable in HBAR or VBAR, each distinct
      value is a category/bar (like CLASS in MEANS and TABLE in FREQ)**/

proc sgplot data=sashelp.stocks;
  hbar date;
  where high gt 100;
  format date qtr.; /**categorization is done with respect to the active format**/
run;  

proc sgplot data=sashelp.cars;
  hbar origin / stat=pct;
  /**the summary statistic is changeable -> for categories only, you can have 
        frequency (default) or percent**/ 
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city;
  /***response= chooses a numeric (quantitative) variable to summarize**/
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=median;
  /***when response= is active, mean, median, or sum(default) are available statistics**/
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=percent;
  /**If you mismatch the stat= type and response= request...***/
run;
proc sgplot data=sashelp.cars;
  hbar origin / stat=mean;
  /**a component is ignored (the quantitative part)**/ 
run;


proc sgplot data=sashelp.stocks;
  hbar stock / response=volume group=date;
  /**GROUP= splits the bars into pieces corresponding to the different levels of the 
      variable -> categorization. This should be a limited set of categories
        either natively or via formatting**/
  format date qtr.;
run;


proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=median group=type;
  /**default behavior of stacking is not particularly appropriate for mean or median**/
  where type in ('SUV','Truck');
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=median group=type groupdisplay=cluster;
  /**The CLUSTER groupdisplay creates a separate bar for each level of the group variable
      at each level of the charting variable**/
  where type in ('SUV','Truck');
run;

proc sgplot data=sashelp.cars;
  hbox mpg_city / group=origin;
run;

proc sgplot data=sashelp.cars;
  hbox mpg_city / category=origin;
run;

/**Some statements make plots, like HBAR, HBOX, VBAR, VBOX,...
    some statements style elements of the graph**/
proc sgplot data=sashelp.cars;
  hbar origin / response=msrp stat=mean;
  xaxis values=(0 to 50000 by 2500) fitpolicy=stagger;
  /**axis (x or y) modify axis items--values are the items placed at each major tick**/
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=msrp stat=mean;
  xaxis values=(0 to 50000 by 5000) label='Average Retail Price' labelpos=right;
  /**can set a label and its position**/
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=msrp stat=mean;
  yaxis display=(nolabel);
  /**display is used to turn things off, typically...**/
  xaxis values=(0 to 50000 by 5000) label='Average Retail Price' labelpos=right;
run;


proc sgplot data=sashelp.cars;
  hbar origin / response=msrp stat=mean group=origin;
  yaxis display=none;
  /**...and that can be none of the axis features at all**/
  xaxis values=(0 to 50000 by 5000) label='Average Retail Price' labelpos=right;
run;

proc sgplot data=sashelp.cars noborder;
  /**the axes are completed into a rectangular border, which can be removed**/
  hbar origin / response=msrp stat=mean group=origin;
  yaxis display=none;
  xaxis values=(0 to 50000 by 5000) label='Average Retail Price' labelpos=right;
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=msrp stat=mean;
  yaxis display=(nolabel) valueattrs=(weight=bold color=blue);
    /**valueattrs= sets options for the text that is placed at the major tick marks**/
  xaxis values=(0 to 50000 by 5000) label='Average Retail Price' 
        labelattrs=(family='Montseratt' style=italic size=12pt);
        /**labels are text, so labelattrs= controls those text attributes**/
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=msrp stat=mean;
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
    /**you can specify colors with various models--one is RGB
          cxRRGGBB where each pair is in hex (00 to FF -> 0 to 255)**/
  xaxis values=(0 to 50000 by 5000) label='Average Retail Price' 
        labelattrs=(family='Montseratt' style=italic size=12pt);
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=msrp stat=mean;
  yaxis display=(nolabel) valueattrs=(weight=bold color=mediumvividreddishblue);
  xaxis values=(0 to 50000 by 5000) label='Average Retail Price' 
        labelattrs=(family='Montseratt' style=italic size=12pt);
run;