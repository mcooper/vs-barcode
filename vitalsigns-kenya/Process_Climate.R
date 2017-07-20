library(dplyr)
library(raster)
library(rgdal)
library(tidyr)

tmp <- tempdir()
setwd(tmp)

system(paste0('aws s3 cp s3://vitalsigns-kenya/Data/0_Boundaries/ ', tmp, 
              ' --recursive --exclude "*" --include "geometries*"'))

sp <- readOGR('.', 'geometries')

system(paste0('aws s3 cp s3://vitalsigns-kenya/Data/Climate/ ', tmp,
              ' --recursive --exclude "*" --include "*Temp*"'))
system(paste0('aws s3 cp s3://vitalsigns-kenya/Data/Climate/ ', tmp,
              ' --recursive --exclude "*" --include "*Precip*"'))

files <- list.files(pattern='.tif$', recursive = T)

files <- files[!files %in% names(sp@data)]

for (f in files){
  print(f)
  if(grepl('Mean', f)){
    func <- mean
  }
  if(grepl('Min', f)){
    func <- min
  }
  if(grepl('Max', f)){
    func <- max
  }
  
  r <- raster(f)
  sp@data[ , f] <- extract(r, sp, method='bilinear', fun=func)
  write.csv(sp@data, 'climate_extracts.csv')
}

df <- sp@data

test <- df %>% gather(category, value, -name, -type, -area_ha, -id) %>%
  dplyr::select(-area_ha, -name)

test$pa_id <- test$id
test$county_id <- test$id
test$waterb_id <- test$id
test$country_id <- test$id

test$pa_id[test$type != 'pa'] <- NA
test$county_id[test$type != 'county'] <- NA
test$waterb_id[test$type != 'waterb'] <- NA
test$country_id[test$type != 'country'] <- NA

test <- test %>% dplyr::select(-type)

test$date[grepl('2050', test$category)] <- 2050

write.csv(test, 'indicators_climate.csv', row.names=F)

system(paste0('aws s3 cp ', tmp, '\\indicators_climate.csv s3://vitalsigns-kenya/Data/indicators_climate.csv'))

system(paste0('rm ', tmp, ' -rf'))
