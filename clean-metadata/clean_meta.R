library(dplyr)
library(DBI)

source('D://production_connection.R')

vs_db <- src_postgres(dbname=production_dbname, host=production_host,
                      user=production_user, password=production_password,
                      port=production_port)

hhv <- tbl(vs_db, 'household_secV') %>% data.frame

map <- read.csv('hh_codes.csv')

map$revised.EPLOT.no. <- substr(1000 + map$revised.EPLOT.no., 2, 4)
map$hh_no.1 <- substr(100 + map$hh_no.1, 2, 3)

for (i in hhv$hh_no[is.na(hhv$country)]){
  if (i %in% map$hh_no){
    sel <- map[which(map$hh_no==i),]
    dbSendQuery(vs_db$con, sql(paste0('UPDATE "household_secV" SET country=\'', sel$country.1, '\', landscape_no=\'', 
                                    sel$landscape_no.1, '\', eplot_no=\'', sel$revised.EPLOT.no., '\', hh_no=\'', sel$hh_no.1,
                                    '\' WHERE hh_no=\'', i, '\';')))
  }
}
