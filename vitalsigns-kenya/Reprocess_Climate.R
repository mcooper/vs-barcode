setwd('D://Documents and Settings/mcooper/Desktop/climate/')

all <- data.frame()
for (f in list.files()){
  all <- bind_rows(all, read.csv(f))
}

all$date <- paste0(all$date, '-01-01T00:00:00Z')

all$id <- coalesce(all$pa_id, all$county_id, all$country_id, all$waterb_id)

csv <- read.csv('D://Documents and Settings/mcooper/Documents/VS Kenya Data Processing/remove3.csv') %>%
  filter(id_1 > 0) %>%
  select(id)

all <- merge(all, csv, all=F)

setwd('D://Documents and Settings/mcooper/Documents/VS Kenya Data Processing/')

write.csv(all[!grepl('rcp', all$category), ], 'current_climate_indicator.csv',
          row.names=F, na = 'None')

write.csv(all[grepl('rcp', all$category), ], 'projected_climate_indicator.csv',
          row.names=F, na = 'None')
