#' First dump a fresh copy of the database into staging.  
#' 
#' Then run the following code on staging.
#' 
#' Finally, you can dump a copy of the staging db, so have a portable, pii-free
#' copy of the database
#'
#

library(DBI)
library(dplyr)

setwd('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/anonymize data')

source('D://staging_connection.R')

vs_db <- src_postgres(dbname=staging_dbname, host=staging_host,
                      user=staging_user, password=staging_password,
                      port=staging_port)

#First drop audit and users_schema
#Then drop household_secV

dbSendQuery(vs_db$con, sql('DROP SCHEMA audit CASCADE;'))

dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.audit;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.data_product;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.deleted_record;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.download;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.download_cart;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.form_log;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.monitoring_alert;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.oauth_access_grants;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.oauth_access_tokens;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.oauth_applications;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.setting;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.user;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.weatherstation_contactlist;'))
dbSendQuery(vs_db$con, sql('DROP TABLE users_schema.weatherstation_maintenance;'))

dbSendQuery(vs_db$con, sql('DROP TRIGGER farmfieldsoils_yields_paddy_maize_hh_ref ON farmfieldsoils_yields_paddy_maize;'))
dbSendQuery(vs_db$con, sql('DROP TRIGGER farmfieldsoils_yields_maize_hh_ref ON farmfieldsoils_yields_maize;'))
dbSendQuery(vs_db$con, sql('DROP TRIGGER farmfieldsoils_yields_weight_hh_ref ON farmfieldsoils_yields_weight;'))
dbSendQuery(vs_db$con, sql('DROP TRIGGER farmfieldsoils_lab_hh_ref ON farmfieldsoils_lab;'))
dbSendQuery(vs_db$con, sql('DROP TRIGGER farmfieldsoils_hh_ref ON farmfieldsoils;'))
dbSendQuery(vs_db$con, sql('DROP TRIGGER farmfieldsoils_processed_hh_ref ON farmfieldsoils_processed;'))
dbSendQuery(vs_db$con, sql('DROP TRIGGER agric_hh_ref ON agric;'))
dbSendQuery(vs_db$con, sql('DROP TRIGGER household_hh_ref ON household;'))

pii <- read.csv('pii fields.csv', stringsAsFactors=F)

for (i in 1:nrow(pii)){
  if (pii$action[i]=='removed'){
    dbSendQuery(vs_db$con, sql(paste0('UPDATE "', pii$table[i], '" SET ', pii$var[i], ' = NULL')))
  }else if(pii$action[i]=='overwrite'){
    dbSendQuery(vs_db$con, sql(paste0('UPDATE "', pii$table[i], '" SET ', pii$var[i], " = concat('dummy data ', substr(md5(random()::text), 1, 5))")))
  }else if(pii$action[i]=='randomized'){
    cty_lscp <- tbl(vs_db, pii$table[i]) %>% 
      select(country, landscape_no) %>% 
      distinct() %>% 
      data.frame()
    for (j in 1:nrow(cty_lscp)){
      eplots <- tbl(vs_db, pii$table[i]) %>% 
        filter(country == cty_lscp$country[j], landscape_no == cty_lscp$landscape_no[j]) %>% 
        select(eplot_no) %>% 
        distinct() %>%
        data.frame()
      eplots$new <- sample(eplots$eplot_no, nrow(eplots), F)
      for (k in 1:nrow(eplots)){
        dbSendQuery(vs_db$con, sql(paste0('UPDATE "', pii$table[i], '" SET eplot_no = \'', eplots$new[k],
                                          "' WHERE country = '", cty_lscp$country[j], "' AND landscape_no = '",
                                          cty_lscp$landscape_no[j], "' AND eplot_no = '", eplots$eplot_no[k], "';")))
        print(paste0('k:', k))
      }
      print(paste0('j:', j))
    }
  }
  print(paste0('i:', i))
}
