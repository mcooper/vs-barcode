library(knitr)
library(rmarkdown)

setwd('D:/Documents and Settings/mcooper/Documents/Automate Data Dictionaries/RMD_Outputs/')

ALL <- list.files('ALL', pattern='.Rmd')
GHA <- list.files('GHA', pattern='.Rmd')
RWA <- list.files('RWA', pattern='.Rmd')
TZA <- list.files('TZA', pattern='.Rmd')
UGA <- list.files('UGA', pattern='.Rmd')

setwd('D:/Documents and Settings/mcooper/Documents/Automate Data Dictionaries/RMD_Outputs/ALL')
for (i in ALL){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){print(e)})
}

setwd('../GHA')
for (i in GHA){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){print(e)})
}


setwd('../RWA')
for (i in RWA){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
  error=function(e){print(e)})
}

setwd('../TZA')
for (i in TZA){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){print(e)})
}

setwd('../UGA')
for (i in UGA){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){print(e)})
}

