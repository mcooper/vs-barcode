library(DBI)
library(dplyr)

setwd('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/updating-plant-names/update-names')

source('production_connection.R')

con <- src_postgres(dbname = production_dbname, host = production_host, port = production_port, user = production_user, password = production_password)

uu <- read.csv('UniqueUpdates.csv', stringsAsFactors=F)

dbSendQuery(con$con, sql("UPDATE plant_species SET approved = 'f';"))

for (i in 1:nrow(uu)){
  print(i)
  if (uu$Name.in.Database[i] == uu$Proposed.New.Name[i]){
    dbSendQuery(con$con, sql(paste0("UPDATE plant_species SET approved = 't' WHERE id = ", uu$id, ';')))
  }else{
    ps <- tbl(con, sql('SELECT * FROM plant_species')) %>% data.frame
    
    #if the cleaned plant name is already in the plant_species table
    if (paste0(uu$genus[i], uu$species[i], uu$subspecies[i]) %in% paste0(ps$genus, ps$species, ps$subspecies)){
      
      #get the ID of the cleaned name
      id <- ps$id[paste0(uu$genus[i], uu$species[i], uu$subspecies[i])==paste0(ps$genus, ps$species, ps$subspecies)]
      
      #update all possible linking tables
      dbSendQuery(con$con, sql(paste0('UPDATE rra_dominant SET tax = ', id, 'WHERE tax = ', uu$id[i], ';')))
      dbSendQuery(con$con, sql(paste0('UPDATE eplot_woody_plant SET tree_tax = ', id, 'WHERE tree_tax = ', uu$id[i], ';')))
      dbSendQuery(con$con, sql(paste0('UPDATE eplot_subplot_vegetation SET rank1_tax = ', id, 'WHERE rank1_tax = ', uu$id[i], ';')))
      dbSendQuery(con$con, sql(paste0('UPDATE eplot_subplot_vegetation SET rank2_tax = ', id, 'WHERE rank2_tax = ', uu$id[i], ';')))
      dbSendQuery(con$con, sql(paste0('UPDATE eplot_subplot_vegetation SET rank3_tax = ', id, 'WHERE rank3_tax = ', uu$id[i], ';')))
      
      #Set the name to approved
      dbSendQuery(con$con, sql(paste0('UPDATE plant_species SET approved = \'t\' WHERE id = ', id, ';')))
      
      #and delete the old record
      try(dbSendQuery(con$con, sql(paste0("DELETE FROM plant_species WHERE id = ", uu$id[i], ';'))))
    
    }else{
      
      dbSendQuery(con$con, sql(paste0("UPDATE plant_species SET genus = '", uu$genus[i], "', species = '", uu$species[i], "', subspecies = '", uu$subspecies[i], "', approved = 't' WHERE id = ", uu$id[i], ';')))
    
    }
  }
  print(paste0(i, ' ', uu$id[i]))
}
    
    