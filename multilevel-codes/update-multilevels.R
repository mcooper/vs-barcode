setwd('D://Documents and Settings/mcooper/GitHub/vs-data-tools/')

library(dplyr)
library(RPostgreSQL)

source('production_connection.R')
prod <- src_postgres(dbname=dbname, host=host,
                     user=user, password=password,
                     port=port)

source('local_connection.R')
local <- src_postgres(dbname="vitalsigns", host=host,
                      user=user, password=password,
                      port=port)

codes <- read.csv('multilevel-codes/codes.csv')

old <- c('household', 'agric', 'farmfieldsoils', 'farmfieldsoils_yields_maize', 'farmfieldsoils_yields_paddy_maize', 'farmfieldsoils_yields_weight')
new <- c('household', 'agric', 'farmsoils',      'yields',                      'yields',                            'yieldslab')


#regions and districts
for (i in 4:length(old)){
  print(old[i])
  orig <- tbl(local, old[i]) %>%
    select(uuid, country, region, district) %>%
    collect
  
  orig$region <- as.integer(orig$region)
  orig$district <- as.integer(orig$district)
  
  orig <- merge(orig, codes, all.x=T, all.y=F)
  
  pb <- txtProgressBar(min = 0, max = nrow(orig), style = 3)
  for (j in 1:nrow(orig)){
    sql <- paste0("UPDATE ", new[i], " SET region = '", orig$region_name[j],
                  "', district = '", orig$district_name[j], "' WHERE uuid = '",
                  orig$uuid[j], "';")
    
    dbSendQuery(prod$con, sql)
    setTxtProgressBar(pb, j)
  }
  print(new[i])
}


#education levels
orig <- tbl(local, 'household_secC') %>%
  select(uuid, survey_uuid, hh_c07) %>%
  left_join(tbl(local, 'household') %>%
         select(uuid, country),
       by=c('survey_uuid'='uuid')) %>%
  filter(!is.na(hh_c07)) %>%
  collect

orig$hh_c07 <- as.integer(orig$hh_c07)

ed <- read.csv('multilevel-codes/edcodes.csv')

orig <- merge(orig, ed)

pb <- txtProgressBar(min = 0, max = nrow(orig), style = 3)
for (j in 1:nrow(orig)){
  sql <- paste0("UPDATE household_individual SET hh_c07 = $$", 
                orig$label[j], "$$ WHERE uuid = '",
                orig$uuid.x[j], "';")
  
  dbSendQuery(prod$con, sql)
  setTxtProgressBar(pb, j)
}







