library(knitr)
library(rmarkdown)

setwd('D:/Documents and Settings/mcooper/Documents/Automate Data Dictionaries/RMD_Outputs/')

###################
#Do for all RMDs
###################

RMDs <- list.files(recursive=TRUE, pattern='Rmd')

for (i in RMDs){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){print(e)})
}


#######################################
#Do for RMDs that failed the first time
#######################################

HTMLs <- list.files(recursive=TRUE, pattern='html')

RMDsel <- RMDs[!substr(RMDs, 1, nchar(RMDs)-4) %in% substr(HTMLs, 1, nchar(HTMLs) - 5)]

for (i in RMDsel){
  tryCatch({
    rmarkdown::render(paste0(getwd(),'/',i), output_format='html_document')},
    error=function(e){print(e)})
}