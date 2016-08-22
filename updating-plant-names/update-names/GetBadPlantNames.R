library(dplyr)

setwd('D:/Documents and Settings/mcooper/Documents/GitHub Repos/vs-data-tools/updating-plant-names/update-names')

source('production_connection.R')
con <- src_postgres(dbname = production_dbname, host = production_host, port = production_port, user = production_user, password = production_password)

badplants <- tbl(con, sql("SELECT
                           *
                           FROM plant_species
                           WHERE genus ~ '[^\\w]|[0-9]' OR
			                     species ~ '[^\\w]|[0-9]'")) %>% data.frame

write.csv(badplants, 'Bad_Plant_Names.csv', row.names=F)
