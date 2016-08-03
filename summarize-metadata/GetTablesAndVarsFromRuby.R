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

funcs <- gregexpr('  def ', code)[[1]]

spaces <- gregexpr(' ', code)[[1]]

getfuncs <- function(func, spaces, code){
  end <- spaces[spaces > (func + 7)][1] - 1
  start <- func + 6
  return(list(substr(code, start, end), start))
}

allfuncs <- sapply(funcs, FUN=getfuncs, spaces=spaces, code=code)

tablefuncs <- allfuncs[,allfuncs[1,] != 'models' & !grepl('__|row|object|muxmap', allfuncs[1,])]

getvarsbyfunction <- function(func, ind, code){
  end <- gregexpr('  def ', code)[[1]][gregexpr('  def ', code)[[1]] > ind][1]
  subset <- substr(code, ind, end)
  vardb <- NULL
  varodk <- NULL
  if (grepl('identity_mapping', subset)){
    start <- gregexpr('%w', subset)[[1]] + 3
    end <- gregexpr(')', subset)[[1]][gregexpr(')', subset)[[1]] > start][1] - 1
    vars <- substr(subset, start, end)[[1]]
    vardb <- strsplit(vars, ' ')[[1]][strsplit(vars, ' ')[[1]] != '']
    varodk <- vardb
  }
  
  
alltabledata <- read.csv("D:/Documents and Settings/mcooper/Documents/Staging Form and DD Updates/DB Tables and Columsn.csv")
tables <- unique(alltabledata$table_name)

tables[!as.character(tables) %in% unlist(tablefuncs[1,])]












