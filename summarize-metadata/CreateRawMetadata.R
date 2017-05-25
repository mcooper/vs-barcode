setwd('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/summarize-metadata/')

library(readxl)
library(dplyr)

map <- read_xlsx('Formhub-DB-Mapping.xlsx') %>% data.frame

metadata_columns <- c("ViewVar", "label", "values", "Protocol")
newnames <- c("Variable", "Definition", "Values", "Protocol")

schemavars <- c('id','country','landscape_no','eplot_no','hh_refno','field_no', 'season', 'round',
                'subplot','tree_code','stem_id')
                

for (i in na.omit(unique(map$ViewName))){
  sel <- map[which(map$ViewName == i), ]
  
  sel <- sel[order(sel$Order), ]
  
  sel <- sel[ , metadata_columns]
  
  sel$Protocol[sel$ViewVar %in% schemavars] <- NA
  
  sel <- unique(sel)

  names(sel) <- newnames
  
  write.csv(sel, paste0('metadata_raw/', i, ' codebook.csv'), row.names=F, na='')
}