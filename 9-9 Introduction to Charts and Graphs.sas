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