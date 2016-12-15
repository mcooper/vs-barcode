library(dplyr)

setwd('D://Documents and Settings/mcooper/GitHub/vs-data-tools/flagging/view_templates/')

source('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/updating-plant-names/update-names/production_connection.R')
con <- src_postgres(dbname = production_dbname, host = production_host, port = production_port, user = production_user, password = production_password)

files <- list.files()

for (f in files){
  sql <- readLines(f)
  forms <- tbl(con, sql(paste0(sql, collapse='\n'))) 
}


