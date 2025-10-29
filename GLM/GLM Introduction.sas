ods graphics off;
proc reg data=sashelp.heart;
  model systolic = weight;
  /*** model response-variable = predictor-variables; 

    systolic:y, weight:x ***/
run;

proc standard data=sashelp.heart out=heartCentered mean=0;
      /**mean=0 says transform to mean zero (subtract the mean)**/
  var weight;
run;

ods graphics off;
proc reg data=heartCentered;
  model systolic = weight;
run;

proc glm data=sashelp.heart;
  model systolic = weight;
  /*** model response-variable = predictor-variables; 

    systolic:y, weight:x ***/
run;


proc glm data=heartCentered;
  model systolic = weight;
run;

/**Concept Questions 3.1**/

proc glm data=sashelp.heart;
  model weight = systolic;
run;


ods graphics off;
proc reg data=sashelp.heart;
  model systolic = weight height;
  /*** model response-variable = predictor-variables; 

    systolic:y, weight:x1, height:x2 ***/
run;

ods graphics off;
proc glm data=sashelp.heart;
  model systolic = weight height;
  /*** model response-variable = predictor-variables; 

    systolic:y, weight:x1, height:x2 ***/
run;

proc standard data=sashelp.heart out=heartCentered mean=0;
      /**mean=0 says transform to mean zero (subtract the mean)**/
  var weight height;
run;

ods graphics off;
proc reg data=heartCentered;
  model systolic = weight height;
  ods exclude anova;
run;


proc glm data=sashelp.heart;
  model systolic = weight height weight*height;
    /**products of predictors are allowed in PROC GLM using *
        **/
  ods select parameterEstimates;
run;

/**PROC REG does not support any modifications
      to predictors in the column statement**/
data heart;
  set sashelp.heart;
  weightXheight = weight*height;
  /**make a version of the data with the product 
      in there...**/
run;
ods graphics off;
proc reg data=heart;
  model systolic = weight height weightXheight;/**...use it**/
  ods select parameterEstimates;
run;

proc glm data=heartCentered;
  model systolic = weight height weight*height;
    /**products of predictors are allowed in PROC GLM using *
        **/
  ods exclude anova modelAnova;
run;

data heart;
  set sashelp.heart;
  where weight_status ne '';/**don't want these (there aren't any)**/
 
  underweight=0; normal=0; overweight=0;/**start with all zero**/
  select(weight_status);
    when('Underweight') underweight=1;
    when('Normal') normal=1;
    when('Overweight') overweight=1;
  end;/**flip on the right one**/
  sum=sum(of underweight--overweight);
run;
proc reg data=heart;
  'Means':model systolic = underweight normal overweight / noint;
      /**NOINT removes the intercept from the equation before estimating--
        no column of 1 in the X matrix**/
  'Effects':model systolic = underweight normal overweight;
      restrict underweight+normal+overweight=0;
      /**intercept is included with a restriction--restriction is written
          in terms of the variables but applies to their associated parameters**/
  'Reference': model systolic = underweight normal;
      /**removed overweight, it becomes the reference category**/
  ods select ParameterEstimates;
run;

proc means data=sashelp.heart;
  class weight_status;
  var systolic;
  ways 0 1;
run;

proc glm data=sashelp.heart;
  class weight_status; /**class -> treat these as nominal**/
  model systolic = weight_status / solution;
    /**solution shows the estimated model even when
      only categorical stuff is used**/
  *ods select ParameterEstimates;
run;

proc glm data=sashelp.heart;
  class weight_status; /**class -> treat these as nominal**/
  model systolic = weight_status / solution noint;
    /**solution shows the estimated model even when
      only categorical stuff is used**/
  ods select ParameterEstimates;
run;

/**Concept Question 5.2, CX2**/
proc glm data=sashelp.heart;
  class weight_status(ref='Overweight'); 
  *class weight_status / ref=first;
  model systolic = weight_status / solution;
  ods select ParameterEstimates;
run; 

proc glm data=sashelp.heart;
  class chol_status;
  model systolic = chol_status weight / noint solution;
  ods select ParameterEstimates;
run;

proc standard data=sashelp.heart out=heartCentered mean=0;
  var weight height;
run;
proc glm data=heartCentered;
  class chol_status;
  model systolic = chol_status weight / noint solution;
  ods select ParameterEstimates;
run;
/* proc means data=sashelp.heart; */
/*   class chol_status; */
/*   var systolic; */
/* run; */


/* proc glm data=sashelp.heart; */
/*   class chol_status; */
/*   model systolic = chol_status weight / solution; */
/*   ods select ParameterEstimates; */
/* run; */
proc glm data=heartCentered;
  class chol_status;
  model systolic = chol_status weight / solution;
  ods select ParameterEstimates;
run;


proc glm data=sashelp.heart;
  class chol_status;
  model systolic = chol_status|weight / solution;
    /**A|B is A B A*B
       A|B|C that's A B A*B C A*C B*C A*B*C  can extend
       A|B|C @2 to get A B A*B C A*C B*C **/
  ods select ParameterEstimates;
run;

proc glm data=sashelp.heart;
  class chol_status;
  model systolic = chol_status chol_status*weight / solution noint;
  ods select ParameterEstimates;
run;

/**Exercises**/
libname SASData '~/SASData';

/*1A*/
proc glm data=SASData.cdi;
  model inc_per_cap = ba_bs;
  ods select ParameterEstimates;
run;
/*  */
/* data cdiMod; */
/*   set SASData.cdi; */
/*   ba_bs = ba_bs-10; */
/*   pop18_34 = pop18_34 - 20; */
/* run; */
/* proc glm data=cdiMod; */
/*   model inc_per_cap = ba_bs; */
/*   ods select ParameterEstimates; */
/* run; */

/*1B*/
proc glm data=SASData.cdi;
  model inc_per_cap = pop18_34;
  ods select ParameterEstimates;
run;
/*1C*/
proc glm data=SASData.cdi;
  model inc_per_cap = ba_bs pop18_34;
  ods select ParameterEstimates;
run;

/*1D*/
proc glm data=SASData.cdi;
  model inc_per_cap = ba_bs|pop18_34;
  ods select ParameterEstimates;
run;

proc stdize data=sasdata.cdi out=cdiStd method=mean;  
  /**proc stdize does various standardizations--
    it uses methods...mean moves mean value to 0 (centers)**/
  var ba_bs pop18_34;
run;
proc glm data=cdiStd;
  model inc_per_cap = ba_bs|pop18_34;
  ods select ParameterEstimates;
run;


%macro myGLM(data=,response=,predictors=);
proc glm data=&data;
  model &response = &predictors;
  ods select ParameterEstimates;
run;
%mend;

options mprint;
%myGLM(data=SASData.cdi,response=inc_per_cap,predictors=ba_bs);
%myGLM(data=SASData.cdi,response=inc_per_cap,predictors=pop18_34);
%myGLM(data=SASData.cdi,response=inc_per_cap,predictors=ba_bs pop18_34);
%myGLM(data=SASData.cdi,response=inc_per_cap,predictors=ba_bs|pop18_34);


/*3A*/
proc glm data=SASData.realEstate;
  model price  = sq_ft;
  ods select ParameterEstimates;
run;
/*3B*/
proc glm data=SASData.realEstate;
  model price = bedrooms;
  ods select ParameterEstimates;
run;
/*3C*/
proc glm data=SASData.realEstate;
  model price = sq_ft bedrooms;
  ods select ParameterEstimates;
run;
/*3D*/
proc glm data=SASData.realEstate;
  model price = sq_ft|bedrooms;
  ods select ParameterEstimates;
run;

data realEstate;
  set sasdata.realEstate;
  sqFt = sq_ft-1500;
  beds = bedrooms-3;
run;

proc glm data=realEstate;
  model price = sqft|beds;
  ods select ParameterEstimates;
run;

proc sgplot data=sasdata.realestate;
  where price le 600000;
  scatter x=sq_ft y=bedrooms / markerattrs=(symbol=squarefilled)
                              colorresponse=price
                              colormodel=(CXca0020 CXf4a582 CXf7f7f7
                                          CX92c5de CX0571b0);
run;

/*2A*/
proc format;
  value region
   1='Northeast'
   2='North-Central'
   3='South'
   4='West'
  ;
run;

proc glm data=SASData.cdi;
  class region(ref='South');
  model inc_per_cap = region / solution;
  lsmeans region;
  ods select ParameterEstimates lsmeans;
  format region region.;
run;

/*2B*/
proc glm data=SASData.cdi;
  class region;
  model inc_per_cap = ba_bs|region / solution;
  ods select ParameterEstimates;
  format region region.;
run;

proc glm data=cdiSTD;
  class region;
  model inc_per_cap = ba_bs|region / solution;
  ods select ParameterEstimates;
  format region region.;
run;

proc glm data=SASData.cdi;
  class region;
  model inc_per_cap = ba_bs|region ;
  lsmeans region;
  /**this plugs in the mean for any quantitative predictors
      when estimating means for categories**/
  ods select ParameterEstimates lsmeans;
  format region region.;
run;

ods graphics off;
proc glm data=SASData.cdi;
  class region;
  model inc_per_cap = ba_bs|region / solution;
  lsmeans region / diff cl;
  lsmeans region / at ba_bs = 10;
  estimate 'NC vs S' ba_bs*region 1 0 -1 0;
  /**North-Central - South on the BA X Region effect
      difference in those slopes**/
  ods select ParameterEstimates lsmeans estimates;
  format region region.;
run;

/*4a*/
proc format;
  value qual
    1='1-High'
    2='2-Medium'
    3='3-Low'
    ;
run;
proc glm data=sasdata.realestate;
  class quality;
  model price = quality / solution;
  ods select parameterEstimates;
  format quality qual.;
run;
proc glm data=sasdata.realestate;
  *class quality;
  model price = quality / solution;
  ods select parameterEstimates;
  *format quality qual.;
run;

/*4b*/
data RealEstate;
  set sasdata.realestate;
  
  sqFt=sq_ft-2000;
run;


proc glm data=realestate;
  class quality;
  model price = quality|sqFt / solution;
  ods select parameterEstimates;
  format quality qual.;
run;


/**Take the model from 2b and add in population 18 to 34 and 
    all possible cross products between predictors--interpret**/
proc stdize data=sasdata.cdi out=cdiStd method=mean;  
  var ba_bs pop18_34;
run;
proc format;
  value region
   1='Northeast'
   2='North-Central'
   3='South'
   4='West'
  ;
run;
proc glm data=cdiSTD;
  class region;
  model inc_per_cap = ba_bs|region|pop18_34 / solution;
  ods select ModelAnova ParameterEstimates;
  format region region.;
run;

/**Practice 1A**/
data cdi;
  set sasdata.cdi;

  crimeRate = crimes/pop*100000;
  popDensity = pop/land;
run;

proc stdize data=cdi out=StdCDI method=mean;
  var popDensity poverty ba_bs;
run;

proc glm data=stdcdi;
  model crimeRate = popDensity poverty ba_bs;
  ods select parameterEstimates;
run;

proc stdize data=cdi out=StdCDI method=mean
    sprefix=C oprefix=O;
  var popDensity poverty ba_bs;
run;

/*1B*/
proc glm data=stdcdi;
  model crimeRate = CpopDensity|Cpoverty|Cba_bs;
  ods select parameterEstimates;
  ods output parameterEstimates=Parms;
run;

/*2A*/
/**1A Model...**/
proc glm data=stdcdi;
  model crimeRate = CpopDensity Cpoverty Cba_bs;
  ods select parameterEstimates;
run;
/*2A*/
proc format;
  value region
   1='Northeast'
   2='North-Central'
   3='South'
   4='West'
  ;
run;
proc glm data=stdcdi;
  class region;
  format region region.;
  model crimeRate = Region CpopDensity Cpoverty Cba_bs 
        / solution noint;
  ods select parameterEstimates;
run;

proc glm data=stdcdi;
  class region;
  format region region.;
  model crimeRate = Region|CpopDensity 
                    Region|Cpoverty 
                    Region|Cba_bs 
        / solution;
  ods select parameterEstimates;
run;

ods trace on;
proc glm data=stdcdi;
  class region;
  format region region.;
  model crimeRate = Region|CpopDensity 
                    Region|Cpoverty 
                    Region|Cba_bs 
        / solution;
  ods select parameterEstimates 'Type III Model ANOVA';
run;

proc glm data=stdcdi;
  class region(ref='South');
  format region region.;
  model crimeRate = Region|CpopDensity 
                    Region|Cpoverty 
                    Region|Cba_bs 
        / solution;
  ods select parameterEstimates 'Type III Model ANOVA';
run;

/**2C**/
proc glm data=stdcdi;
  class region;
  format region region.;
  model crimeRate = Region|CpopDensity|Cpoverty|Cba_bs @2
        / solution;
  /** @k limits to up to interactions/products of any
        k variables**/
  ods select parameterEstimates 'Type III Model ANOVA';
run;
