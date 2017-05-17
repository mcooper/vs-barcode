library(dplyr)
library(XML)
library(RPostgreSQL)

setwd('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/formhub/')

source('../formhub_connection.R')

con <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

tbl <- tbl(con, 'odk_logger_instance') %>% 
  filter(xform_id == 17 | xform_id == 33) %>%
  select(uuid, xml) %>%
  data.frame()

source('../production_connection.R')
con2 <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

head_table <- tbl(con2, 'yieldslab_hh') %>%
  data.frame()

df <- data.frame()
for (i in 1:nrow(tbl)){
  print(i)

  xml <- xmlToList(tbl[i, 'xml'])
  
  uuid <- tbl[i, 'uuid']
  
  form = xml$.attrs[1]

  if (!uuid %in% head_table$uuid){
    
    country <- xml$country
    
    landscape_no = xml$metadata$landscape_no
    
    eplot_no = xml$metadata$eplot_no
    
    hh_no = xml$metadata$hh_no
    
    date = xml$metadata$date
    
    df <- bind_rows(df, data.frame(form, uuid, country, landscape_no, eplot_no, hh_no, date))
    
  }
  
  if (uuid %in% head_table$uuid){
    
    upload_date <- xml$today
    
    migration_date <- '2017-04-26'
    
    dbSendQuery(con2$con, 
                paste0("INSERT INTO migration_audit VALUES ('", 
                       uuid, "', '",
                       form, "', '",
                       upload_date, "', '",
                       migration_date, "');"))
  }
}


out <- merge(df, head_table[ , c('country', 'uuid', 'landscape_no', 'eplot_no', 'hh_no', 'date')])

