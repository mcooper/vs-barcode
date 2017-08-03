0 - NA
1 - Dense Forest
2 - Moderate Forest
3 - Open Forest
4 - Open Grassland
5 - Wooded Grassland
6 - Perennial Cropland
7 - Annual Cropland
8 - Vegatated Wetland
9 - Open Water
10 - Otherland

library(raster)


for (i in c('1990', '1995', '2000')){
  print(i)
  
  r <- raster(paste0('D://Documents and Settings/mcooper/Desktop/KLC', i, 'CPN_DRSRS_V5.img'))
  
  rcl <- matrix(c(seq(0,10), c(0, 1, 1, 1, 4, 4, 6, 6, 4, 9, 4)), ncol=2)
  
  reclassify(r, rcl, filename=paste0('SLEEK_', i, '.tif'), format='GTiff')
}