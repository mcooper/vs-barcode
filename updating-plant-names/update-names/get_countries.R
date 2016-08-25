library(plyr)
library(DBI)
library(dplyr)

setwd('D:/Documents and Settings/mcooper/Documents/GitHub Repos/vs-data-tools/updating-plant-names/update-names')

source('production_connection.R')

con <- src_postgres(dbname = production_dbname, host = production_host, port = production_port, user = production_user, password = production_password)

plant_ids <- tbl(con, 'plant_species') %>% select(id)

rra <- tbl(con, sql('SELECT * FROM rra_dominant JOIN rra on rra_dominant.parent_uuid=rra.uuid')) %>% 
  select(country, tax) %>%
  data.frame

eplot <- tbl(con, sql('SELECT * FROM eplot_subplot_vegetation JOIN eplot on eplot_subplot_vegetation.parent_uuid=eplot.uuid')) %>% 
  select(country, rank1_tax, rank2_tax, rank3_tax) %>%
  data.frame

eplot2 <- tbl(con, sql('SELECT * FROM eplot_woody_plant JOIN eplot on eplot_woody_plant.parent_uuid=eplot.uuid')) %>% 
  select(country, tree_tax) %>%
  data.frame

eplota <- eplot[ , c('country', 'rank1_tax')]
eplotb <- eplot[ , c('country', 'rank2_tax')]
eplotc <- eplot[ , c('country', 'rank3_tax')]

names(eplota)[2] <- 'tax'
names(eplotb)[2] <- 'tax'
names(eplotc)[2] <- 'tax'
names(eplot2)[2] <- 'tax'

all <- rbind(rra, eplota, eplotb, eplotc, eplot2) %>% unique

plant_names <- read.csv('../ProcessedNames_ForTeams.csv', stringsAsFactors = F)

plant_country <- merge(plant_names, all, all.y=T, by.x='id', by.y='tax')

plant_country$sort <- 0
plant_country$sort[!plant_country$Proposed.New.Name==""] <- 0.5
plant_country$sort[plant_country$Name.in.Database==plant_country$Proposed.New.Name] <- 1
pc <- plant_country[order(plant_country$sort), ]
pc <- pc[!is.na(pc$Name.in.Database), ]

pc$Proposed.New.Name[!grepl(' ', pc$Proposed.New.Name) & pc$sort!=0]  <- paste0(pc$Proposed.New.Name[!grepl(' ', pc$Proposed.New.Name) & pc$sort!=0], ' sp')

write.csv(pc[pc$country=='TZA', ], 'TZA-plants.csv', row.names=F)
write.csv(pc[pc$country=='GHA', ], 'GHA-plants.csv', row.names=F)
write.csv(pc[pc$country=='RWA', ], 'RWA-plants.csv', row.names=F)
write.csv(pc[pc$country=='UGA', ], 'UGA-plants.csv', row.names=F)

perc_1 <- function(vect){
  len1 <- sum(vect==1)
  len <- length(vect)
  len1/len
}

group_by(pc, country) %>% summarize(perc_1(sort))







