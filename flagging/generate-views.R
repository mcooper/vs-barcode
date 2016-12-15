setwd('D://Documents and Settings/mcooper/GitHub/vs-data-tools/flagging/')

table <- read.csv('flag-rules.csv', stringsAsFactors = T)

for (i in unique(table$table)){
  sel <- table[table$table==i, ]
  str <- ''
  f <- 1
  for (j in 1:nrow(sel)){
    if (!is.na(sel$allmax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$allmax[j], " THEN '", sel$var[j], " is greater than ", sel$allmax[j], "; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }
    if (!is.na(sel$allmin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$allmin[j], " THEN '", sel$var[j], " is ", sel$allmin[j], " or less; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }    
    if (!is.na(sel$ghamax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$ghamax[j], " AND hh.country = 'GHA' THEN '", sel$var[j], " is greater than ", sel$ghamax[j], " in Ghana; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }
    if (!is.na(sel$ghamin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$ghamin[j], " AND hh.country = 'GHA' THEN '", sel$var[j], " is ", sel$ghamin[j], " or less in Ghana; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }    
    if (!is.na(sel$tzamax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$tzamax[j], " AND hh.country = 'TZA' THEN '", sel$var[j], " is greater than ", sel$tzamax[j], " in Tanzania; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }
    if (!is.na(sel$tzamin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$tzamin[j], " AND hh.country = 'TZA' THEN '", sel$var[j], " is ", sel$tzamin[j], " or less in Tanzania; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }    
    if (!is.na(sel$rwamax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$rwamax[j], " AND hh.country = 'RWA' THEN '", sel$var[j], " is greater than ", sel$rwamax[j], " in Rwanda; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }
    if (!is.na(sel$rwamin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$rwamin[j], " AND hh.country = 'RWA' THEN '", sel$var[j], " is ", sel$rwamin[j], " or less in Rwanda; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }    
    if (!is.na(sel$ugamax[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " > ", sel$ugamax[j], " AND hh.country = 'UGA' THEN '", sel$var[j], " is greater than ", sel$ugamax[j], " in Uganda; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }
    if (!is.na(sel$ugamin[j])){
      str <- paste0(str, "CASE WHEN ", sel$var[j], " <= ", sel$ugamin[j], " AND hh.country = 'UGA' THEN '", sel$var[j], " is ", sel$ugamin[j], " or less in Uganda; ' ELSE '' END AS flag", f, ",\n")
      f <- f + 1
    }
  }
  cat(str)
  cat(paste0('flag', paste0(seq(1,f-1), collapse=' || flag'), ' AS "Flag"\nFROM'))
}










