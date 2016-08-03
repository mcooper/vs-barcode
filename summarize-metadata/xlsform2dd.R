library(xlsx)
library(RCurl)

filepath <- "D:\\Documents and Settings\\mcooper\\Documents\\Staging Form and DD Updates\\Rapid Roadside Assessment Survey\\VS_RapidRoadside_17.09.2015.xlsx"

vsda <- 

vartypes <- 'start|end$|today|date|text|time|select*|string|calculate|decimal|image|interger'

excel_file <- read.xlsx(filepath, sheetName='survey', stringsAsFactors=F)
          
justvars <- excel_file[grepl(vartypes, excel_file$type),c('type', 'name', 'label', 'hint', 'required', 'constraint_message')]

#Group is just a label.  Repeat repeats

#Need to manually add: Values List, Example, name in db, tables in db.
#OR read mappings from RoR script?

getURL('https://github.com/ConservationInternational/vitalsigns-data-apps/blob/master/lib/forms/versions/rra_v1_form.rb')

