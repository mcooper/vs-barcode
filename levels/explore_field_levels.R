field_roster <- tbl(con, 'flagging__agric_field_roster') %>% 
  select(survey_uuid, `Field ID`) %>%
  mutate(field_roster=1) %>%
  data.frame()

field_details <- tbl(con, 'flagging__agric_field_details') %>% 
  select(survey_uuid, `Field ID`, Season) %>% 
  mutate(field_details=1) %>%
  data.frame() %>%
  melt(id.vars=c('survey_uuid', 'Field.ID', 'Season')) %>% 
  dcast(formula=survey_uuid + Field.ID ~ Season + variable) %>%
  data.frame
field_details[is.na(field_details)] <- 0

crops_by_field <- tbl(con, 'flagging__agric_crops_by_field') %>% 
  select(survey_uuid, `Field ID`, Season, `Crop name`) %>%
  mutate(crops_by_field=1) %>%
  data.frame() %>%
  melt(id.vars=c('survey_uuid', 'Field.ID', 'Season', 'Crop.name')) %>%
  dcast(formula=survey_uuid + Field.ID + Crop.name ~ Season + variable) %>%
  data.frame()
crops_by_field[is.na(crops_by_field)] <- 0

perm_by_field <- tbl(con, 'flagging__agric_perm_crops_by_field') %>% 
  #filter(!is.na(ag6a_05)) %>%
  select(survey_uuid, `Field ID`, `Crop name`) %>%
  mutate(perm_by_field = 1) %>%
  data.frame()

livestock_by_field <- tbl(con, 'flagging__agric_livestock_by_field') %>% 
  select(survey_uuid, `Field ID`) %>%
  mutate(livestock=1) %>%
  data.frame()

field <- Reduce(function(x, y, all){merge(x, y, all=T)}, list(field_roster, livestock_by_field, field_details, crops_by_field), perm_by_field))
