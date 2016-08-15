library(plyr)
library(dplyr)
library(jsonlite)

setwd('D:/Documents and Settings/mcooper/Documents/GitHub Repos/vs-data-tools/updating-plant-names/update-names')

findOriginal <- function(forms, table, section, prefix){
  updates <- data.frame()
  for (i in 1:nrow(table)){
    sel <- forms[forms$survey_uuid==table$survey_uuid[i],][1,]
    sel <- fromJSON(sel$body[1])$sections[[section]]
    cnames <- c('uuid', paste0(prefix, c('genus', 'species', 'common', 'subspecies', 'code')))
    cnames <- cnames[cnames %in% names(sel)]
    sel <- sel[sel$uuid==table$uuid[i], cnames]
    sel$tax <- table$tax[i]
    updates <- rbind.fill(updates, sel)
  }
  return(updates)
}

badplants <- read.csv('Bad_Plant_Names.csv')
ids <- paste0(badplants$id, collapse = ', ')

source('staging_connection.R')
con <- src_postgres(dbname = staging_dbname, host = staging_host, port = staging_port, user = staging_user, password = staging_password)
forms <- tbl(con, sql("SELECT body, survey_uuid from users_schema.form_log")) %>% data.frame

rradb <- tbl(con, sql(paste0('SELECT
                             d.survey_uuid,
                             d.uuid,
                             d.tax
                             FROM rra_dominant d
                             Join rra r on d.parent_uuid=r.uuid
                             WHERE tax in (', ids, ')'))) %>% data.frame %>% unique

rra <- findOriginal(forms, rradb, 'dominant', '')


eplotdb1 <- tbl(con, sql(paste0('SELECT
                                a.survey_uuid,
                                a.uuid,
                                a.rank1_tax AS tax
                                FROM eplot_subplot_vegetation a
                                JOIN eplot e on a.parent_uuid=e.uuid
                                WHERE rank1_tax in (', ids, ')'))) %>% data.frame %>% unique

eplot1 <- findOriginal(forms, eplotdb1, 'subplot_group', 'subplot_rank1_')


eplotdb2 <- tbl(con, sql(paste0('SELECT
                                a.survey_uuid,
                                a.uuid,
                                a.rank2_tax AS tax
                                FROM eplot_subplot_vegetation a
                                JOIN eplot e on a.parent_uuid=e.uuid
                                WHERE rank2_tax in (', ids, ')'))) %>% data.frame %>% unique
eplot2 <- findOriginal(forms, eplotdb2, 'subplot_group', 'subplot_rank2_')


eplotdb3 <- tbl(con, sql(paste0('SELECT
                                a.survey_uuid,
                                a.uuid,
                                a.rank3_tax AS tax
                                FROM eplot_subplot_vegetation a
                                JOIN eplot e on a.parent_uuid=e.uuid
                                WHERE rank3_tax in (', ids, ')'))) %>% data.frame %>% unique

eplot3 <- findOriginal(forms, eplotdb3, 'subplot_group', 'subplot_rank3_')


treedb <- tbl(con, sql(paste0('SELECT
                              a.survey_uuid,
                              a.uuid,
                              a.tree_tax AS tax
                              FROM eplot_woody_plant a
                              JOIN eplot e on a.parent_uuid=e.uuid
                              WHERE a.tree_tax in (', ids, ')'))) %>% data.frame %>% unique

tree <- findOriginal(forms, treedb, 'subplot_group/subplot_holder/tree', 'subplot_tree_')

write.csv(rra, 'rra_plants2.csv', row.names=F, na='NULL')
write.csv(eplot1, 'eplot1_plants2.csv', row.names=F, na='NULL')
write.csv(eplot2, 'eplot2_plants2.csv', row.names=F, na='NULL')
write.csv(eplot3, 'eplot3_plants2.csv', row.names=F, na='NULL')
write.csv(tree, 'trees_plants2.csv', row.names=F, na='NULL')