proc import datafile='~/SASData/cars.datfile'
      dbms=tab out=work.cars replace;
  getnames=no;
  datarow=2;
run;

/**This data needs some intervention...
  One arena for doing data processing in SAS is the DATA step**/

/**We can use it to read text files...**/

data work.cars; /**data statement names the data set(s) to be created**/
  /**the INFILE and INPUT statments allow us to read from text files**/
  /**INFILE specifies the input file and potentially some instructions
      about its structure**/
  /**INPUT specifies the fields and some instructions on how to read each**/
  infile '~/SASData/cars.datfile';
  input Make Model Type Origin Drivetrain MSRP Invoice EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight Wheelbase Length;
  /**Point to the file in INFILE, list the names in column order in INPUT--
      this is called List Input in the SAS Documentation**/
run;

/**INFILE presumes the file is space-delimited unless you specify otherwise
    and any variable in the INPUT is presumed numeric unless you specify it is character**/

data work.cars; 
  /**DLM= sets the delimiter in the INFILE statement**/
  infile '~/SASData/cars.datfile' dlm='09'x; /**Tab cannot be expressed directly as a literal,
                                              use its code (09) as a literal followed by x to 
                                              tell SAS to convert**/
  /**For any variable that is character, you can give this instruction in
      INPUT by place a $ after the variable name**/
  input Make:$200. Model $ Type$ Origin$ Drivetrain $ MSRP Invoice EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight Wheelbase Length;
run;
/**that first row is of no use to me...**/

data work.cars; 
  infile '~/SASData/cars.datfile' dlm='09'x firstobs=2; /**firstobs tells which row to start in**/ 
  input Make$ Model $ Type$ Origin$ Drivetrain $ MSRP Invoice EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight Wheelbase Length;
run;
/**MSRP, Invoice, and Weight should be numbers, but in the data file they have non-standard characters,
    so we'll need a special instruction for those**/

data work.cars; 
  infile '~/SASData/cars.datfile' dlm='09'x firstobs=2; 
    /**you can attach an informat to any variable using the : as an operator,
        the informat provides the read instruction for the variable (not all formats are informats)**/
  input Make$ Model$ Type$ Origin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
run;/**informats are an instruction for reading, not displaying. If you want to set the display
        use a format statement**/

data work.cars; 
  infile '~/SASData/cars.datfile' dlm='09'x firstobs=2; 
  input Make$ Model$ Type$ Origin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
  format MSRP Invoice dollar12. weight comma8.;/**these are the default display formats...***/
  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';/**you can also create default labels**/
run;
/**Default length for character variables is 8, but it can be changed...***/

data work.cars; 
  infile '~/SASData/cars.datfile' dlm='09'x firstobs=2; 
  length Make Model $50 Type $15; /**can say LENGTH variable(s) $number ...; number is the length desired**/
  input Make$ Model$ Type$ Origin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
  format MSRP Invoice dollar12. weight comma8.;
  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
run;

data work.cars; 
  infile '~/SASData/cars.datfile' dlm='09'x firstobs=2; 
  input Make$ Model$ Type$ Origin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
  length Make Model $50 Type $15; /**Attributes are set based on the first encounter of a variable
                                    during processing, so these already length 8 from the INPUT statement
                                    and it's too late to change them now**/

  format MSRP Invoice dollar12. weight comma8.;
  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
run;

data work.cars; /**variable attributes are set as variables are encountered during compilation**/
  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
  format MSRP Invoice dollar12. weight comma8.;
  infile '~/SASData/cars.datfile' dlm='09'x firstobs=2; 
  length Make Model $50 Type $15;
  input Make$ Model$ Type$ Origin$ Drivetrain$ MSRP:dollar. Invoice:dollar. EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
run;

data work.cars; 
  infile '~/SASData/cars.datfile' dlm='09'x firstobs=2; 
  input Make:$50. Model:$50. Type:$15. Origin:$6. Drivetrain:$6. MSRP:dollar. Invoice:dollar. EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
      /**standard character format/informat is: $w. **/
  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
  format MSRP Invoice dollar12. weight comma8.;
run;
/**We have a problem with the row for the Mazda RX-8, line 42, because cylinders is missing
    which means that row has two consecutive tab characters.
  Since the default delimiter is space, consecutive delimiters are treated as a single delmiter by default...***/

data work.cars; 
  infile '~/SASData/cars.datfile' dlm='09'x firstobs=2 missover; 
    /**MISSOVER if we reach the end of a row in the raw file before filling in all values
        for the input variables, make the remaining ones missing (don't go to the next row and find something FLOWOVER)**/
  input Make:$50. Model:$50. Type:$15. Origin:$6. Drivetrain:$6. MSRP:dollar. Invoice:dollar. EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
  format MSRP Invoice dollar12. weight comma8.;
run;

data work.cars; 
  infile '~/SASData/cars.datfile' dsd dlm='09'x firstobs=2 missover; 
    /**DSD -> Delimiter Sensitive Data, invoking this does three things:
              1. Switches the default delimiter to a comma (but you can still change it as we did)
              2. Treats consecutive delimeters as containing a missing value
              3. Ignores delmiters in values embedded in quotes**/
  input Make:$50. Model:$50. Type:$15. Origin:$6. Drivetrain:$6. MSRP:dollar. Invoice:dollar. EngineSize Cylinders
        Horsepower CityMPG HighwayMPG Weight:comma. Wheelbase Length;
  label CityMPG = 'MPG City' HighwayMPG='MPG Highway';
  format MSRP Invoice dollar12. weight comma8.;
run;
