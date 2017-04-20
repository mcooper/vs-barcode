library(dplyr)
library(XML)
library(RPostgreSQL)

setwd('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/formhub/')

source('../formhub_connection.R')

con <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

tbl <- tbl(con, 'odk_logger_instance') %>% 
  #filter(xform_id == 18 | xform_id == 34) %>%
  filter(xform_id == 19 | xform_id == 39) %>%
  select(xml, uuid) %>%
  data.frame()

source('../production_connection.R')
con2 <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)


for (i in 1:nrow(tbl)){
  xml <- xmlToList(tbl[i, 'xml'])

  uuid <- tbl[i, 'uuid']

  crop_name <- xml$b_group$f1_b_group$f1_y_crop$f1_yield_crop_name
  
  dbSendQuery(con2$con, paste0("UPDATE farmfieldsoils_yields_paddy_maize SET crop = '", crop_name, "' WHERE uuid = '", uuid, "';"))
}


