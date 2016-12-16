setwd('D://Documents and Settings/mcooper/GitHub/vs-data-tools/flagging/')

vd <- read.csv('view_defs.csv', stringsAsFactors = F)

#Remove 'curation__' from view names
vd$viewname <- gsub('curation__', replacement = '', vd$viewname)

#Remove 'WITH ... AS ( .. )' from beginning of view definition
vd$start <- 1
vd$start[vd$viewname!='weatherdata'] <- lapply(gregexpr('SELECT', vd$definition[vd$viewname!='weatherdata']), "[[", 2)
vd$definition <- substr(x = vd$definition, vd$start, nchar(vd$definition))

#split definitions by line
vd$definition <- strsplit(vd$definition, '\n')

#' Remove lines with 'max_eplot_severity',
#' remove the extra ( from FROM clause, 
#' remove comma from the line before the FROM
#' write to appropriate csv in folder view_templates
indices <- lapply(vd$definition, FUN = function(x, pattern){!grepl(x, pattern=pattern)}, pattern = '_seve')
for (i in 1:length(vd$definition)){
  lines <- vd$definition[i][[1]][indices[i][[1]]]
  if (vd$viewname[i]!='weatherdata'){
    lines <- gsub("FROM (", "FROM ", lines, fixed = T)
  }
  ind <- min(which(grepl("FROM", lines)))
  lines[ind-1] <- substr(lines[ind-1], 1, nchar(lines[ind-1])-1)
  lines <- gsub(';', '', lines)
  cat(x = paste0(paste0(lines, collapse='\n'), '\n'), file = paste0('view_templates/', vd$viewname[i], '.sql'))
}
