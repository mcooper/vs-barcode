library(dplyr)
library(reshape2)
detach("package:raster", unload=TRUE)

setwd('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/levels')

source('../production_connection.R')
con <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

###########
##Household
###########

#Get Ind-level
ind <- tbl(con, 'household_individuals') %>% select(-parent_uuid) %>% data.frame()

#Get HH-level data
secHV2 <- tbl(con, 'household_secHV2') %>% data.frame()
secI <- tbl(con, 'household_secI') %>% data.frame()
secJ1 <- tbl(con, 'household_secJ1') %>% data.frame()
secJ2 <- tbl(con, 'household_secJ2') %>% data.frame()
secK1 <- tbl(con, 'household_secK1') %>% data.frame()
secK2 <- tbl(con, 'household_secK2') %>% data.frame()
secL <- tbl(con, 'household_secL') %>% data.frame()
secN <- tbl(con, 'household_secN') %>% data.frame()
secA <- tbl(con, 'household') %>% data.frame()

hh <- Reduce(merge, list(secHV2, secI, secJ1, secJ2, secK2, secL, secN, secA))

secK1 <- secK1 %>% select(-uuid, -parent_uuid)

k1m <- melt(secK1, id.vars=c("survey_uuid", "k_item"))
k1c <- dcast(k1m, survey_uuid~k_item + variable)

hh_k1 <- merge(hh, k1c)

write.csv(hh %>% select(-hh_first_name_cpt, -hh_last_name_cpt), 'hh.csv', row.names=F)
write.csv(hh_k1, 'hh_k1.csv', row.names=F)
write.csv(ind %>% select(-indid_cpt), 'hh_ind.csv', row.names=F)

#########
#Agric
#########

#field level
field_roster <- tbl(con, 'flagging__agric_field_roster') %>% select(-uuid, -parent_uuid, -flag) %>% data.frame()

field_details <- tbl(con, 'flagging__agric_field_details') %>% select(-uuid, -parent_uuid, -flag, -Country, -`Partner Organization`, -longitude, -latitude, -Date, -Round, -`Landscape #`, -`Household ID`) %>% data.frame() %>%
  melt(id.vars=c('survey_uuid', 'Field.ID', 'Season')) %>% 
  dcast(formula=survey_uuid + Field.ID ~ Season + variable)

crops_by_field <- tbl(con, 'flagging__agric_crops_by_field') %>% select(-uuid, -parent_uuid, -flag, -Country, -`Partner Organization`, -longitude, -latitude, -Date, -Round, -`Landscape #`, -`Household ID`) %>% data.frame() %>%
  melt(id.vars=c('survey_uuid', 'Field.ID', 'Season', 'Crop.name')) %>%
  dcast(formula=survey_uuid + Field.ID + Crop.name ~ Season + variable)

livestock_by_field <- tbl(con, 'flagging__agric_livestock_by_field') %>% select(-uuid, -parent_uuid, -flag, -Country, -`Partner Organization`, -longitude, -latitude, -Date, -Round, -`Landscape #`, -`Household ID`) %>% data.frame()

field <- Reduce(function(x, y, all){merge(x, y, all=T)}, list(field_roster, livestock_by_field, field_details, crops_by_field))


#other
crops_by_hh <- tbl(con, 'flagging__agric_crops_by_hh') %>% data.frame()

perm_by_field <- tbl(con, 'flagging__agric_perm_crops_by_field') %>% select(survey_uuid, `Field ID`, `Crop name`) %>%mutate(perm_by_field = 1) %>%data.frame()

perm_crops_by_crop <- tbl(con, 'flagging__agric_perm_crop') %>% data.frame()

byproducts <- tbl(con, 'flagging__agric_byprod') %>% data.frame()

livestock <- tbl(con, 'flagging__agric_livestock') %>% data.frame()

livestock_byprod <- tbl(con, 'flagging__agric_livestock_byproduct') %>% data.frame()

implements <- tbl(con, 'flagging__agric_implement') %>% data.frame()

extension <- tbl(con, 'flagging__agric_extension') %>% data.frame()

extension_family <- tbl(con, 'flagging__agric_extension_family') %>% data.frame()

agric <- tbl(con, 'flagging__agric') %>% data.frame()

write.csv(field, 'ag_field.csv', row.names=F)
write.csv(crops_by_hh, 'ag_crops_by_hh.csv', row.names=F)
write.csv(perm_by_field, 'ag_perm_crops_by_field.csv', row.names=F)
write.csv(perm_crops_by_crop, 'ag_perm_crops_by_crop.csv', row.names=F)
write.csv(byproducts, 'ag_byproducts.csv', row.names=F)
write.csv(livestock, 'ag_livestock.csv', row.names=F)
write.csv(livestock_byprod, 'ag_livestock_byproduct.csv', row.names=F)
write.csv(implements, 'ag_implements.csv', row.names=F)
write.csv(extension, 'ag_extension.csv', row.names=F)
write.csv(extension_family, 'ag_extension_family.csv', row.names=F)
write.csv(agric, 'ag.csv', row.names=F)








