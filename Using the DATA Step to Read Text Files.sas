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

  