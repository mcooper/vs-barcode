library(dplyr)
library(raster)
library(rgdal)

tmp <- tempdir()
setwd(tmp)

system(paste0("aws s3 cp s3://vitalsigns-kenya/Data/0_Boundaries/ ", tmp, " --recursive"))


sp1 <- readOGR('.', 'Conservancies')
sp1@data$name <- sp1@data$NAME
sp1@data$type <- 'pa'
sp1 <- sp1[ , c('name', 'type', 'area_ha')]
sp1 <- spChFIDs(sp1, paste0('pa.conservancy', row.names(sp1)))

sp2 <- readOGR('.', 'Counties')
sp2@data$name <- sp2@data$county_id
sp2@data$type <- 'county'
sp2 <- sp2[ , c('name', 'type', 'area_ha')]
sp2 <- spChFIDs(sp2, paste0('county', row.names(sp2)))

sp3 <- readOGR('.', 'Forest')
sp3@data$name <- sp3@data$Fname
sp3@data$type <- 'pa'
sp3@data$area_ha <- sp3@data$AREA_HA
sp3 <- sp3[ , c('name', 'type', 'area_ha')]
sp3 <- spChFIDs(sp3, paste0('pa.forest', row.names(sp3)))

sp4 <- readOGR('.', 'WDPA_Kenya')
sp4@data$name <- paste0(sp4@data$NAME, ' ', sp4@data$DESIG)
sp4@data$type <- 'pa'
sp4@data$area_ha <- sp4@data$GIS_AREA*100
sp4 <- sp4[ , c('name', 'type', 'area_ha')]
sp4 <- spChFIDs(sp4, paste0('pa.wpa', row.names(sp4)))
sp4 <- spTransform(sp4, CRS("+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"))

sp5 <- readOGR('.', 'KenyaBoundary')
sp5@data$name <- sp5@data$country_id
sp5@data$type <- 'country'
sp5 <- sp5[ , c('name', 'type', 'area_ha')]
sp5 <- spChFIDs(sp5, paste0('country', row.names(sp5)))

sp6 <- readOGR('.', 'Water_Basins')
sp6@data$name <- sp6@data$BASIN_1
sp6@data$type <- 'waterb'
sp6 <- sp6[ , c('name', 'type', 'area_ha')]
sp6 <- spChFIDs(sp6, paste0('waterb', row.names(sp6)))
sp6 <- spTransform(sp6, CRS("+proj=laea +lat_0=5 +lon_0=20 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"))

sp <- Reduce(f=rbind, x = list(sp1, sp2, sp3, sp4, sp5, sp6))

sp <- spTransform(sp, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

writeOGR(sp, '.', 'geometries', driver='ESRI Shapefile',
         overwrite_layer = T)

system(paste0('aws s3 cp ', tmp, '\\ s3://vitalsigns-kenya/Data/0_Boundaries/ --recursive --exclude "*" --include "geometries*"'))

system(paste0('rm ', tmp, ' -rf'))

