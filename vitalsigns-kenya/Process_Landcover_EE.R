setwd('D://Documents and Settings/mcooper/GitHub/vs-data-tools/vitalsigns-kenya/')

library(tidyr)
library(dplyr)

dat <- read.csv('ee_output.csv')

dat[,grepl('X', names(dat))][is.na(dat[,grepl('X', names(dat))])] <- 0

###################################
##PAs
###################################

PA <- dat %>% filter(dataset=="PA")

PA$sum <- rowSums(PA[ , c("X0.0", "X1.0")], na.rm=T)

PA$Percent_Unprotected <- PA$X1.0/PA$sum
PA$Percent_Protected <- PA$X0.0/PA$sum

PA$Percent_Unprotected[is.nan(PA$Percent_Unprotected)] <- 0
PA$Percent_Protected[is.nan(PA$Percent_Protected)] <- 0

PA <- PA %>% dplyr::select(Percent_Unprotected, Percent_Protected, type, id) %>%
  gather(category, value, -type, -id)
  
#####################################
#Land Cover
######################################

LC <- dat %>% filter(grepl('cci', dataset))

zcols <- apply(LC, MARGIN = 2, FUN = function(x){sum(as.numeric(x))})==0

zcols[is.na(zcols)] <- FALSE

LC <- LC[ , !zcols]

LC$sum <- rowSums(LC[ , grepl('X', names(LC))])

ag <- paste0('X', c('10', '11', '20')) 
ag_mosaic <- paste0('X', c('30', '40' ))
water <- paste0('X', c('210'))
forest <- paste0('X', c('100', '160', '170', '50', '60', '61', '62', '70', '90'))
herbs_shrubs_grass <- paste0('X', c('110', '120', '122', '180', '130'))
sparse_veg_bare <- paste0('X', c('150', '153', '152', '200', '201', '202')) 
urban <- paste0('X', c('190'))

LC$pct_ag <- rowSums(LC[ , ag], na.rm=T)/LC$sum
LC$pct_ag_mosaic <- rowSums(LC[ , ag_mosaic], na.rm=T)/LC$sum
LC$pct_water <- LC[ , water]/LC$sum
LC$pct_forest <- rowSums(LC[ , forest], na.rm=T)/LC$sum
LC$pct_herbs_shrubs_grass <- rowSums(LC[ , herbs_shrubs_grass], na.rm=T)/LC$sum
LC$pct_sparse_veg_bare <- rowSums(LC[ , sparse_veg_bare], na.rm=T)/LC$sum
LC$pct_urban <- LC[ , urban]/LC$sum

LC <- LC %>% dplyr::select(dataset, id, type, pct_ag, pct_ag_mosaic, 
              pct_forest, pct_herbs_shrubs_grass, pct_sparse_veg_bare,
              pct_water) %>% 
  gather(category, value, -dataset, -id, -type) %>%
  mutate(category=paste0(category, '_20', substr(dataset, 4,5))) %>%
  dplyr::select(-dataset)

pop <- dat %>% 
  filter(dataset=='population') %>%
  dplyr::select(value=sum, id, type) %>%
  mutate(category='Estimated Total Pop 2015')

mkt <- dat %>% 
  filter(dataset=='market') %>%
  dplyr::select(value=mean, id, type) %>%
  mutate(category='Mean Travel Time to City with Pop > 50k')
         
final <- Reduce(f=bind_rows, x = list(mkt, pop, LC, PA))

final$pa_id <- final$id
final$county_id <- final$id
final$waterb_id <- final$id
final$country_id <- final$id

final$pa_id[final$type != 'pa'] <- NA
final$county_id[final$type != 'county'] <- NA
final$waterb_id[final$type != 'waterb'] <- NA
final$country_id[final$type != 'country'] <- NA

final <- final %>% dplyr::select(-type)

write.csv(final, 'indicators_landcover.csv', row.names=F)
  