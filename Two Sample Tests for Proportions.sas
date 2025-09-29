libname SASData '~/SASData';

proc sort data=SASData.DrugTrial3 out=Trial3;
  by descending group descending response;
run;

proc freq data=Trial3 order=data;
  table group*response /nocol;
run;

proc freq data=Trial3 order=data;
  table group*response /nocol expected;
  /**Expected gives expected cell counts
    under the independence assumption**/
run;


proc freq data=Trial3 order=data;
  table group*response /nocol expected chisq;
  /**chisq produces several chi-square
  stats and p-values...**/
run;

proc freq data=Trial3 order=data;
  table group*response /nocol expected chisq
                      deviation cellchi2 ;
  /**individual cell contributions can be put
    into the table**/
run;


proc freq data=Trial3 order=data;
  table group*response /nocol chisq riskdiff alpha=.10;
  ods exclude fishersexact;
  /****/
run;