library(dplyr)

setwd('D:/Documents and Settings/mcooper/Documents/Taxonomic Scrubber/PlantCurationBug')

findOriginal <- function(table, section, prefix){
  updates <- data.frame()
  for (i in 1:nrow(table)){
    suppressWarnings(sel <- tbl(con, sql(paste0("SELECT body from users_schema.form_log
                                                WHERE survey_uuid = '", table$survey_uuid[i], "'"))) %>% data.frame)
    sel <- fromJSON(sel$body[1])$sections[[section]]
    cnames <- c('uuid', paste0(prefix, c('genus', 'species', 'common', 'subspecies', 'code')))
    cnames <- cnames[cnames %in% names(sel)]
    sel <- sel[sel$uuid==table$uuid[i], cnames]
    updates <- rbind.fill(updates, sel)
  }
  return(updates)
}

source('connection.R')

con <- src_postgres(dbname = dbname, host=host, port = port, user=user, password=password)


rradb <- tbl(con, sql('SELECT
                 d.survey_uuid,
                 d.uuid
                 FROM rra_dominant d
                 Join rra r on d.parent_uuid=r.uuid
                 WHERE tax=4086')) %>% data.frame

rra <- findOriginal(rradb, 'dominant', '')


eplotdb1 <- tbl(con, sql('SELECT
                         a.survey_uuid, 
                         a.uuid
                         FROM eplot_subplot_vegetation a
                         JOIN eplot e on a.parent_uuid=e.uuid
                         WHERE rank1_tax=4086')) %>% data.frame

eplot1 <- findOriginal(eplotdb1, 'subplot_group', 'subplot_rank1_')


eplotdb2 <- tbl(con, sql('SELECT
                         a.survey_uuid,  
                         a.uuid
                         FROM eplot_subplot_vegetation a
                         JOIN eplot e on a.parent_uuid=e.uuid
                         WHERE rank2_tax=4086')) %>% data.frame

eplot2 <- findOriginal(eplotdb2, 'subplot_group', 'subplot_rank2_')


eplotdb3 <- tbl(con, sql('SELECT
                         a.survey_uuid, 
                         a.uuid
                         FROM eplot_subplot_vegetation a
                         JOIN eplot e on a.parent_uuid=e.uuid
                         WHERE rank3_tax=4086')) %>% data.frame

eplot3 <- findOriginal(eplotdb3, 'subplot_group', 'subplot_rank3_')


treedb <- tbl(con, sql('SELECT
                       a.survey_uuid,
                       a.uuid
                       FROM eplot_woody_plant a
                       JOIN eplot e on a.parent_uuid=e.uuid
                       WHERE a.tree_tax=4086')) %>% data.frame

tree <- findOriginal(treedb, 'subplot_group/subplot_holder/tree', 'subplot_tree_')

#Write original names to csv, and then edit the csvs manually
write.csv(rra, 'rra_plants.csv', row.names=F, na='NULL')
write.csv(eplot1, 'eplot1_plants.csv', row.names=F, na='NULL')
write.csv(eplot2, 'eplot2_plants.csv', row.names=F, na='NULL')
write.csv(eplot3, 'eplot3_plants.csv', row.names=F, na='NULL')
write.csv(tree, 'trees_plants.csv', row.names=F, na='NULL')