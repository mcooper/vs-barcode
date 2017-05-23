library(dplyr)
library(aws.s3)

setwd('D:/Documents and Settings/mcooper/GitHub/vitalsigns-data-reports')

pg_conf <- read.csv('rds_settings', stringsAsFactors=FALSE)

vs_db <- src_postgres(dbname='vitalsigns', host=pg_conf$host,
                      user=pg_conf$user, password=pg_conf$pass,
                      port=pg_conf$port)

aws.signature::use_credentials()

views <- c("c__eplot", "c__household", "c__eplot_subplot", "c__eplot_subplot_vegetation", 
           "c__eplot_subplot_tree", "c__eplot_subplot_tree_stem", "c__household_extension",
           "c__household_field", "c__rra", "c__rra_tree", "c__household_cropbyprod",
           "c__household_field_season_fieldcrop", "c__weatherstation_data", 
           "c__household_field_season_individual", "c__household_field_permcrop", 
           "c__household_field_season", "c__water", "c__household_fieldcrop", 
           "c__household_implement", "c__household_individual", 
           "c__household_livestock", "c__household_livestockbyprod", "c__household_permcrop", 
           "c__household_priceinfo", "c__household_expenditure", "c__household_food", 
           "c__household_possession", "c__household_resource", "c__household_water")

writeS3 <- function(df, name){
  zz <- rawConnection(raw(0), "r+")
  write.csv(df, zz, row.names=F)
  aws.s3::put_object(file = rawConnectionValue(zz),
                     bucket = "vitalsigns-website-downloads", object = name)
  close(zz)
}

for (v in views){
  print(v)
  table <- tbl(vs_db, v) %>% data.frame
  
  writeS3(table, paste0('tables/', gsub('c__', '', v), '.csv'))
}
  