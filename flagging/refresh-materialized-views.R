library(DBI)
library(dplyr)

vs_db <- src_postgres(dbname=dbname, host=host, user=user, password=pswd, port=port)

out <- tbl(vs_db, sql('SELECT oid::regclass::text
                      FROM   pg_class
                      WHERE  relkind = \'m\'')) %>% data.frame

out <- out$oid

for (i in out){
  dbSendQuery(vs_db$con, sql(paste0("REFRESH MATERIALIZED VIEW ", i)))
}