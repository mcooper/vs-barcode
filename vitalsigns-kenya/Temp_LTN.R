setwd('D://Documents and Settings/mcooper/Documents/VS Kenya Data Processing/')

fs <- list.files(pattern='.nc$')

#get long term normal
ltn <- sapply(FUN=stack, X=fs[1:6]) %>% stack

#get last five years
rec <- sapply(FUN=stack, X=fs[7]) %>% stack

ms <- c('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')


for (m in ms){
  print(m)

  mn <- paste0(m, '...$')
  
  cat('long term mean')
  ltn_sel <- ltn[[which(grepl(mn, names(ltn)))]] %>% mean(na.rm=T)
  cat('\nrecent mean')
  rec_sel <- rec[[which(grepl(mn, names(rec)))]] %>% mean(na.rm=T)
  
  cat('\ndifference')
  dif <- rec_sel - ltn_sel
  
  cat('\nwrite')
  writeRaster(dif, filename = paste0('TempLTN', m, '.tif'), format='GTiff')
}



list.files(pattern='TempLTN...tif$') %>%
  stack %>%
  mean(na.rm=T) %>%
  writeRaster(filename='TempLTNAnnual.tif', format='GTiff', overwrite=T)
