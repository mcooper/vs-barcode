disp <- function(table, 
                 var, 
                 type, 
                 country = c('GHA', 'TZA', 'RWA', 'UGA', 'ALL'), 
                 choice_filter=NA)
  {
  #A function to take in a Vital Signs variable and display it.
  
  localenv <- environment()
  
  #################
  ##Infer Parameter Vars
  ################
  if (country %in% c('GHA', 'TZA', 'RWA', 'UGA')){
    gp_var <- 'Landscape..'
    data <- filter(data, Country==country)
  }
  else if (country == 'ALL'){
    gp_var <- 'Country'    
  }
  else{
    cat('Unrecognized argument for country')
  }
  
  ##Type: date
  if (grepl('date', type)){

  }
  
  ##Type: text, string
  else if (grepl('text|string', type)){
    
  }
  
  ##Type: time
  else if (grepl('time', type)){
    
  }
  
  ##Type: select
  else if (grepl('select', type)){
    
  }
  
  ##Type: calculate
  else if (grepl('calculate', type)){
    
  }
  
  ##Type: decimal
  else if (grepl('decimal', type)){
    print(ggplot(data, aes_string(x=var, fill=gp_var), environment = localenv) +
      geom_bar())
  }
  
  ##Type: int
  else if (grepl('int', type)){
    
  }
  
  ##Type: audio
  else if (grepl('audio', type)){
    
  }
  
  ##Type: barcode
  else if (grepl('barcode', type)){
    
  }
  
  ##string:
  else if (grepl('string', type)){
    
  }
  
  else{
    cat('This is not a recognized variable type')
  }
  
}
  
#Other functions
count_nulls <- function(table, var){
  
}

#Number >2,3,4 stdev
count_outliers <- function(table, var, std){
  
}

