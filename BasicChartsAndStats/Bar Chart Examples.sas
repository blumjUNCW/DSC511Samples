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
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=msrp stat=mean;
  yaxis display=(nolabel) valueattrs=(weight=bold color=mediumvividreddishblue);
  xaxis values=(0 to 50000 by 5000) label='Average Retail Price' 
        labelattrs=(family='Montseratt' style=italic size=12pt);
run;


proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster;
  where type ne 'Hybrid';
  /**the legend can be modified with the KEYLEGEND statement**/
  keylegend  / border position=topleft;
  /***KEYLEGEND name / options; name can be, and often is, blank
      position= moves the legend around the frame**/
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;


proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster;
  where type ne 'Hybrid';
  keylegend  / border position=bottomright location=inside;
    /**location= inside or outside the graphing area**/
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster ;
  where type ne 'Hybrid';
  keylegend  / border position=bottomright location=inside across=1;
    /**across= limits the available columns, down= limits rows (typically you pick one)**/
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster ;
  where type ne 'Hybrid';
  keylegend  / border position=topright location=inside across=1;
    /**sometimes the legend doesn't exactly fit where you may want it...**/
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt)
        offsetmax=0.04;
  /**offsetmax=0.025 -> distance between last tick and edge of box
                            is 2.5% of the available area**/
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster ;
  where type ne 'Hybrid';
  keylegend  / border position=topright location=inside across=1
                title='';
      /**there is no label for a legend, it's a title.
          to remove it, use a null string (not a blank)**/
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt)
        offsetmax=0.04;
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster ;
  where type ne 'Hybrid';
  keylegend  / border position=topright location=inside across=1
                title='' valueattrs=(color=cx31D942 weight=bold);
      /**attrs are available for title and values in the legend**/
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt)
        offsetmax=0.04;
run;


proc sgplot data=sashelp.cars;
  where type ne 'Hybrid';
  hbar origin / response=mpg_highway stat=mean;
  hbar origin / response=mpg_city stat=mean;
  /**you can have multiple plotting statements inside a procedure,
      the first one is put down first, second is next, and so on...
      color cycling is automatic and so is the legend**/
  yaxis display=(nolabel) valueattrs=(weight=bold);
  xaxis values=(0 to 30 by 5) label='Average MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;


proc sgplot data=sashelp.cars;
  where type ne 'Hybrid';
  hbar origin / response=mpg_city stat=mean;
  hbar origin / response=mpg_highway stat=mean transparency=.3;
  /**transparency= is also a proportion: default is 0 -> fully opaque
        1 is the max, fully transparent**/
  yaxis display=(nolabel) valueattrs=(weight=bold);
  xaxis values=(0 to 30 by 5) label='Average MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;

proc sgplot data=sashelp.cars;
  where type ne 'Hybrid';
  hbar origin / response=mpg_city stat=mean;
  hbar origin / response=mpg_highway stat=mean 
                  transparency=.3 barwidth=0.6;
  /**barwidth= is a proportion, too. It is the proportion of
      space allocated to the bar**/
  yaxis display=(nolabel) valueattrs=(weight=bold);
  xaxis values=(0 to 30 by 5) label='Average MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
run;

proc sgplot data=sashelp.cars;
  where type ne 'Hybrid';
  hbar origin / response=mpg_city stat=mean
                 barwidth=0.4 discreteoffset=0.2;
  hbar origin / response=mpg_highway stat=mean 
                 barwidth=0.4 discreteoffset=-0.2;
  /**discreteoffset= only works for a categorical/discrete axis
      moves the plotting position away from the major tick mark (default center)**/
  keylegend / position=bottomright location=inside;
  yaxis display=(nolabel) valueattrs=(weight=bold);
  xaxis values=(0 to 30 by 5) label='Average MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
  label mpg_city = 'City' mpg_highway = 'Highway';
run;


proc sgplot data=sashelp.cars;
  where type ne 'Hybrid';
  hbar origin / response=mpg_city stat=mean
                 barwidth=0.4 discreteoffset=0.2
                 fillattrs=(color=cx6666FF);
  hbar origin / response=mpg_highway stat=mean 
                 barwidth=0.4 discreteoffset=-0.2
                 fillattrs=(color=cxFFAA66);
  /**fillattrs= can control color and transparency for bar fills**/
  keylegend / position=bottomright location=inside;
  yaxis display=(nolabel) valueattrs=(weight=bold);
  xaxis values=(0 to 30 by 5) label='Average MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
  label mpg_city = 'City' mpg_highway = 'Highway';
run;


proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster 
              fillattrs=(color=cx3333AA);
    /**setting one color is not so great for a group chart**/
  where type ne 'Hybrid';
  keylegend  / border position=topright location=inside across=1
                title='' valueattrs=(color=cx31D942 weight=bold);
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt)
        offsetmax=0.04;
run;


proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster 
              fillattrs=(color=cx3333AA cxFF3333 cxFFAA44);
    /**there's no way to give more than one color in fillattrs...**/
  where type ne 'Hybrid';
  keylegend  / border position=topright location=inside across=1
                title='' valueattrs=(color=cx31D942 weight=bold);
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt)
        offsetmax=0.04;
run;

proc sgplot data=sashelp.cars;
  styleattrs datacolors=(cxfbb4ae cxb3cde3 cxccebc5 cxdecbe4 cxfed9a6)
              datacontrastcolors=(black);
    /**styleattrs allows you to alter default style lists,
        datacolors= sets the fill colors

        datacontrastcolors= is for lines and markers,
          here I am setting it so that all bar outlines are black**/
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster;
  where type ne 'Hybrid';
  keylegend  / border position=topright location=inside across=1
                title='' valueattrs=(color=cx31D942 weight=bold);
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt)
        offsetmax=0.04;
run;

proc sgplot data=sashelp.cars;
  styleattrs datacolors=(cxfbb4ae cxb3cde3 cxccebc5 cxdecbe4 cxfed9a6)
              datacontrastcolors=(black);
  where type ne 'Hybrid';
  hbar origin / response=mpg_city stat=mean
                 barwidth=0.4 discreteoffset=0.2;
  hbar origin / response=mpg_highway stat=mean 
                 barwidth=0.4 discreteoffset=-0.2;
  keylegend / position=bottomright location=inside;
  yaxis display=(nolabel) valueattrs=(weight=bold);
  xaxis values=(0 to 30 by 5) label='Average MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt);
  label mpg_city = 'City' mpg_highway = 'Highway';
run;

proc sgplot data=sashelp.cars;
  styleattrs datacolors=(cxfbb4ae cxb3cde3)
              datacontrastcolors=(black);
  /**if the list is not long enough for your colors, but has more
      than one element, it tries to alter the gradient as it
      moves across categories**/
  hbar origin / response=mpg_city stat=mean group=type groupdisplay=cluster;
  where type ne 'Hybrid';
  keylegend  / border position=topright location=inside across=1
                title='' valueattrs=(color=cx31D942 weight=bold);
  yaxis display=(nolabel) valueattrs=(weight=bold color=cxFF0000);
  xaxis values=(0 to 25 by 5) label='Average City MPG' 
        labelattrs=(family='Liberation Sans' style=italic size=12pt)
        offsetmax=0.04;
run;
