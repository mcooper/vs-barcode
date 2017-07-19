library(dplyr)
library(raster)
library(rgdal)

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