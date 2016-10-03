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

disp <- function(var, type, choice_filter=NA){
  #A function to take in a Vital Signs variable and display it.
  
  ##Type: date
  if (grepl('date', type)){
    return('gotta do date still')
  }
  
  ##Type: text, string
  else if (grepl('text|string', type)){
    return('gotta do string still')  
  }
  
  ##Type: time
  else if (grepl('time', type)){
    return('gotta do time still')
  }
  
  ##Type: select
  else if (grepl('select', type)){
    return('gotta do select still')
  }
  
  ##Type: calculate
  else if (grepl('calculate', type)){
    return('gotta do calculate still')
  }
  
  ##Type: decimal
  else if (grepl('decimal', type)){
    out <- paste0(
    'ggplot(data, aes(x=', var, ', fill=gp_var)) +
      geom_histogram(binwidth=floor(max(data[ ,', var, '])/50))
    
    nullsd <- count_nulls(data, ', var, ', gp_var)
    outsd <- count_outliers(data, ', var, ', gp_var)
    
    kable(nullsd[[1]], col.names=nullsd[[2]])
    kable(outsd[[1]], col.names=outsd[[2]])')
    return(out)
  }
  
  ##Type: int
  else if (grepl('int', type)){
    return('gotta do int still')
  }
  
  ##Type: audio
  else if (grepl('audio', type)){
    return('gotta do audio still')
  }
  
  ##Type: barcode
  else if (grepl('barcode', type)){
    return('gotta do barcode still')
  }
  
  ##string:
  else if (grepl('string', type)){
    return('gotta do string still')
  }
  
  ##image:
  else if (grepl('image', type)){
    return('gotta do image still')
  }
  
  else{
    cat('Variable:', var, 'Type:', type, ' is not a recognized variable type\n')
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

