library(dplyr)
library(XML)
library(RPostgreSQL)

setwd('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/formhub/')

source('../production_connection.R')
con2 <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

blanks <- tbl(con2, 'piiname_agric') %>%
  filter(is.na(ag_head_name)) %>%
  select(uuid) %>%
  data.frame()


source('../formhub_connection.R')
con <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

tbl <- tbl(con, 'odk_logger_instance') %>% 
  filter(uuid %in% blanks$uuid) %>%
  select(xml, uuid) %>%
  data.frame()

source('../production_connection.R')
con2 <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

for (i in 1:nrow(tbl)){
  print(i)
  xml <- xmlToList(tbl[i, 'xml'])

  uuid <- tbl[i, 'uuid']
  
  if(!is.null(xml$metadata$hh_name)){
    name <- toupper(xml$metadata$hh_name)
  }else{
    name <- toupper(paste0(xml$metadata$hh_first_name, xml$hh_last_name))
  }

  if(!is.null(name)){
    dbSendQuery(con2$con, paste0("UPDATE piiname_agric SET ag_head_name = '", name, '\' WHERE uuid = \'', uuid, '\';'))
  }
}


