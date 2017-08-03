setwd('D://Documents and Settings/mcooper/Desktop/')

library(dplyr)

csv <- read.csv('D:/DOCUME~1/mcooper/AppData/Local/Temp/RtmpK4mfPI/indicators_climate.csv')


ss <- c('MaxTemp/MaxTemp', 'MaxTempRCP26/Max2050TempRCP26', 
        'MaxTempRCP45/Max2050TempRCP45', 'MaxTempRCP60/Max2050TempRCP60', 
        'MaxTempRCP85/Max2050TempRCP85', 'MeanTemp/MeanTemp', 'MinTemp/MinTemp', 
        'MeanPrecipRCP26/Mean2050PrecipRCP26', 
        'MeanPrecipRCP45/Mean2050PrecipRCP45', 'MeanPrecipRCP60/Mean2050PrecipRCP60', 
        'MeanPrecipRCP85/Mean2050PrecipRCP85')

fs <- list(max, max, 
        max, max, 
        max, mean, min,
        sum,sum,sum,sum)

for (i in 1:length(ss)){
  csv <- csv %>% filter(grepl(ss[i], category)) %>%
    group_by(id, pa_id, county_id, waterb_id, country_id, date) %>%
    summarize(value=fs[[i]](value, na.rm=T)) %>%
    mutate(category=paste0(ss[i], '-Annual.tif')) %>%
    bind_rows(csv)
  print(ss[i])
  print(dim(csv))
}

csv$value[is.infinite(csv$value)] <- NA

cats <- read.csv('categories.csv')
cats$x <- paste0(cats$x, '.tif')

csv <- merge(cats, csv, by.y='category', by.x='x')

csv$x <- NULL

write.csv(unique(csv[ , c('topic', 'indicator_name', 'slug', 'table_name')]),
                        'climate_indicators_meta.csv', row.names=F)

csv$date <- csv$date.x
csv$date.x <- NULL
csv$date.y <- NULL

for (i in unique(csv$table_name)){
  sel <- csv %>%
    filter(table_name == i) %>%
    select(category=slug, pa_id, county_id, waterb_id, country_id, value, date)
  
  write.csv(sel, i, row.names=F)
  
}
