libname IPEDS '~/IPEDS';
options fmtsearch=(IPEDS);
libname SASData '~/SASData';

proc sql;
  create table MA2Year as 
    select unitID
    from ipeds.Characteristics
    where put(c21enprf,c21enprf.) contains 'two-year'
            and fipstate(fips) eq 'MA'
    order by unitID
  ;
  create table OOS10X as 
    select unitID
    from ipeds.TuitionAndCosts
    where tuition2 ne . and tuition3 ge 10*tuition2
    order by unitID
  ;
quit;

proc sql;
  select MA2Year.UnitID
  from MA2Year inner join OOS10X on MA2Year.UnitID eq OOS10X.UnitID
  ;
quit;


proc sql;
    select unitID
      from ipeds.Characteristics
      where put(c21enprf,c21enprf.) contains 'two-year'
              and fipstate(fips) eq 'MA'
    intersect
    select unitID
      from ipeds.TuitionAndCosts
      where tuition2 ne . and tuition3 ge 10*tuition2
  ;
quit;

proc sql;
  create table Except as
    select unitID
      from ipeds.Characteristics
      where put(c21enprf,c21enprf.) contains 'two-year'
              and fipstate(fips) eq 'MA'
    except
    select unitID
      from ipeds.TuitionAndCosts
      where tuition2 ne . and tuition3 ge 10*tuition2
  ;
  create table Except2 as
    select unitID
      from ipeds.TuitionAndCosts
      where tuition2 ne . and tuition3 ge 10*tuition2
    except
    select unitID
      from ipeds.Characteristics
      where put(c21enprf,c21enprf.) contains 'two-year'
              and fipstate(fips) eq 'MA'
  ;
quit;


proc sql;
  create table Union as
    select unitID
      from ipeds.Characteristics
      where put(c21enprf,c21enprf.) contains 'two-year'
              and fipstate(fips) eq 'MA'
    union /**union is everything, but duplicates are removed**/
    select unitID
      from ipeds.TuitionAndCosts
      where tuition2 ne . and tuition3 ge 10*tuition2
    order by UnitId
  ;
quit;

proc sql;
  create table UnionAll as
    select unitID
      from ipeds.Characteristics
      where put(c21enprf,c21enprf.) contains 'two-year'
              and fipstate(fips) eq 'MA'
    union all/**union is everything--including all duplication**/
    select unitID
      from ipeds.TuitionAndCosts
      where tuition2 ne . and tuition3 ge 10*tuition2
    order by UnitId
  ;
quit;

proc sql;
  create table NP1415 as
    select *
      from sasdata.np_2014
    union
    select *
      from sasdata.np_2015
  ;
  create table NP1516 as
    select *
      from sasdata.np_2015
    union
    select *
      from sasdata.np_2016
  ;
  /**these both work the same, even without the renaming
      we did with DATA step concatenation...
    Alignmen with set operators is positional--first columns
      are aligned, second, ...**/
quit;

proc sql;
  create table NP1516B as
    select ParkCode, ParkType, Region, Year, Month, DayVisits
      from sasdata.np_2015
    union
    select Region, ParkCode, ParkType, DayVisits, Year, Month
      from sasdata.np_2016
  ;/**Even if names match, positions are used...**/

  create table NP1516C as
    select ParkCode, ParkType, Region, Year, Month, DayVisits
      from sasdata.np_2015
    union corresponding /**UNION CORRESPONDING aligns on column names**/
    select Region, ParkCode, ParkType, DayVisits, Year, Month
      from sasdata.np_2016
  ;
  create table NP1516D as
    select ParkCode, ParkType, Year, Month, DayVisits
      from sasdata.np_2015
    union corresponding /**UNION CORRESPONDING aligns on column names--only keeps things in both tables**/
    select Region, ParkCode, ParkType, DayVisits, Year, Month
      from sasdata.np_2016
  ;
quit;

proc sql;
  create table NP141516 as
    select *
      from sasdata.np_2014
    union
    select *
      from sasdata.np_2015
    union
    select *
      from sasdata.np_2016
  ;
quit;

/**Concept 1**/
proc sql;
  create table NP1516X as
    select ParkCode, ParkType, Year, Region, Month, DayVisits
      from sasdata.np_2015
    union
    select Region, ParkCode, ParkType, DayVisits, Year, Month
      from sasdata.np_2016
  ;
quit;
/**Concept 2**/
proc sql;
  create table NP141516Corr as
    select *
      from sasdata.np_2014
    union corresponding
    select *
      from sasdata.np_2015
    union corresponding
    select *
      from sasdata.np_2016
  ;
quit;

/**Concept 3**/
proc sql;
  create table NP1415 as
    select *
      from sasdata.np_2014
    outer union
    select *
      from sasdata.np_2015
  ;
  create table NP1516 as
    select *
      from sasdata.np_2015
    outer union
    select *
      from sasdata.np_2016
  ;
quit;

proc sql;
  create table NP1415 as
    select Park, Type, DayVisits
      from sasdata.np_2014
    outer union
    select ParkCode, ParkType, DayVisits as Visits
      from sasdata.np_2015
  ;
  create table NP1415B as
    select *
      from sasdata.np_2014
    outer union corresponding
    select *
      from sasdata.np_2015
  ;
quit;


proc sql;
  select c21enprf, mean(tuition2) format=dollar12.2
   from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
     on tc.unitID eq ch.unitID
    where c21enprf gt 0
    group by c21enprf
  union
  select control, mean(tuition2) format=dollar12.2
    from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
      on tc.unitID eq ch.unitID
    where control gt 0
    group by control
  ;/**aligning the stratification variables and the averages seems reasonable 
      for a union, but the result is strange

      each of control and c21enprf are numeric variables that are formatted--
        the column constructed by the union inherits the first format 
        encountered**/
  select control, mean(tuition2) format=dollar12.2
    from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
      on tc.unitID eq ch.unitID
    where control gt 0
    group by control
  union
  select c21enprf, mean(tuition2) format=dollar12.2
   from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
     on tc.unitID eq ch.unitID
    where c21enprf gt 0
    group by c21enprf
 ;
quit;

proc sql;
  select c21enprf as type, mean(tuition2) as AvgInState format=dollar12.2
   from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
     on tc.unitID eq ch.unitID
    where c21enprf gt 0
    group by c21enprf
  union corresponding
  select control as type, mean(tuition2) as AvgInState format=dollar12.2
    from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
      on tc.unitID eq ch.unitID
    where control gt 0
    group by control
  ;
quit;

proc sql;
  select put(c21enprf,c21enprf.) as Type,
          mean(tuition2) format=dollar12.2
    from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
          on tc.unitID eq ch.unitID
    where c21enprf gt 0
    group by Type
  union
  select put(control,control.) as Type,
          mean(tuition2) format=dollar12.2
    from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
          on tc.unitID eq ch.unitID
    where control gt 0
    group by Type
  ;
  select catx('-','Carnegie',put(c21enprf,1.),put(c21enprf,c21enprf.)) as Type,
          mean(tuition2) format=dollar12.2
    from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
          on tc.unitID eq ch.unitID
    where c21enprf gt 0
    group by Type
  union
  select catx('-','Control',put(control,1.),put(control,control.)) as Type,
          mean(tuition2) format=dollar12.2
    from ipeds.tuitionAndCosts as tc inner join ipeds.characteristics as ch
          on tc.unitID eq ch.unitID
    where control gt 0
    group by Type
  ;
quit;