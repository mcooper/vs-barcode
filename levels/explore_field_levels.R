field_roster <- tbl(con, 'agric_field') %>% 
  select(survey_uuid, field_id) %>%
  mutate(field_roster=1) %>%
  data.frame()

field_details <- tbl(con, 'agric_field_season') %>% 
  select(survey_uuid, field_id, season) %>% 
  mutate(field_details=1) %>%
  data.frame() %>%
  melt(id.vars=c('survey_uuid', 'field_id', 'season')) %>% 
  dcast(formula=survey_uuid + field_id ~ season + variable) %>%
  data.frame
field_details[is.na(field_details)] <- 0

crops_by_field <- tbl(con, 'agric_field_season_fieldcrop') %>% 
  select(survey_uuid, field_id, season, crop_name) %>%
  mutate(crops_by_field=1) %>%
  data.frame() %>%
  melt(id.vars=c('survey_uuid', 'field_id', 'season', 'crop_name')) %>%
  dcast(formula=survey_uuid + field_id + crop_name ~ season + variable) %>%
  data.frame()
crops_by_field[is.na(crops_by_field)] <- 0

perm_by_field <- tbl(con, 'agric_field_permcrop') %>% 
  #filter(!is.na(ag6a_05)) %>%
  select(survey_uuid, field_id, crop_name) %>%
  mutate(perm_by_field = 1) %>%
  data.frame()

field <- Reduce(function(x, y, all){merge(x, y, all=T)}, list(field_roster, field_details, crops_by_field, perm_by_field))

write.csv(field, 'ag_field.csv', row.names=F)
