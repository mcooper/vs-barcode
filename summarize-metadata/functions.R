setwd("D:/Documents and Settings/mcooper/Documents/Staging Form and DD Updates/vitalsigns-data-apps/lib/forms/versions")

library(stringr)

f <- list.files()

code <- ''
for (i in f){
  size <- file.info(i)$size
  s <- readChar(i, size, useBytes = T)
  
  code <- paste0(code, s)
}

code <- gsub(c('\n|\r|\\}|\\}'), '', code)

gettable <- function(var, code){
  spaces <- gregexpr(' ', code)[[1]]
  funcs <- gregexpr('  def ', code)[[1]]
  varloc <- gregexpr(var, code)[[1]]
  if (length(varloc) > 1){
    varloc <- gregexpr(paste0(var, "\", "), code)[[1]]
  }
  start <- tail(funcs[funcs < varloc], n=1) + 6
  end <- spaces[spaces > (start + 2)][1] - 1
  substr(code,start,end)
}

gettable('mark1', code)
gettable('common', code)
gettable('moisture_tin_id', code)
gettable('start', code)


getdbname <- function(var, code){
  funcs <- gregexpr('  def ', code)[[1]]
  quote <- gregexpr('\'|\"', code)[[1]]
  dots <- gregexpr('\\.', code)[[1]]
  varloc <- gregexpr(var, code)[[1]]
  if (length(varloc) > 1){
    varloc <- gregexpr(paste0(var, "\", "), code)[[1]]
  }
  if (grepl('identity_mapping', substr(code, tail(funcs[funcs < varloc], n=1), varloc))){
    return(var)
  }
  if (grepl('=>', substr(code, varloc + nchar(var), varloc + nchar(var) + 3))){
    end <- quote[quote > varloc][3] - 1
    start <- tail(dots[dots < end], n=1) + 1
    return(substring(code, start, end))
  }
  # Need to figure out a way to deal with the JSON stuff!
}












