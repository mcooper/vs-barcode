library(dplyr)

setwd('D:/Documents and Settings/mcooper/Documents/GitHub Repos/vs-data-tools/updating-plant-names/update-names')

source('staging_connection.R')
con <- src_postgres(dbname = staging_dbname, host = staging_host, port = staging_port, user = staging_user, password = staging_password)

badplants <- tbl(con, sql("SELECT
                           *
                           FROM plant_species
                           WHERE genus ~ '[^\\w]|[0-9]' OR
			                     species ~ '[^\\w]|[0-9]'")) %>% data.frame

write.csv(badplants, 'Bad_Plant_Names.csv', row.names=F)
