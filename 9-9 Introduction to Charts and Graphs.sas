libname SASData '~/SASData';

title 'Systolic Distribution for Females';
proc sgplot data=sashelp.heart;
  histogram systolic;
  where substr(sex,1,1) eq 'F';
run;
/*histogram is hopefully what you expect...*/

title 'Systolic Distribution for Females';
proc sgplot data=sashelp.heart;
  histogram systolic / binstart=80 binwidth=40;
    /*binstart is the MIDPOINT of the first bin...*/
  where substr(sex,1,1) eq 'F';
run;

title 'Systolic Distribution for Females';
proc sgplot data=sashelp.heart;
  histogram systolic / binstart=100 binwidth=40;
    /*binstart is the MIDPOINT of the first bin...*/
  where substr(sex,1,1) eq 'F';
run;

title 'Systolic Distribution for Females';
proc sgplot data=sashelp.heart;
  histogram systolic / binstart=100 binwidth=40
                        showbins;
    /*SHOWBINS -> axis ticks are the midpoints*/
  where substr(sex,1,1) eq 'F';
run;

title 'Systolic Distribution for Females';
proc sgplot data=sashelp.heart;
  histogram systolic / binstart=100 binwidth=40
                        showbins dataskin=sheen scale=proportion;
  where substr(sex,1,1) eq 'F';
run;

/**various settings for axes are available...*/
title 'Systolic Distribution for Females';
proc sgplot data=sashelp.heart;
  histogram systolic / binstart=100 binwidth=40
                        showbins dataskin=sheen scale=proportion;
  where substr(sex,1,1) eq 'F';
  xaxis label='Systolic Blood Pressure'
        labelattrs=(color=blue family='Monseratt' 
                      size=12pt weight=bold style=italic);
run;

title 'Systolic Distribution for Females';
proc sgplot data=sashelp.heart;
  histogram systolic / binstart=100 binwidth=40
                        dataskin=sheen scale=proportion;
  where substr(sex,1,1) eq 'F';
  xaxis label='Systolic Blood Pressure'
        labelattrs=(color=blue family='Monseratt' 
                      size=12pt weight=bold style=italic)
        values=(80 to 320 by 40);
  yaxis values=(0 to 0.7 by 0.1) valueattrs=(color=red weight=bold)
          labelpos=top valuesformat=percent6.;
run;

title 'Systolic Distribution for Females';
proc sgplot data=sashelp.heart;
  histogram systolic / binstart=100 binwidth=40
                        dataskin=sheen scale=proportion;
  where substr(sex,1,1) eq 'F';
  xaxis label='Systolic Blood Pressure'
        labelattrs=(color=blue family='Monseratt' 
                      size=12pt weight=bold style=italic)
        values=(80 to 320 by 40);
  yaxis values=(0 to 0.7 by 0.1) valueattrs=(color=red weight=bold)
          labelpos=top valuesformat=percent6.
          label=' ';
          /*I can blank out a label, but the space on the graph is
              still allocated to put it there*/
run;

title 'Systolic Distribution for Females';
proc sgplot data=sashelp.heart;
  histogram systolic / binstart=100 binwidth=40
                        dataskin=sheen scale=proportion;
  where substr(sex,1,1) eq 'F';
  xaxis label='Systolic Blood Pressure'
        labelattrs=(color=blue family='Monseratt' 
                      size=12pt weight=bold style=italic)
        values=(80 to 320 by 40);
  yaxis values=(0 to 0.7 by 0.1) valueattrs=(color=red weight=bold)
          valuesformat=percent6.
          display=(nolabel);
          /*DISPLAY= can be used to turn stuff off...*/
run;

title 'Systolic Distribution';
proc sgplot data=sashelp.heart;
  histogram systolic / binstart=100 binwidth=40
                        dataskin=sheen scale=proportion
                        group=sex;
        /*some options are unwise...*/
  xaxis label='Systolic Blood Pressure'
        labelattrs=(color=blue family='Monseratt' 
                      size=12pt weight=bold style=italic)
        values=(80 to 320 by 40);
  yaxis values=(0 to 0.7 by 0.1) valueattrs=(color=red weight=bold)
          valuesformat=percent6.
          display=(nolabel);
run;

title 'Systolic Distribution';
proc sgpanel data=sashelp.heart;
  panelby sex / columns=1;
  histogram systolic / binstart=100 binwidth=40
                        dataskin=sheen scale=proportion;
  colaxis label='Systolic Blood Pressure'
        labelattrs=(color=blue family='Monseratt' 
                      size=12pt weight=bold style=italic)
        values=(80 to 320 by 40);
  rowaxis values=(0 to 0.7 by 0.1) valueattrs=(color=red weight=bold)
          valuesformat=percent6.
          display=(nolabel);
run;


/*HBOX and VBOX are available plotting statements...*/
proc sgplot data=sasdata.cdi;
  hbox inc_per_cap;
run;

proc sgplot data=sasdata.cdi;
  hbox inc_per_cap / extreme;
    /**Extreme (schematic box plot) -- straight 5-number summary,
                                        no outliers indicated */
run;

proc sgplot data=sasdata.cdi;
  hbox inc_per_cap / boxwidth=.3 capscale=.5 capshape=bracket;
run;

proc sgplot data=sasdata.cdi;
  hbox inc_per_cap / fillattrs=(color=orange)
                     meanattrs=(color=green symbol=squarefilled)
                     medianattrs=(color=blue thickness=4pt)
                     whiskerattrs=(color=lightblue thickness=3pt)
                     outlierattrs=(color=red symbol=trianglefilled);
run;

/**plots typically support grouping...*/
proc sgplot data=sasdata.cdi;
  hbox inc_per_cap / group=region;
run;/**grouping produces a legend, which can be modified with KEYLEGEND*/

proc sgplot data=sasdata.cdi;
  hbox inc_per_cap / group=region;
  keylegend / location=inside position=bottomright;

  /**KEYLEGNED legend-names / options;
      legend-names can be empty -> options apply to all legends created*/
run;

proc sgplot data=sasdata.cdi;
  hbox inc_per_cap / group=region;
  keylegend / location=inside position=topright across=1
                noborder title='Region';
run;

proc format;
    value reg
    1='Northeast'
    2='North-Central'
    3='South'
    4='West'
    ;
run;
proc sgplot data=sasdata.cdi;
  hbox inc_per_cap / group=region;
  keylegend / location=inside position=topright across=1
                noborder title='Region';
  format region reg.;
run;

proc sgplot data=sasdata.cdi;
  hbox inc_per_cap / datalabel=region whiskerpct=5;
run;

/**a category is like a group, but it produces an axis instead
    of a legend... */
proc sgplot data=sasdata.cdi;
  hbox inc_per_cap / category=region;
  format region reg.;
  yaxis display=(nolabel);
run;

proc sgplot data=sasdata.cdi noautolegend;
  /**can create a color set with group and suppress the 
      legend with NOAUTOLEGEND */
  hbox inc_per_cap / category=region group=region;
  format region reg.;
  yaxis display=(nolabel);
  xaxis valuesformat=dollar12.;
run;


/**There are a variety of Bar Chart statements... */

proc sgplot data=sashelp.cars;
   hbar origin / stat=percent;
   /**The variable request here is treated as categorical,
        default summary is frequency*/
run;

proc sgplot data=sashelp.cars;
   hbar msrp / stat=percent;
   /*not a good choice, msrp is not categorical...*/
run;

proc format;
    value price
    low-<30000 = 'Up to $30,000'
    30000-60000 = '$30,000 to $60,000'
    60000-high = 'More than $60,000'
    ;
run;


proc sgplot data=sashelp.cars;
   hbar msrp / stat=percent;
   format msrp price.;
   /**categories are constructed with respect to the active format */
run;

proc sgplot data=sashelp.cars;
    hbar type / group=origin;
      /**groups are supported--groups are categorical as well
      
          bars are stacked, by default*/
run;

proc sgplot data=sashelp.cars;
    hbar type / group=origin groupdisplay=cluster;
run;

proc sgplot data=sashelp.cars;
    hbar type / group=msrp groupdisplay=cluster;
    format msrp price.;
run;


proc sgplot data=sashelp.cars;
   hbar origin / stat=percent barwidth=.5;
run;

proc sgplot data=sashelp.cars;
   hbar origin / stat=percent fillattrs=(color=cyan)  nooutline;
run;

proc sgplot data=sashelp.cars;
   hbar origin / stat=percent fillattrs=(color=cyan)  
                  outlineattrs=(color=blue);
run;

proc sgplot data=sashelp.cars;
   hbar origin / stat=percent fillattrs=(color=cyan)  
                  outlineattrs=(color=blue)
                  categoryorder=respdesc;
run;

proc sgplot data=sashelp.cars;
   hbar origin / response=msrp stat=mean;
run;

proc sgplot data=sashelp.cars;
   hbar origin / response=msrp stat=mean
                  group=type groupdisplay=cluster;
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_highway stat=mean;
  hbar origin / response=mpg_city stat=mean;
run;/**Overlaying is possible, this also generates a legend...*/

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_highway stat=mean;
  hbar origin / response=mpg_city stat=mean
                  barwidth=0.6;
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean fillattrs=(color=red)
                outlineattrs=(color=black);
  hbar origin / response=mpg_highway stat=mean
                  barwidth=0.6 transparency=0.3
                  fillattrs=(color=blue) outlineattrs=(color=black);
  /*can play with width and transparency to make these work better 
    together*/
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean fillattrs=(color=red)
                outlineattrs=(color=black) legendlabel='City';
  hbar origin / response=mpg_highway stat=mean
                  barwidth=0.6 transparency=.3
                  fillattrs=(color=blue) outlineattrs=(color=black)
                  legendlabel='Highway';
  yaxis label='Average MPG';
  /*LEGENDLABEL= is available to set legend values in overlays*/
run;

proc sgplot data=sashelp.cars;
  hbar origin / response=mpg_city stat=mean fillattrs=(color=red)
                outlineattrs=(color=black) legendlabel='City'
                barwidth=0.4 discreteoffset=0.21;
  hbar origin / response=mpg_highway stat=mean fillattrs=(color=blue) 
                outlineattrs=(color=black) legendlabel='Highway'
                barwidth=0.4 discreteoffset=-0.21;
  yaxis label='Average MPG';
  /*discreteoffset moves the plot element with respect to major
    ticks on a discrete axis. Each major tick has coordinate 0 and
    you may move in the range -0.5 to 0.5*/
run;

proc sgplot data=sashelp.cars;
  scatter x=horsepower y=mpg_highway;
run;/**scatterplots must use numeric variables for X= and Y=
      (both required) and they really should be quantitative,
        though not absolutely necessary... */

/*Graph area has a Marker for each point, which is styleable*/
proc sgplot data=sashelp.cars;
  scatter x=horsepower y=mpg_highway / markerattrs=(color=green 
                                        symbol=trianglefilled);
run;

proc sgplot data=sashelp.cars;
  scatter x=horsepower y=mpg_highway / filledoutlinedmarkers
      markerattrs=(symbol=trianglefilled size=10pt)
      markerfillattrs=(color=green) markeroutlineattrs=(color=red);
run;

/**Curve fitting is available for scatter plotting as separate
  statements... */
proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway;
run;

proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway / degree=3 lineattrs=(color=cyan);
run;


proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway / degree=3 lineattrs=(color=cyan)
                                      nomarkers;
run;

proc sgplot data=sashelp.cars;
  pbspline x=horsepower y=mpg_highway;
run;

proc sgplot data=sashelp.cars;
  loess x=horsepower y=mpg_highway;
run;


proc sgplot data=sashelp.cars;
  pbspline x=horsepower y=mpg_highway / smooth=1000;
run;

proc sgplot data=sashelp.cars;
  loess x=horsepower y=mpg_highway / smooth=.1;
run;

/**For any of these, grouping is available... */
proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway / degree=3 group=origin;
  keylegend / title='' across=1 position=topright location=inside;
run;

proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway / degree=3 group=origin nomarkers
                                    name='Poly';
  scatter x=horsepower y=mpg_highway / group=origin
                                    name='Points';
  keylegend 'Points' / title='' across=1 position=topright location=inside;
run;

proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway / degree=3 group=origin nomarkers
                                    name='Poly';
  scatter x=horsepower y=mpg_highway / group=origin
                                    name='Points';
  keylegend 'Points' / title='' across=1 position=topright location=inside;
  keylegend 'Poly' / title='' position=bottomright location=inside 
                      noborder;
run;

/*overlays are possible, must match on one of the variables...*/
proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway / legendlabel='Highway';
  reg x=horsepower y=mpg_city / legendlabel='City';
run;


proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway / legendlabel='Highway';
  reg x=horsepower y=MSRP / legendlabel='Suggested Price';
run;/**Scale differences are dominated by the larger scale... */

proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway / legendlabel='Highway' y2axis;
    /*y2axis allows for a separate vertical axis on the right of the frame*/
  reg x=horsepower y=MSRP / legendlabel='Suggested Price';
run;

/**Those axes are separable for styling... */
proc sgplot data=sashelp.cars;
  reg x=horsepower y=mpg_highway / legendlabel='Highway' y2axis;
  reg x=horsepower y=MSRP / legendlabel='Suggested Price';
  yaxis labelpos=top values=(0 to 200000 by 25000);
  y2axis labelpos=top valueattrs=(color=lightblue);
run;

/**What if I want to change colors/styles across levels when a group is
  active? In ??ATTRS= I only can set one value...*/
proc sgplot data=sashelp.cars;
  styleattrs datacontrastcolors=(purple lightcoral gray)
              datasymbols=(squarefilled circlefilled trianglefilled);
  reg x=horsepower y=mpg_highway / degree=3 group=origin;
  keylegend / title='' across=1 position=topright location=inside;
run;

/*default cycling for lines and markers is to change colors until you
  run out, then change symbols*/
proc sgplot data=sashelp.cars;
  styleattrs datacontrastcolors=(purple)
              datasymbols=(squarefilled circlefilled trianglefilled);
  reg x=horsepower y=mpg_highway / degree=3 group=origin;
  keylegend / title='' across=1 position=topright location=inside;
run;

ods graphics / attrpriority=none;
/**NONE -> all three, symbol, linepatter, color cycle across
          groups */
proc sgplot data=sashelp.cars;
  styleattrs datacontrastcolors=(purple lightcoral gray)
              datasymbols=(squarefilled circlefilled trianglefilled);
  reg x=horsepower y=mpg_highway / degree=3 group=origin;
  keylegend / title='' across=1 position=topright location=inside;
run;

proc sgplot data=sashelp.cars;
  styleattrs datacontrastcolors=(mediummoderateyellowishgreen gray44 cx01665e)
              datasymbols=(squarefilled circlefilled trianglefilled)
              datalinepatterns=(solid);
  reg x=horsepower y=mpg_highway / degree=3 group=origin;
  keylegend / title='' across=1 position=topright location=inside;
run;