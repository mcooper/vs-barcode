library(dplyr)

source('D:/Documents and Settings/mcooper/GitHub/vitalsigns-analysis/production_connection.R')

con <- src_postgres(dbname = dbname, host = host, port = port, user = user, password = password)

uuids <- tbl(con, sql('SELECT * FROM users_schema.form_log')) %>% select(survey_uuid, created_at) %>%
  data.frame

ag <- tbl(con, 'agric') %>% select(survey_uuid) %>% mutate(survey='agric') %>% data.frame
hh <- tbl(con, 'household') %>% select(survey_uuid) %>% mutate(survey='household') %>% data.frame
hhv <- tbl(con, 'household_secV') %>% select(survey_uuid) %>% mutate(survey='household_v') %>% data.frame
ffs <- tbl(con, 'farmfieldsoils') %>% select(survey_uuid) %>% mutate(survey='ffs') %>% data.frame
ffs_l <- tbl(con, 'farmfieldsoils_lab') %>% select(survey_uuid) %>% mutate(survey='ffs_l') %>% data.frame
ffs_ym <- tbl(con, 'farmfieldsoils_yields_maize') %>% select(survey_uuid) %>% mutate(survey='ffs_ym') %>% data.frame
ffs_yp <- tbl(con, 'farmfieldsoils_yields_paddy_maize') %>% select(survey_uuid) %>% mutate(survey='ffs_yp') %>% data.frame
ffs_w <- tbl(con, 'farmfieldsoils_yields_weight') %>% select(survey_uuid) %>% mutate(survey='ffs_w') %>% data.frame
eplot <- tbl(con, 'eplot') %>% select(survey_uuid) %>% mutate(survey='eplot') %>% data.frame
eplot_l <- tbl(con, 'eplotsoils_lab') %>% select(survey_uuid) %>% mutate(survey='eplot_l') %>% data.frame
eplot_s <- tbl(con, 'eplotsoils_sample') %>% select(survey_uuid) %>% mutate(survey='eplot_s') %>% data.frame
rra <- tbl(con, 'rra') %>% select(survey_uuid) %>% mutate(survey='rra') %>% data.frame
rwa <- tbl(con, 'rapid_water') %>% select(survey_uuid) %>% mutate(survey='rwa') %>% data.frame
wq <- tbl(con, 'water_quality') %>% select(survey_uuid) %>% mutate(survey='wq') %>% data.frame


all <- Reduce(rbind, list(ag, hh, hhv, ffs, ffs_l, ffs_ym, 
                          ffs_yp, ffs_w, eplot, eplot_l, eplot_s, rra, rwa, wq))

uuids <- uuids[!duplicated(uuids$survey_uuid),]

forms <- tbl(con, sql('SELECT * FROM users_schema.form_log')) %>% select(xform_name) %>% data.frame %>% unique


library(httr)

csrf <- GET(url='http://surveys.vitalsigns.org')$cookies$value[1]

POST('http://surveys.vitalsigns.org', body=list(id_username='username',
                                                id_password='ReeZ2eu5',
                                                submit = 'Sign in',
                                                csrfmiddlewaretoken=csrf))

df <- data.frame()
for (i in 1:nrow(forms)){
  print(forms[i,])
  tryCatch({
      t <- read.csv(paste0('http://surveys.vitalsigns.org/vs2015v1/forms/', forms[i,], '/data.csv'))
      df <- bind_rows(df, data.frame(survey_uuid=t$X_uuid, form=forms[i,], time=t$X_submission_time))
      }, 
      error=function(e){print(e)})
}

df[!(df$survey_uuid %in% all$survey_uuid), ]

