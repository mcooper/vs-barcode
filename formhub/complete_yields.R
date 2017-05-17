library(dplyr)
library(XML)
library(RPostgreSQL)

setwd('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/formhub/')

source('../formhub_connection.R')

con <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

tbl <- tbl(con, 'odk_logger_instance') %>% 
  filter(xform_id == 19 | xform_id == 39 | xform_id == 18 | xform_id == 34) %>%
  select(xml, uuid) %>%
  data.frame()

source('../production_connection.R')
con2 <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

for (i in 1:nrow(tbl)){
  print(i)
  xml <- xmlToList(tbl[i, 'xml'])

  uuid <- tbl[i, 'uuid']

  area1 <- xml$b_group$f1_b_group$f1_101_grp$f1_101
  
  field_name1 <- xml$a_group$selected_fields$selected_first_field
  
  
  if(!is.null(area1)){
    dbSendQuery(con2$con, paste0("UPDATE yields_field SET b_101 = ", area1, ' WHERE survey_uuid = \'', uuid, '\' AND field_no = \'', field_name1, '\';'))
  }
  
  area2 <- xml$b_group$f2_b_group$f2_101_grp$f2_101
  
  field_name2 <- xml$a_group$selected_fields$selected_second_field
  
  if(!is.null(area2)){
    dbSendQuery(con2$con, paste0("UPDATE yields_field SET b_101 = ", area2, ' WHERE survey_uuid = \'', uuid, '\' AND field_no = \'', field_name2, '\';'))
    
  }
}


