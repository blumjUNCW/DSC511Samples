libname SASData '~/SASData';

proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
run;
/**You can add titles and footnotes with global statements--you can
  have up to lines of each**/

Title 'Five Number Summary';/**Title (=Title1) is the first title line...**/
Title2 'On Equipment, Personnel, and Total Cost';/**Title2 is the second...**/
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
run;

Title 'Five Number Summary';/**Title (=Title1) is the first title line...**/
Title2 'On Equipment, Personnel, and Total Cost';/**Title2 is the second...**/
footnote 'Stratified on Pollution Type and Region';/**footnotes are basically the same as
    titles, but they appear at the bottom -- it's global, make sure it is active
      prior to, or during procedure execution**/
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
run;

/**Titles are global statements both in terms of processing and effect...**/
proc freq data=sasdata.projects;
  table region*pol_type;
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
footnote 'Stratified on Pollution Type and Region';
footnote2 'Created on 8/26/2025';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
run;

Title2 'On Total Cost';
footnote 'Stratified on Region';
/**If provide a new version of a title or footnote line, that line is updated
    and expunge any others with a higher number **/
proc means data=sasdata.projects min q1 median q3 max;
  var jobtotal;
  class region;
run;

ods noproctitle;/**PROC titles can be removed with ODS NOPROCTITLE; -- global in effect**/
Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
footnote 'Stratified on Pollution Type and Region';
footnote2 'Created on 8/26/2025';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
run;

/***Labels can be set for the run of any procedure...***/
proc print data=sasdata.projects(obs=20) label noobs;
    /**can use dataset options--libref.dataset(options)--obs=20 says
      only process the first 20 observations/rows**/
run;

proc print data=sasdata.projects(obs=20) label noobs;
  var stname region pol_type equipmnt personel jobtotal;
  label stname='State' region='Region' pol_type='Pollution Type'
        equipmnt='Equipment Cost ($)'
        personel='Personnel Cost ($)'
        jobtotal='Total Cost ($)'
        ;/**you can set labels for as many variables as you like in a label statement**/
  /**the label statement is local to a procedure and is only in
    effect for its output**/
run;

proc print data=sasdata.cdi(obs=20) label noobs;
  var county land pop inc_per_cap;
  label land='Area, Square Miles';
run;

/**You can also change display styles using formats**/
proc print data=sasdata.projects(obs=20) label noobs;
  var stname region pol_type date equipmnt personel jobtotal;
  label stname='State' region='Region' pol_type='Pollution Type'
        date='Date of Job Completion'
        equipmnt='Equipment Cost ($)'
        personel='Personnel Cost ($)'
        jobtotal='Total Cost ($)'
        ;
  format equipmnt personel jobtotal dollar10.;
    /**format varA varB ... VarK thisFormat. ...;
          thisFormat applies to all variables listed before it**/
run;
  /**format names:
        must start with a $ if they are for character values (and must not if they're for numbers)
        follow the same conventions as variable names with one exception
        digits at the end (if included) define the total width allocated to formatted values
        must include a dot--either at the end or as a separator for numeric formats between
            total width and number of digits past the decimal to display**/

proc print data=sasdata.projects(obs=20) label noobs;
  var stname region pol_type date equipmnt personel jobtotal;
  label stname='State' region='Region' pol_type='Pollution Type'
        date='Date of Job Completion'
        equipmnt='Equipment Cost ($)'
        personel='Personnel Cost ($)'
        jobtotal='Total Cost ($)'
        ;
  format equipmnt personel jobtotal dollar8.2;
  /**formatW. W is the TOTAL width--if you set it too short, SAS
      will decide how to best deal with it (and put a note in the log)**/
run;

proc print data=sasdata.projects(obs=20) label noobs;
  var stname region pol_type date equipmnt personel jobtotal;
  label stname='State' region='Region' pol_type='Pollution Type'
        date='Date of Job Completion'
        equipmnt='Equipment Cost ($)'
        personel='Personnel Cost ($)'
        jobtotal='Total Cost ($)'
        ;
  format equipmnt personel jobtotal dollar12. date qtr.;
run;

proc format;
  value $pollute
    'CO' = 'Carbon Monoxide'
    'SO2' = 'Sulfur Dioxide'
    'LEAD' = 'Lead'
    'TSP' = 'Total Susp. Part.'
    'O3' = 'Ozone'
    ;
  value $polluteB
    'CO','O3' = 'Carbon Monoxide or Ozone'
    'SO2','LEAD','TSP' = 'Other'
    ;
run;


proc freq data=sasdata.projects;
  table pol_type;
  format pol_type $polluteB.;
run;

/***You can limit the data processed with WHERE statements**/
Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region eq 'Beaumont' or region eq 'Boston';
  /**Only processes records for which the condition is true**/
run;

/**Some items of note...**/
Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region eq 'beaumont' or region eq 'boston';
  /**Character values are case-sensitive (matching, sorting, and some other stuff)**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region eq 'Beaumont' or eq 'Boston';
  /**Compound conditions must contain a complete condition on
    each side of AND/OR**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region eq 'Beaumont' or 'Boston';
  /**evaluation of variables or values on their own is  
      based on 0/null being false, all other values true**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where pol_code eq 1 or 3;
  /** **/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region eq 'Beaumont' or pol_type eq 'CO';
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region in ('Beaumont','Boston');
    /**IN allows for a space or comma separated list to be given in parentheses,
        If any value is matched, the condition is true (it's an OR set)**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region not in ('Beaumont','Boston');
    /**NOT is a negation of the condition**/
run;


Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects mean median std;
  var equipmnt personel jobtotal;
  class pol_type region;
  where jobtotal le 80000 and jobtotal ge 50000;
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects mean median std;
  var equipmnt personel jobtotal;
  class pol_type region;
  where jobtotal between 50000 and 80000;
/**Between A and B is available for simplifying ranges**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects mean median std;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region between 'A' and 'M';
/**Between A and B does work for character, it uses
    alphabetical ordering with case-sensitivity**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects mean median std;
  var equipmnt personel jobtotal;
  class pol_type region;
  where pol_type contains 'O';
    /**contains 'string' looks for that string anywhere in the variable value
      and returns true if it is present at least once**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects mean median std;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region not contains 'B';
    /**contains 'string' looks for that string anywhere in the variable value
      and returns true if it is present at least once**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects mean median std;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region like 'B%';
    /**You can use LIKE with two types of wildcards:
          %--any number of characters, including 0
          _--is exactly one character**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects mean median std;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region like '%B%';
    /****/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects mean median std;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region like '%B_';
    /****/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects mean median std;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region like '%o%o%';
    /****/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region not in ('Beaumont','Boston') 
          and pol_type contains 'O';
    /**compounding can be applied to special conditions**/
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects(where=(region not in ('Beaumont','Boston'))) 
            min q1 median q3 max;
    /**WHERE (as WHERE=) is a data set option**/
  var equipmnt personel jobtotal;
  class pol_type region;
run;

Title 'Five Number Summary';
Title2 'On Equipment, Personnel, and Total Cost';
proc means data=sasdata.projects min q1 median q3 max;
  var equipmnt personel jobtotal;
  class pol_type region;
  where region not in ('Beaumont','Boston') 
          and pol_type contains 'O';
  ods output summary=work.means(where=(nobs ge 60));
run;
