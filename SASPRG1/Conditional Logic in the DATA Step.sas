/**DATA Step supports IF-THEN-ELSE processing/branching...*/

data one;
  set sashelp.heart;
  
  if systolic le 120 then BPCategory = 'Normal';

  /**IF condition THEN action; */
run;

data two;
  set sashelp.heart;
  
  /*First instance of a character variable typically defines
      its length...so, BPCategory is given length 6 */
  if systolic lt 120 then BPCategory = 'Normal';
    else if systolic le 129 then BPCategory = 'Elevated';
      else if systolic le 139 then BPCategory = 'HBP Stage 1';
        else BPCategory = 'HBP Stage 2';

  /**IF condition THEN action; 
      ELSE action; But the action can be to evaluate another IF..*/
run;

data three;
  set sashelp.heart;
  
  length BPCategory $15;
  /**length variable(s) $#; can be used to set lengths of character
      variables*/
  if systolic lt 120 then BPCategory = 'Normal';
    else if systolic le 129 then BPCategory = 'Elevated';
      else if systolic le 139 then BPCategory = 'HBP Stage 1';
        else BPCategory = 'HBP Stage 2';

run;

data threeA;
  *length BPCategory $15;
  set sashelp.heart;
  
  if systolic lt 120 then BPCategory = 'Normal';
    else if systolic le 129 then BPCategory = 'Elevated';
      else if systolic le 139 then BPCategory = 'HBP Stage 1';
        else BPCategory = 'HBP Stage 2';
  length BPCategory $15;/**Too late, length is already set...*/
run;
/**Condition on both systolic and diastolic... */


data four;
  set sashelp.heart;
  
  length BPCategory $15;
/*   if systolic lt 120 and diastolic lt 80 then BPCategory = 'Normal'; */
/*     else if systolic le 129 and diastolic lt 80 then BPCategory = 'Elevated'; */
/*       else if systolic le 139 and diastolic lt 90 then BPCategory = 'HBP Stage 1'; */
/*         else BPCategory = 'HBP Stage 2'; */

  if diastolic lt 80 then do;/**If you want to execute multiple statements you can use a DO-END group*/
    if systolic lt 120 then BPCategory = 'Normal';
      else if systolic le 129 then BPCategory = 'Elevated';
        else if systolic le 139 then BPCategory = 'HBP Stage 1';
          else BPCategory = 'HBP Stage 2';
  end;
  else if diastolic lt 90 and systolic le 139 then BPCategory = 'HBP Stage 1';
  else BPCategory = 'HBP Stage 2';

run;

data five;
  set sashelp.heart;
  
  length BPCategory $15;
  if systolic ge 140 or diastolic ge 90 then BPCategory = 'HBP Stage 2';
    else if systolic ge 130 or diastolic ge 80 then BPCategory = 'HBP Stage 1';
      else if systolic ge 120 then BPCategory = 'Elevated';
        else BPCategory = 'Normal';
run;

data HBPStage2;
  set sashelp.heart;

  where systolic ge 140 or diastolic ge 90;
    /*If I only want HBP Stage 2 records, I can
        subset with WHERE*/
run;

data fail;
  set sashelp.heart;
  
  length BPCategory $15;
  if systolic ge 140 or diastolic ge 90 then BPCategory = 'HBP Stage 2';
    else if systolic ge 130 or diastolic ge 80 then BPCategory = 'HBP Stage 1';
      else if systolic ge 120 then BPCategory = 'Elevated';
        else BPCategory = 'Normal';

  where BPCategory eq 'HBP Stage 2';
    /*WHERE statement can only refer to variables in the input data set(s),
        cannot refer to anything created during processing*/
run;

data success;
  set sashelp.heart;
  
  length BPCategory $15;
  if systolic ge 140 or diastolic ge 90 then BPCategory = 'HBP Stage 2';
    else if systolic ge 130 or diastolic ge 80 then BPCategory = 'HBP Stage 1';
      else if systolic ge 120 then BPCategory = 'Elevated';
        else BPCategory = 'Normal';

  if BPCategory eq 'HBP Stage 2' then output success;
  /**You can specify an OUTPUT statement in a DATA step, this...
      1. Directs output to a data set (or all data sets if no name is given)
      2. Removes all implicit output*/

run;

data success2;
  set sashelp.heart;
  
  length BPCategory $15;
  if systolic ge 140 or diastolic ge 90 then BPCategory = 'HBP Stage 2';
    else if systolic ge 130 or diastolic ge 80 then BPCategory = 'HBP Stage 1';
      else if systolic ge 120 then BPCategory = 'Elevated';
        else BPCategory = 'Normal';

  if BPCategory eq 'HBP Stage 2' then output;
  /**You can specify an OUTPUT statement in a DATA step, this...
      1. Directs output to a data set (or all data sets if no name is given)
      2. Removes all implicit output*/

run;

data success3;
  set sashelp.heart;
  
  length BPCategory $15;
  if systolic ge 140 or diastolic ge 90 then BPCategory = 'HBP Stage 2';
    else if systolic ge 130 or diastolic ge 80 then BPCategory = 'HBP Stage 1';
      else if systolic ge 120 then BPCategory = 'Elevated';
        else BPCategory = 'Normal';

  if BPCategory eq 'HBP Stage 2';
  /**IF with no THEN -> subsetting IF...if the statement is true, continue
    processing the iteration of the DATA step (including the implicit output)
    If false, return to the top (no output) and read another record*/

run;

data Normal Elevated Stage1 Stage2;
    /*I can list multiple data sets in the DATA statement*/
  set sashelp.heart;
  
  length BPCategory $15;
  if systolic ge 140 or diastolic ge 90 then output Stage2;
    else if systolic ge 130 or diastolic ge 80 then output Stage1;
      else if systolic ge 120 then output elevated;
        else output normal;
  /*direct individual records to specified tables*/
run;

