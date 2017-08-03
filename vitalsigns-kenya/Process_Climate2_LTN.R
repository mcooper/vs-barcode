setwd('D:/Documents and Settings/mcooper/Documents/VS Kenya Data Processing/')

library(dplyr)

csv <- read.csv('indicators_climate_ltn.csv')

cats <- read.csv('category.csv')

csv <- merge(cats, csv, by.y='category', by.x='x')

csv$x <- NULL

write.csv(unique(csv[ , c('topic', 'indicator_name', 'slug', 'table_name')]),
                        'climate_indicators_ltn_meta.csv', row.names=F)

for (i in unique(csv$table_name)){
  sel <- csv %>%
    filter(table_name == i) %>%
    dplyr::select(category=slug, pa_id, county_id, waterb_id, country_id, value, date)
  
  write.csv(sel, i, row.names=F)
  
}
