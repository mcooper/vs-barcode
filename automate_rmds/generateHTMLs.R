library(knitr)
library(rmarkdown)

All <- list.files('ALL')
GHA <- list.files('GHA')
RWA <- list.files('RWA')
TZA <- list.files('TZA')
UGA <- list.files('UGA')

setwd('D:/Documents and Settings/mcooper/Documents/Automate Data Dictionaries/RMD_Outputs/ALL')
for (i in All){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){})
}

setwd('../GHA')
for (i in All){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){})
}


setwd('../RWA')
for (i in All){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){})
}

setwd('../TZA')
for (i in All){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){})
}

setwd('../UGA')
for (i in All){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){})
}

