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
