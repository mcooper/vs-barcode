library(dplyr)

setwd('D:/Documents and Settings/mcooper/Documents/Taxonomic Scrubber/PlantCurationBug')

source('connection.R')

con <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

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

names(trees) <- c('uuid', 'genus', 'species', 'common', 'subspecies', 'code', 'tab', 'field')
names(eplot1) <- c('uuid', 'genus', 'species', 'subspecies', 'common', 'tab', 'field')
names(eplot2) <- c('uuid', 'genus', 'species', 'subspecies', 'tab', 'field')
names(eplot3) <- c('uuid', 'genus', 'species', 'subspecies', 'common', 'tab', 'field')

clean <- rbind.fill(rra, trees, eplot1, eplot2, eplot3)
clean$subspecies[is.na(clean$subspecies)] <- '-'

ps <- tbl(con, sql('SELECT * FROM plant_species')) %>% data.frame

available <- seq(1, 5000)[!seq(1, 5000) %in% ps$id]

clean$id <- available[1:nrow(clean)]

for (i in 1:nrow(clean)){
  ps <- tbl(con, sql('SELECT * FROM plant_species')) %>% data.frame
  if (paste0(clean$genus[i], clean$species[i], clean$subspecies[i]) %in% paste0(ps$genus, ps$species, ps$subspecies)){
    id <- ps$id[paste0(clean$genus[i], clean$species[i], clean$subspecies[i])==paste0(ps$genus, ps$species, ps$subspecies)]
    dbSendQuery(con$con, sql(paste0("UPDATE ", clean$tab[i], " SET ", clean$field[i], " = ", id, " WHERE uuid = \'", clean$uuid[i], "\';")))
  }
  else{
    dbSendQuery(con$con, sql(paste0("Insert Into plant_species (id, genus, species, subspecies, approved)
                                            VALUES (", clean$id[i], ", \'", clean$genus[i], "\', \'", clean$species[i], "\', \'", clean$subspecies[i], "\', \'t\');
                                            UPDATE ", clean$tab[i], " SET ", clean$field[i], " = ", clean$id[i], " WHERE uuid = \'", clean$uuid[i], "\';")))
  }
}
