libname SASData '~/SASData';

proc format;
  value $pollutant
    'CO'='Carbon Monoxide'
    'LEAD'='Lead'
    'SO2'='Sulfur-Dioxide'
    'O3'='Ozone'
    'TSP'='Total Suspended Particulates'
    ;
run;

/**The value statement names the format, and sets its rules
    Format names must:
      1. Begin with $ if they are for character values (and must not if for numeric)
      2. The remaining characters are letters, digits, underscores to a max of 32 (including $)
            and it must not end in digits (that's where length goes)
      3. When creating the name, the dot is not included (when using it later, it must be present)
**/ 

proc freq data=sasdata.projects;
  table pol_type;
  format pol_type $pollutant.;
run;


/**This wouldn't make much sense...**/
proc freq data=sasdata.projects;
  table pol_type*jobtotal;
  format pol_type $pollutant.;
run;/**jobtotal is not categorical...**/

proc format;
  value jobtotal
    0-40000='Up to $40,000'
    40000-80000='$40,000 to $80,000'
    80000-1000000='More than $80,000'
    ;
run;

proc freq data=sasdata.projects;
  table pol_type*jobtotal;
  format pol_type $pollutant. jobtotal jobtotal.;
run;
    
proc sgplot data=sasdata.projects;
  hbar jobtotal / stat=percent;
  format jobtotal jobtotal.;
run;

proc sgplot data=sasdata.projects;
  hbar pol_type  / stat=percent group=jobtotal groupdisplay=cluster;
  format pol_type $pollutant. jobtotal jobtotal.;
run;

proc format;
  value jobtotal
    low-<40000='Less Than $40,000'
    40000-<80000='$40,000 to $80,000'
    80000-high='$80,000 or More'
    ;
run;

proc freq data=sasdata.projects;
  table pol_type*jobtotal;
  format pol_type $pollutant. jobtotal jobtotal.;
run;
