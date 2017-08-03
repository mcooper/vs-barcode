setwd('D://Documents and Settings/mcooper/Documents/CHIRPS/')

fs <- list.files(pattern='.tif$')

#get long term normal
ltnfs <- fs[1:377]
ltn <- stack(ltnfs)

#get last five years
recfs <- fs[387:length(fs)]
rec <- stack(recfs)

ms <- c('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')

setwd('D://Documents and Settings/mcooper/Documents/VS Kenya Data Processing/')

for (m in ms){
  print(m)

  sel <- paste0('chirps.v2.0......', m)
  cat('long term mean')
  ltn_sel <- ltn[[which(grepl(sel, names(ltn)))]] %>% mean(na.rm=T)
  cat('\nrecent mean')
  rec_sel <- rec[[which(grepl(sel, names(rec)))]] %>% mean(na.rm=T)
  
  cat('\ndifference')
  dif <- rec_sel - ltn_sel
  
  cat('\nwrite')
  writeRaster(dif, filename = paste0('PrecipLTN', m, '.tif'), format='GTiff')
}
