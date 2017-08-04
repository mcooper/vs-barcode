setwd('D://Documents and Settings/mcooper/Documents/VS Kenya Data Processing/')

library(rjson)
library(dplyr)
library(tidyr)
library(reshape2)

getVal <- function(substr){
  spl <- strsplit(substr, '=')[[1]][2] %>%
    as.numeric
  return(spl)
}

getDf <- function(str){
  cats <- gsub('\\{|\\}', '', str) %>%
    strsplit(', ') %>%
    .[[1]]
  
  Forest <- 0
  Grass <- 0
  Cropland <- 0
  Water <- 0
  Null <- 0
  for (i in cats){
    if (substr(i, 1, 3)=='1.0'){
      Forest <- getVal(i)
    }else if(substr(i, 1, 3)=='4.0'){
      Grass <- getVal(i)
    }else if (substr(i, 1, 3)=='6.0'){
      Cropland <- getVal(i)
    }else if (substr(i, 1, 3)=='9.0'){
      Water <- getVal(i)
    }else if (substr(i, 1, 3)=='0.0'){
      Null <- getVal(i)
    }else{
      stop('Missing category in ', i)
    }
  }
  DF <- data.frame(Forest=Forest, Grass=Grass, 
                   Cropland=Cropland, Water=Water,
                   Null=Null)
  return(DF)
}

years <- c('2014', '2010', '2005', '2000', '1995', '1990')

accum <- data.frame()
for (y in years){
  print(y)
  s <- read.csv(paste0('S', y, '.csv')) %>%
    select(histogram, id, name, type)
                  
  s$histogram <- as.character(s$histogram)
  s$date <- y

  t <- lapply(X=s$histogram, FUN = getDf)
  catsdf <- Reduce(f=bind_rows, t)
  
  s$histogram <- NULL
  
  s <- cbind(s, catsdf)
  
  accum <- bind_rows(accum, s)
}

write.csv(accum, 'AllLandcover.csv', row.names=F)

accum$total <- rowSums(accum[ , c('Forest', 'Grass', 'Cropland', 'Water')], na.rm=T)
  
accum$Grass <- accum$Grass/accum$total
accum$Forest <- accum$Forest/accum$total
accum$Cropland <- accum$Cropland/accum$total
accum$Water <- accum$Water/accum$total  


accum$Null <- NULL
accum$total <- NULL
accum$name <- NULL

accum %>%
  melt(id.vars=c('id', 'type', 'date'))

accum$pa_id[accum$type=='pa'] <- accum$id[accum$type=='pa']
accum$waterb_id[accum$type=='waterb'] <- accum$id[accum$type=='waterb']
accum$county_id[accum$type=='county'] <- accum$id[accum$type=='county']
accum$country_id[accum$type=='country'] <- accum$id[accum$type=='country']



  
  
