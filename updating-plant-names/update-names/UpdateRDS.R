library(plyr)
library(DBI)
library(dplyr)

setwd('D:/Documents and Settings/mcooper/Documents/GitHub Repos/vs-data-tools/updating-plant-names/update-names')

source('production_connection.R')

con <- src_postgres(dbname = production_dbname, host = production_host, port = production_port, user = production_user, password = production_password)

#Manually cleaned up csvs
rra <- read.csv('rra_plants.csv', stringsAsFactors=F, strip.white = T)
rra$tab <- 'rra_dominant'
rra$field <- 'tax'
trees <- read.csv('trees_plants.csv', stringsAsFactors=F, strip.white = T)
trees$tab <- 'eplot_woody_plant'
trees$field <- 'tree_tax'
eplot1 <- read.csv('eplot1_plants.csv', stringsAsFactors=F, strip.white = T)
eplot1$tab <- 'eplot_subplot_vegetation'
eplot1$field <- 'rank1_tax'
eplot2 <- read.csv('eplot2_plants.csv', stringsAsFactors=F, strip.white = T)
eplot2$tab <- 'eplot_subplot_vegetation'
eplot2$field <- 'rank2_tax'
eplot3 <- read.csv('eplot3_plants.csv', stringsAsFactors=F, strip.white = T)
eplot3$tab <- 'eplot_subplot_vegetation'
eplot3$field <- 'rank3_tax'

names(trees) <- gsub('subplot_tree_', '', names(trees))
names(eplot1) <- gsub('subplot_rank1_', '', names(eplot1))
names(eplot2) <- gsub('subplot_rank2_', '', names(eplot2))
names(eplot3) <- gsub('subplot_rank3_', '', names(eplot3))
  
clean <- rbind.fill(rra, trees, eplot1, eplot2, eplot3)
clean$subspecies[is.na(clean$subspecies)|clean$subspecies=='NULL'] <- '-'

us <- unique(clean[ , c('tax', 'genus', 'species', 'subspecies')])

ps <- tbl(con, sql('SELECT * FROM plant_species')) %>% data.frame

available <- seq(1, 5000)[!seq(1, 5000) %in% ps$id]
us$id <- available[1:nrow(us)]

for (i in 1:nrow(us)){
  ps <- tbl(con, sql('SELECT * FROM plant_species')) %>% data.frame
  
  #if the cleaned plant name is already in the plant_species table
  if (paste0(us$genus[i], us$species[i], us$subspecies[i]) %in% paste0(ps$genus, ps$species, ps$subspecies)){
    
    #get the ID of the cleaned name
    id <- ps$id[paste0(us$genus[i], us$species[i], us$subspecies[i])==paste0(ps$genus, ps$species, ps$subspecies)]
    
    #get the uuids for records that depend on old name
    sel <- clean[clean$genus==us$genus[i] & clean$species==us$species[i] & clean$subspecies==us$subspecies[i],]
    
    #update those dependant records to point to the new name
    for (j in 1:nrow(sel)){
      dbSendQuery(con$con, sql(paste0("UPDATE ", sel$tab[j], " SET ", sel$field[j], " = ", id, " WHERE uuid = \'", sel$uuid[j], "\';")))
    }
    
    #and delete the old record
    try(dbSendQuery(con$con, sql(paste0("DELETE FROM plant_species WHERE id = ", us$tax[i]))))
  }
  #othersie
  else{
    #Create a new recod for the cleaned name
    dbSendQuery(con$con, sql(paste0("Insert Into plant_species (id, genus, species, subspecies, approved)
                                            VALUES (", us$id[i], ", \'", us$genus[i], "\', \'", us$species[i], "\', \'", us$subspecies[i], "\', \'t\');")))
    
    #get the uuids for records that depend on the old name
    sel <- clean[clean$genus==us$genus[i] & clean$species==us$species[i] & clean$subspecies==us$subspecies[i],]
    
    #update those dependant records to point to the recently-created clean name
    for (j in 1:nrow(sel)){
      dbSendQuery(con$con, sql(paste0("UPDATE ", sel$tab[j], " SET ", sel$field[j], " = ", us$id[i], " WHERE uuid = \'", sel$uuid[j], "\';")))
    }
    
    #and delete the old record
    try(dbSendQuery(con$con, sql(paste0("DELETE FROM plant_species WHERE id = ", us$tax[i]))))    
  }
}
