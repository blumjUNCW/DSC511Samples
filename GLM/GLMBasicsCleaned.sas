*Comment or title;
ods graphics off;/*1*/
proc reg data=sashelp.heart;
  model/*2*/ systolic= weight;/*3*/
run;
 
* Call Out List
1~The default output for the REG procedure includes several graphs,
which we will not consider at this point.
2~The MODEL statement is required. For a bivariate model, the response variable
is listed on the left of the equal sign, the predictor on the right.
3~Here, systolic blood pressure is modeled as a linear function of weight.
;
 
*Comment or title;
proc glm/*1*/ data=sashelp.heart;
  model/*2*/ systolic= weight;/*3*/
run;
 
* Call Out List
1~The only changes in the code are 1) replacing REG with GLM and 2)
removal of the ODS GRAPHICS statement--GLM also generates graphics by default,
except in cases where the number of observations exceeds 5000, which is true
for the Heart data. So its inclusion/exclusion for this example is irrelevant.
2~The MODEL statement is also required in GLM. Again, for a bivariate model,
the response variable is listed on the left of the equal sign, the predictor on the right.
3~So here again, systolic blood pressure is modeled as a linear function of weight.
;
 
*Comment or title;
ods graphics off;/*1*/
proc reg data=sashelp.heart;
  model systolic/*2*/ = weight height;/*3*/
  ods exclude ANOVA;/*4*/
run;
 
* Call Out List
1~Again, the default output for the REG procedure includes several graphs, which are omitted.
2~The MODEL statement still has a single, quantitative response variable listed on the left
of the equal sign.
3~Multiple predictors, separated by spaces, can be include on the right side of the equal sign.
They must be numeric variables, and are treated as quantitative.
4~Here, the ODS EXCLUDE statement removes the tables we do not want (ODS SELECT can also be used
to choose tables to show). ODS table names can be found in the SAS documentation or by using
ODS TRACE to send information to the log.
;
 
*Comment or title;
proc glm data=sashelp.heart;
  model systolic = weight height;
  ods exclude overallANOVA modelANOVA;
run;
 
* Call Out List
1~
;
 
*Comment or title;
proc glm data=sashelp.heart;
  model systolic = weight height weight*height;
  ods exclude overallANOVA modelANOVA;
run;
 
* Call Out List
1~
;
 
*Comment or title;
data heart;/*1*/
  set sashelp.heart;/*2*/
  weightXheight = weight*height;/*3*/
run;
 
ods graphics off;
proc reg data=heart/*4*/;
  model systolic = weight height weightXheight/*5*/;
  ods exclude ANOVA;
run;
 
* Call Out List
1~A new data set, also named HEART, is constructed in the WORK library.
2~The SET statement directs SAS to use SASHelp.Heart.
3~The cross-product is the product of weight and height and is added to
the data set as a new column.
4~PROC REG uses the updated data set.
5~Three variables representing the two predictors and their product are included
in the model statement.
;
 
*Comment or title;
data heart;
  set sashelp.heart;
  where weight_status ne '';/*1*/
  underweight=0; normal=0; overweight=0;/*2*/
  select(weight_status);
    when('Underweight') underweight=1;
    when('Normal') normal=1;
    when('Overweight') overweight=1;
  end;/*3*/
run;
 
proc reg data=heart;
 /*4*/'Means':model systolic = underweight normal overweight / noint;/*5*/
  'Effects':model systolic = underweight normal overweight;
            restrict underweight+normal+overweight=0;/*6*/
  'Reference': model systolic = underweight normal;/*7*/
  ods select ParameterEstimates;
run;
 
* Call Out List
1~This condition is not necessary for this data set, but it is good practice to ensure that
missing values are excluded. As an alternative, all of the dummy variables can be set to
missing when Weight\_Status is missing.
2~Three dummy variables are initialized to zero.
3~Exactly one of the dummy variables is set to one for each observation corresponding to its
group membership.
4~Multiple MODEL statements can be given in PROC REG, and each can be labeled. The syntax for
labeling is 'label-text':MODEL.
5~The NOINT option removes the intercept from the model, making this model match Equation
\ref{MeansModelGLM}.
6~The RESTRICT statement allows for linear restrictions on the parameters (and applies to the
model statement that precedes it). The restriction(s) are written in terms of the variables,
but correspond to a restriction on their parameters. This RESTRICT statement matches Equation
\ref{EffectsRestriction}
7~In this model, one dummy variable is left out, so this constructs the reference parameterization
with Overweight as the reference category.
;
 
*Comment or title;
proc glm data=sashelp.heart;
  class weight_status;/*1*/
  model systolic = weight_status / solution/*2*/;
  ods select ParameterEstimates;
run;
 
* Call Out List
1~The CLASS statement treats each variable listed here as categorical. The levels of the categories
are determined by each unique value (non-missing) of the variable, with these being determined by
the format in use.
2~For a single categorical variable, GLM does not show the table of parameter estimates--it assumes
you are only interested in comparisons (which we cover later). The SOLUTION option generates the
table of estimates.
;
 
*Comment or title;
proc glm data=sashelp.heart;
  class chol_status;/*1*/
  model systolic = chol_status weight / noint/*2*/ solution;
  ods select ParameterEstimates;
run;
 
* Call Out List
1~Since CLASS statement treats each predictor variable as categorical,
only Chol\_Status should be placed here. As the levels of the categories
are determined by each unique value (non-missing) of the variable.
Putting weight in the CLASS statement gives a disastrous result (you can try it).
2~Although it would not normally be used, the NOINT option makes the parameter
set a bit more intuitive in this case.
;
 
*Comment or title;
proc glm data=sashelp.heart;
  class chol_status;
  model systolic = chol_status|weight /*1*/ / solution/*2*/;
  ods select ParameterEstimates;
run;
 
* Call Out List
1~The vertical bar is a useful shortcut when specifying cross-products.
A specification of A|B includes A, B, and A*B. This is extendable--
for example, A|B|C includes A, B, A*B, C, A*C, B*C, and A*B*C.
2~The solution produced here attempts to model eight parameters, an intercept,
three parameters for Chol\_Status, a slope against weight, and three more
parameters for each level of the crossing of Chol\_Status and Weight.
Only six are required, so two are set to zero.
;
 
*Comment or title;
proc glm data=sashelp.heart;
  class chol_status;
  model systolic = chol_status chol_status*weight/*1*/ / noint/*2*/ solution;
  ods select ParameterEstimates;
run;
 
* Call Out List
1~Weight only appears in the cross-product, so no individual slope on weight is modeled.
2~The NOINT option results in an intercept estimate being produced for each level of
Chol\_Status.
;
 
