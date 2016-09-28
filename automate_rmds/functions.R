disp <- function(table, 
                 var, 
                 type = c(''), 
                 country = c('GHA', 'TZA', 'RWA', 'UGA', 'ALL'), 
                 choice_filter=NA)
  {
  #A function to take in a Vital Signs variable and display it.
  
  #################
  ##Infer Parameter Vars
  ################
  if (country %in% c('GHA', 'TZA', 'RWA', 'UGA')){
    gp_var = landscape_no
  }
  else if (country == 'ALL'){
    gp_var = country    
  }
  else{
    cat('Unrecognized argument for country')
  }
  
  ##Type: date
  if (grepl('date', type)){

  }
  
  ##Type: text, string
  if (grepl('text|string', type)){
    
  }
  
  ##Type: time
  if (grepl('time', type)){
    
  }
  
  ##Type: select
  if (grepl('select', type)){
    
  }
  
  ##Type: calculate
  if (grepl('calculate', type)){
    
  }
  
  ##Type: decimal
  if (grepl('deciaml', type)){
    
  }
  
  ##Type: int
  if (grepl('int', type)){
    
  }
  
  ##Type: audio
  if (grepl('audio', type)){
    
  }
  
  ##Type: barcode
  if (grepl('barcode', type)){
    
  }
  
  ##string:
  if (grepl('string', type)){
    
  }
  
  else{
    cat('This is not a recognized variable type')
  }
  
#Other functions
count_nulls <- function(table, var){
  
}

#Number >2,3,4 stdev
count_outliers <- function(table, var, std){
  
}

