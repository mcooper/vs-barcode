setwd('D://Documents and Settings/mcooper/GitHub/vs-data-tools/flagging/')

library(dplyr)

source('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/updating-plant-names/update-names/production_connection.R')
con <- src_postgres(dbname = production_dbname, host = production_host, port = production_port, user = production_user, password = production_password)

table <- read.csv('flag-rules.csv', stringsAsFactors = F, na.strings = "")

views <- unique(table$table)

for (i in views){
  sel <- table[table$table==i, ]
  str <- ''
  for (j in 1:nrow(sel)){
    if (!is.na(sel$allmax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$allmax[j], " THEN '", sel$var[j], " is greater than ", gsub("'", "", sel$allmax[j]), "; ' ELSE '' END || ")
    }
    if (!is.na(sel$allmin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$allmin[j], " THEN '", sel$var[j], " is ", gsub("'", "", sel$allmin[j]), " or less; ' ELSE '' END || ")
    }    
    if (!is.na(sel$ghamax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$ghamax[j], " AND \"Country\" = 'GHA' THEN '", sel$var[j], " is greater than ", gsub("'", "", sel$ghamax[j]), " in Ghana; ' ELSE '' END || ")
    }
    if (!is.na(sel$ghamin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$ghamin[j], " AND \"Country\" = 'GHA' THEN '", sel$var[j], " is ", gsub("'", "", sel$ghamin[j]), " or less in Ghana; ' ELSE '' END || ")
    }    
    if (!is.na(sel$tzamax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$tzamax[j], " AND \"Country\" = 'TZA' THEN '", sel$var[j], " is greater than ", gsub("'", "", sel$tzamax[j]), " in Tanzania; ' ELSE '' END || ")
    }
    if (!is.na(sel$tzamin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$tzamin[j], " AND \"Country\" = 'TZA' THEN '", sel$var[j], " is ", gsub("'", "", sel$tzamin[j]), " or less in Tanzania; ' ELSE '' END || ")
    }    
    if (!is.na(sel$rwamax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$rwamax[j], " AND \"Country\" = 'RWA' THEN '", sel$var[j], " is greater than ", gsub("'", "", sel$rwamax[j]), " in Rwanda; ' ELSE '' END || ")
    }
    if (!is.na(sel$rwamin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$rwamin[j], " AND \"Country\" = 'RWA' THEN '", sel$var[j], " is ", gsub("'", "", sel$rwamin[j]), " or less in Rwanda; ' ELSE '' END || ")
    }    
    if (!is.na(sel$ugamax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$ugamax[j], " AND \"Country\" = 'UGA' THEN '", sel$var[j], " is greater than ", gsub("'", "", sel$ugamax[j]), " in Uganda; ' ELSE '' END || ")
    }
    if (!is.na(sel$ugamin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$ugamin[j], " AND \"Country\" = 'UGA' THEN '", sel$var[j], " is ", gsub("'", "", sel$ugamin[j]), " or less in Uganda; ' ELSE '' END || ")
    }
    if (!is.na(sel$countrycheck[j])){
      str <- paste0(str, "inside_country(", sel$countrycheck[j], ") || ")
    }
    if (!is.na(sel$landscapecheck[j])){
      str <- paste0(str, "inside_landscape(", sel$landscapecheck[j], ") || ")
    }
    if (!is.na(sel$duplicatevars[j])){
      str <- paste0(str, "CASE WHEN (count(*) over (partition by ", sel$duplicatevars[j], ")) > 1 THEN 'The record is duplicated in the schema' ELSE '' END || ")
    }
    if (!is.na(sel$sp_formula[j])){
      str <- paste0(str, "CASE WHEN (", sel$sp_formula[j], ") THEN '", sel$sp_response[j], "' ELSE '' END || ")
    }
    if (!is.na(sel$nullcheck[j])){
      str <- paste0(str, "CASE WHEN (", sel$var[j], " IS NULL) THEN '", sel$var[j], " is NULL' ELSE '' END || ")
    }
  }
  
  if (str == ''){
    str <- "''"
  } else{
    str <- substr(str, 1, nchar(str)-3)
  }
  
  tempname <- paste0('view_templates/', i, '.sql')
  template <- readChar(tempname, file.info(tempname)$size)
  
  query <- paste0('SELECT *,\n', str, ' AS "flag"\n FROM (', template, ') a') 
  drop <- paste0('DROP view flagging__', i)
  create <- paste0('CREATE OR REPLACE view flagging__', i, ' AS ', query)
  
  dbSendQuery(con$con, sql(final))
  dbSendQuery(con$con, sql(drop))
  dbSendQuery(con$con, sql(create))

  print(i)
}










