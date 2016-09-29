library(dplyr)
library(knitr)
library(ggplot2)

get_gp_var <- function(country){
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
  gp_var
}

pretty_percent <- function(vec, rnd=1){
  paste0(round(vec*100,rnd), '%')
}

disp <- function(table, var, type, gp_var, choice_filter=NA){
  #A function to take in a Vital Signs variable and display it.
  
  localenv <- environment()
  
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
      geom_histogram(binwidth=floor(max(data[ ,var])/50)))
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
count_nulls <- function(data, var, gp_var){
  data$nas <- is.na(data[ , var])
  
  tab <- group_by_(data, gp_var) %>% 
    summarize(Total = n(),
              Filled = mean(!nas),
              Empty = mean(nas)) %>% 
    data.frame
  
  all <- data.frame(groupvar = 'Total', 
                    Total = length(data$nas),
                    Filled = mean(!data$nas),
                    Empty = mean(data$nas)) %>% 
    data.frame
  
  names(tab)[1] <- 'groupvar'
  out <- bind_rows(tab, all)
  names(out)[1] <- gp_var
  
  out$Filled <- pretty_percent(out$Filled)
  out$Empty <- pretty_percent(out$Empty)
  
  list(data=out, colnames=gsub('.', ' ', names(out), fixed = T))
}

#Number >2,3,4 stdev
count_outliers <- function(data, var, gp_var){
  std <- sd(data[ , var], na.rm=T)
  med <- median(data[ , var], na.rm=T)
  data$var <- data[!is.na(data[ ,var]) , var]
  
  tab <- group_by_(data, gp_var) %>% 
    summarize(Total = n(),
              Outside.Two.Standard.Deviations = mean(med + 2*std < var | med - 2*std > var),
              Outside.Three.Standard.Deviations = mean(med + 3*std < var | med - 3*std > var),
              Outside.Four.Standard.Deviations = mean(med + 4*std < var | med - 4*std > var),
              Outside.Five.Standard.Deviations = mean(med + 5*std < var | med - 5*std > var)) %>%
    data.frame
  
  all <- data.frame(groupvar = 'Total',
                    Total = length(data[ , var]),
                    Outside.Two.Standard.Deviations = mean(med + 2*std < data[ ,var] | med - 2*std > data[ ,var]),
                    Outside.Three.Standard.Deviations = mean(med + 3*std < data[ ,var] | med - 3*std > data[ ,var]),
                    Outside.Four.Standard.Deviations = mean(med + 4*std < data[ ,var] | med - 4*std > data[ ,var]),
                    Outside.Five.Standard.Deviations = mean(med + 5*std < data[ ,var] | med - 5*std > data[ ,var]))

  names(tab)[1] <- 'groupvar'
  out <- bind_rows(tab, all)
  names(out)[1] <- gp_var

  out$Outside.Two.Standard.Deviations <- pretty_percent(out$Outside.Two.Standard.Deviations)
  out$Outside.Three.Standard.Deviations <- pretty_percent(out$Outside.Three.Standard.Deviations)
  out$Outside.Four.Standard.Deviations <- pretty_percent(out$Outside.Four.Standard.Deviations)
  out$Outside.Five.Standard.Deviations <- pretty_percent(out$Outside.Five.Standard.Deviations)
    
  list(data=out, colnames=gsub('.', ' ', names(out), fixed = T))
}

