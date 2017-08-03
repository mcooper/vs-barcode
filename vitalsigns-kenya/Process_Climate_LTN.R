library(dplyr)
library(raster)
library(rgdal)
library(tidyr)

tmp <- tempdir()
setwd(tmp)

system(paste0('aws s3 cp s3://vitalsigns-kenya/Data/0_Boundaries/ ', tmp, 
              ' --recursive --exclude "*" --include "geometries*"'))

system(paste0('aws s3 cp s3://vitalsigns-kenya/Data/0_Boundaries/ ', tmp, 
              ' --recursive --exclude "*" --include "geometries*"'))

sp <- readOGR('.', 'geometries')

setwd('D:/Documents and Settings/mcooper/Documents/VS Kenya Data Processing/')

files <- list.files(pattern='.tif$', recursive = T)

files <- files[!files %in% names(sp@data)]

for (f in files){
  print(f)
  
  r <- raster(f)
  sp@data[ , f] <- raster::extract(r, sp, method='bilinear', fun=mean, na.rm=T)
  write.csv(sp@data, 'indicators_climate_ltn.csv')
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

write.csv(test, 'indicators_climate_ltn.csv', row.names=F)

