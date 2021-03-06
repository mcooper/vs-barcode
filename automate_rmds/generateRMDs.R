##Need to come up with a Plant Species display
    #Change the type based on the dbtable, then make a new if in disp()

##There is something wrong with a lot of the duplicates, look more into Metadata_tools.csv

##Figure out the select_many vars

##Summarize Table vars - how many rows are all records blank for?, etc

source('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/automate_rmds/functions.R')
source('D:/Documents and Settings/mcooper/GitHub/vs-data-tools/automate_rmds/disp.R')

setwd('D:/Documents and Settings/mcooper/Documents/Automate Data Dictionaries/RMD_Outputs')

meta <- read.csv('../Metadata_tool.csv', stringsAsFactors=F)

#Prep metadata vars
meta <- handleDuplicates(meta)
meta <- meta[meta$type != 'calculate', ]
meta$type[grepl('_other', meta$User_Vars)] <- 'text'

meta$type[meta$DB_Tables == 'plant_species'] <- 'plant_species'

getOtherTables <- function(x){
  tabs <- unique(meta$User_Tables)
  if(grepl('_', x)){
    prefix <- substr(x, 1, gregexpr('_', x)[[1]][1]-1)
  }else{
    prefix <- x
  }
  tabs <- tabs[grepl(prefix, tabs)]
  tabs <- tabs[tabs!=x]
  tabs
}

getHead <- function(c, t){
  paste0('---
title: "', c, ' ', gsub('_', ' ', t), '"
output: 
    html_document:
        toc: true
---


```{r, include=FALSE}
library(lubridate)
library(ggplot2)
library(dplyr)
library(knitr)
library(stringr)
library(RPostgreSQL)

source(\'D:/Documents and Settings/mcooper/GitHub/vs-data-tools/automate_rmds/functions.R\')

pg_conf <- read.csv(\'D:/Documents and Settings/mcooper/GitHub/vitalsigns-data-reports/rds_settings\', stringsAsFactors=FALSE)

options(scipen=20)

vs_db <- src_postgres(dbname=\'vitalsigns\', host=pg_conf$host,
user=pg_conf$user, password=pg_conf$pass,
port=pg_conf$port)

#Do it local to test
#vs_db <- src_postgres(dbname=\'vitalsigns_local\', host=\'localhost\',
#user=\'postgres\', password=\'postgres\',
#port=2222)

country <- "', c, '"

data <- tbl(vs_db, \'flagging__', t, '\') %>% 
data.frame(stringsAsFactors=F)

if (country != \'ALL\'){
  data <- filter(data, Country==country)
}

flags <- getFlags(data)

gp_var <- get_gp_var(country)

```
Report generated `r now(tzone=\'UTC\')` UTC.

')
}

getBody <- function(sel){
  body <- '#Variable Summaries'
  for (j in 1:nrow(sel)){
    body <- paste0(body, '

##', sel$User_Vars[j],'
**', sel$label[j], '**

*Variable Type: ', sel$type[j], '*

```{r, echo=FALSE, warning=FALSE, messages=FALSE, fig.align="center"}
', disp(make.names(sel$User_Vars[j]), type = sel$type[j], values=sel$values[j]), '

tf <- tableFlags(flags, "', sel$User_Vars[j], '")

if (nrow(tf) > 0){
  kable(tf)
}

```


***
***

')
  }
  body
}

getFoot <- function(c, t, sel){
  dispnames <- c('Country', 'Landscape..', 'Eplot..', 'Household.ID', make.names(sel$User_Vars))
  foot <- paste0('
#Raw Data
```{r, echo=FALSE, warning=FALSE}
DT::datatable(data[ ,(names(data) %in% c("', paste(dispnames, collapse='", "'), '", "flag"))])
```

```{r, include=FALSE}
RPostgreSQL::dbDisconnect(vs_db$con)

```


#See Also
####Same Country, Similar Tables
')
  for (i in getOtherTables(t)){
    link <- paste(c, i, sep='-')
    foot <- paste0(foot, '
[', link, '](', link, '.html)
')
  }
  foot <- paste0(foot, '
####Same Table, Other Countries
')
  allc <- c('ALL', 'GHA', 'TZA', 'UGA', 'RWA')
  otherc <- allc[allc != c]
  for (i in otherc){
    link <- paste(i, t, sep='-')
    foot <- paste0(foot, '
[', link, '](../', i, '/', link, '.html)
')
  }
  foot
}

tables <- unique(meta$User_Tables)

for (c in c("GHA", "TZA", "RWA", "UGA", "ALL")){
  for(t in tables){
    sel <- meta[meta$User_Tables==t & (meta$User_Tables==substr(meta$DB_Tables,1,53) | grepl('Genus|genus', meta$User_Vars)) & (grepl('ODK Forms', meta$source) | meta$source==''), ]
    
    head <- getHead(c, t)
    body <- getBody(sel)
    foot <- getFoot(c, t, sel)
    
    file.create(paste0(c, '/', c, '-', t, '.Rmd'), overwrite=T)
    cat(head, body, foot, file=paste0(c, '/', c, '-', t, '.Rmd'), sep='')
  }
}
  