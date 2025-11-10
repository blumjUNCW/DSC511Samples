libname IPEDS '~/IPEDS';
options fmtsearch=(IPEDS);
proc sql; /**PROC SQL invokes an environment for writing queries..**/
  select instnm, fips, c21enprf, control, locale 
    from IPEDS.Characteristics(obs=10) 
  ;
quit;

proc sql inobs=20 outobs=10 feedback; 
  select *
    from IPEDS.graduation 
  ;
quit;

proc sql inobs=10 feedback;
  select unitid, total, men, women
    from IPEDS.Graduation
    where total gt 5000 and group contains 'Incoming' 
  ;
quit;

proc sql;
  select instnm, fips, control, locale
    from IPEDS.Characteristics
    where instnm contains 'Utah'
    order by locale, control desc
  ;
quit;

proc sql;
  select count(total), mean(total), min(total), max(total)
    from IPEDS.Graduation
    where group contains 'Incoming'
  ;
quit;

proc sql;
  select group, count(total) as N, mean(total) as Mean,
                min(total) as Minimum, max(total) as maximum
    from IPEDS.Graduation
    where men ge 10 and women ge 10
    group by group 
    order by group desc 
  ;
quit;

proc sql;
  select group, count(total) as Count,
                sum(total gt 100) label='More than 100 students' as MoreThan100,
                mean(total gt 100) as PropMore100 format=percentn7.1 label='Proportion'
    from IPEDS.Graduation
    group by group
  ;
quit;


proc sql;
  select group, mean(total) as Mean
    from IPEDS.Graduation
    where men ge 10 and women ge 10
    group by group
  ;   
  select unitid, group, total
    from IPEDS.Graduation
    where men ge 10 and women ge 10
  ;
  select unitid, group, mean(total) as Mean, total
    from IPEDS.Graduation
    where men ge 10 and women ge 10
    group by group
    order by unitid, group desc
  ;
quit;

proc sql;
  select rank, mean(sa09mot/sa09mct) as AvgSalary format=dollar12.2,
               mean(sa09mom/sa09mcm) as AvgSalaryM format=dollar12.2,
               mean(sa09mow/sa09mcw) as AvgSalaryW format=dollar12.2
    from IPEDS.Salaries
    where sa09mct ge 10
    group by rank
    having AvgSalaryM-AvgSalaryW ge 2750
    /**conditioning on group summaries must be done in having, which follows group by**/
    order by rank desc
  ;
quit;


proc sql;
  select rank, mean(sa09mot/sa09mct) as AvgSalary format=dollar12.2,
                mean(sa09mom/sa09mcm) as AvgSalaryM format=dollar12.2,
                mean(sa09mow/sa09mcw) as AvgSalaryW format=dollar12.2
    from IPEDS.Salaries
    where sa09mct ge 10
            and lowcase(put(rank,arank.)) contains 'professor'
    group by rank
    having AvgSalaryM-AvgSalaryW ge 2750
  ;
  select rank, mean(sa09mot/sa09mct) as AvgSalary format=dollar12.2,
                mean(sa09mom/sa09mcm) as AvgSalaryM format=dollar12.2,
                mean(sa09mow/sa09mcw) as AvgSalaryW format=dollar12.2
    from IPEDS.Salaries
    where sa09mct ge 10
    group by rank
    having AvgSalaryM-AvgSalaryW ge 2750
             and lowcase(put(rank,arank.)) contains 'professor'
  ;
  select rank, mean(sa09mot/sa09mct) as AvgSalary format=dollar12.2,
                mean(sa09mom/sa09mcm) as AvgSalaryM format=dollar12.2,
                mean(sa09mow/sa09mcw) as AvgSalaryW format=dollar12.2
    from IPEDS.Salaries
    group by rank
    having AvgSalaryM-AvgSalaryW ge 2750
             and lowcase(put(rank,arank.)) contains 'professor'
             and sa09mct ge 10 /**be careful what you put into HAVING...
                        only put stuff that needs to be there**/
  ;
quit;


proc sql outobs=5;
  select *, men/total as PropMen format=percent8.1,
            women/total as PropWomen format=percent8.1
    from IPEDS.Graduation
  ;
  select group, men/total as PropMen, women/total as PropWomen 
    from IPEDS.Graduation
  ;
quit;

proc sql outobs=5 noerrorstop;
  select unitid, group, men/total as PropMen, 1 - PropMen as PropWomen
    from IPEDS.Graduation
  ;
  select unitid, group, men/total as PropMen, 
                1 - calculated PropMen as PropWomen
    from IPEDS.Graduation
  ;
  select unitid, group, men/total as PropMen, 
                1 - calculated PropMen as PropWomen
    from IPEDS.Graduation
    where PropWomen lt 0.55 
  ;
  select unitid, group, men/total as PropMen, 
                1 - calculated PropMen as PropWomen
    from IPEDS.Graduation
    where calculated PropWomen lt 0.55 
  ;
quit;


proc sql outobs=5;
  select unitid,
          case
            when board eq 1 then 'Yes, with set maximum meals per week' 
            when board eq 2 then 'Yes, with variable meals per week'
            else 'No meal plan'
          end
          as MealPlan,
         roomamt, boardamt
  from IPEDS.TuitionAndCosts
  ;
  select unitid,
          case board
            when 1 then 'Yes, with set maximum meals per week'
            when 2 then 'Yes, with variable meals per week'
            else 'No meal plan'
          end
          as MealPlan,
        roomamt, boardamt
  from IPEDS.TuitionAndCosts
  ;
quit;


proc sql;
  select
        case
          when board eq 1 then 'Yes, with set maximum meals per week' 
          when board eq 2 then 'Yes, with variable meals per week'
          else 'No meal plan'
        end
        as MealPlan,
        avg(roomamt) as avgRoom, avg(boardamt) as avgBoard
  from IPEDS.TuitionAndCosts
  where calculated MealPlan contains 'Yes'
  group by MealPlan
  ;
  select
        case
          when board eq 1 then 'Yes, with set maximum meals per week' 
          when board eq 2 then 'Yes, with variable meals per week'
          else 'No meal plan'
        end
        as MealPlan,
        avg(roomamt) as avgRoom, avg(boardamt) as avgBoard
  from IPEDS.TuitionAndCosts
  group by MealPlan
  having MealPlan contains 'Yes'
  ;
  select
        case
          when board eq 1 then 'Yes, with set maximum meals per week' 
          when board eq 2 then 'Yes, with variable meals per week'
          else 'No meal plan'
        end
        as MealPlan,
        avg(roomamt) as avgRoom, avg(boardamt) as avgBoard
  from IPEDS.TuitionAndCosts
  group by MealPlan
  having calculated MealPlan contains 'Yes'
  ;
quit;

proc sql;
  create table Work.Salaries as 
    select rank,
          mean(sa09mot/sa09mct) as AvgSalary format=dollar12.2 label='9 Month Avg.',
          mean(sa09mom/sa09mcm) as AvgSalaryM format=dollar12.2 label='Men 9 Month Avg.',
          mean(sa09mow/sa09mcw) as AvgSalaryW format=dollar12.2 label='Women 9 Month Avg.'
    from IPEDS.Salaries
    where sa09mct ge 10
    group by rank 
    having AvgSalaryM-AvgSalaryW ge 2750
  ;
 * create table Work.SalariesUgly as 
    select rank,
          mean(sa09mot/sa09mct)   format=dollar12.2 label='9 Month Avg.',
          mean(sa09mom/sa09mcm)   format=dollar12.2 label='Men 9 Month Avg.',
          mean(sa09mow/sa09mcw)   format=dollar12.2 label='Women 9 Month Avg.'
    from IPEDS.Salaries
    where sa09mct ge 10
    group by rank 
/*     having AvgSalaryM-AvgSalaryW ge 2750 */
  ;/**AS clause with names is very helpful when making tables...**/
quit;


proc sql;
  create view Work.SalariesView as 
    select rank,
          mean(sa09mot/sa09mct) as AvgSalary format=dollar12.2 label='9 Month Avg.',
          mean(sa09mom/sa09mcm) as AvgSalaryM format=dollar12.2 label='Men 9 Month Avg.',
          mean(sa09mow/sa09mcw) as AvgSalaryW format=dollar12.2 label='Women 9 Month Avg.'
    from IPEDS.Salaries
    where sa09mct ge 10
    group by rank 
    having AvgSalaryM-AvgSalaryW ge 2750
  ;
quit;

proc print data=salaries;
run;

proc print data=salariesview;
run;

proc sql;
  create table ex1 as
   select Stock, Date, High, Low,
          high-low as difference format=dollar8.2,
          calculated difference/low as pctDiff format=percent8.2
   from sashelp.stocks
   where year(date) eq 2005
   order by stock, date
  ;
  create table ex2 as
   select Stock, Date, High, Low,
          high-low as difference format=dollar8.2,
          calculated difference/low as pctDiff format=percent8.2
   from sashelp.stocks
   where year(date) eq 2005 
          and (calculated difference ge 5 or calculated pctDiff ge .10)
   order by stock, date
  ;
quit;

proc sql;
  create table ex2B as
   select Stock, Date, High, Low,
          high-low as difference format=dollar8.2,
          calculated difference/low as pctDiff format=percent8.2
   from sashelp.stocks(where=(year(date) eq 2005))
   where calculated difference ge 5 or calculated pctDiff ge .10
   order by stock, date
  ;
quit;

proc sql;
  create table ex3 as 
    select stock, 
           mean(high) as highMean format=dollar12.2, 
           mean(low) as lowMean format=dollar12.2
    from sashelp.stocks
    group by stock
  ;
  create table ex4 as 
    select stock, 
           mean(high) as highMean format=dollar12.2, 
           mean(low) as lowMean format=dollar12.2,
           calculated highMean - calculated lowMean 
                      as meanDiff format=dollar12.2
    from sashelp.stocks
    group by stock
  ;
quit;

proc sql;
  *create table ex5preliminary as 
    select stock, year(date) as Year,
           mean(high) as highMean format=dollar12.2, 
           mean(low) as lowMean format=dollar12.2,
           calculated highMean - calculated lowMean 
                      as meanDiff format=dollar12.2
    from sashelp.stocks
    where year(date) between 2000 and 2005
    group by stock, Year
  ;
  create table ex5 as 
    select stock, year(date) as Year,
           mean(high) as highMean format=dollar12.2, 
           mean(low) as lowMean format=dollar12.2,
           calculated highMean - calculated lowMean 
                      as meanDiff format=dollar12.2
    from sashelp.stocks
    where year(date) between 2000 and 2005
    group by stock, Year
    having meanDiff gt 10
  ;
  create table ex5B as 
    select stock, year(date) as Year,
           mean(high) as highMean format=dollar12.2, 
           mean(low) as lowMean format=dollar12.2,
           calculated highMean - calculated lowMean 
                      as meanDiff format=dollar12.2
    from sashelp.stocks
    where calculated year between 2000 and 2005
    group by stock, Year
    having meanDiff gt 10
  ;
  *create table ex5v2 as 
    select stock, year(date) as Year,
           mean(high) as highMean format=dollar12.2, 
           mean(low) as lowMean format=dollar12.2,
           calculated highMean - calculated lowMean 
                      as meanDiff format=dollar12.2
    from sashelp.stocks
    where year(date) between 2000 and 2005
          and calculated meanDiff gt 10
          /**can't be here because meanDiff is 
              derived from summary functions (mean)**/
    group by stock, Year
  ;
  *create table ex5v3 as 
    select stock, year(date) as Year,
           mean(high) as highMean format=dollar12.2, 
           mean(low) as lowMean format=dollar12.2,
           calculated highMean - calculated lowMean 
                      as meanDiff format=dollar12.2
    from sashelp.stocks
    group by stock, Year
    having meanDiff gt 10
            and year(date) between 2000 and 2005
            /**goes back to the table and pulls every record
              that satisfies this and remerges onto
                the summary**/
  ;
  create table ex5v4 as 
    select stock, year(date) as Year,
           mean(high) as highMean format=dollar12.2, 
           mean(low) as lowMean format=dollar12.2,
           calculated highMean - calculated lowMean 
                      as meanDiff format=dollar12.2
    from sashelp.stocks
    group by stock, Year
    having meanDiff gt 10
            and year between 2000 and 2005
            /**this uses the variable constructed and put
                into the grouping, so it subsets that**/
  ;
quit;