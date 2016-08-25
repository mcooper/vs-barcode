library(RCurl)
library(jsonlite)
library(stringdist)
library(stringr)
library(plyr)

Preprocessing <- function(df){
  #Takes a data frame with a genus and species column, returns cleaned version
  genus <- df$genus
  species <- df$species
  capwords <- function(s, strict = FALSE) {
    cap <- function(s) paste(toupper(substring(s, 1, 1)),
                             {s <- substring(s, 2); if(strict) tolower(s) else s},
                             sep = "", collapse = " " )
    sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
  }
  df$genus <- capwords(gsub("[^[:alnum:]]", "", genus))
  df$species <- tolower(gsub("[^[:alnum:]]", "", species))
  return(df)
}

TNRSQuery <- function(df, N_Plants=10){
  Plant_Names <- unique(df[,c('id', 'genus', 'species')])

  a <- seq(1,nrow(Plant_Names)-1,N_Plants)
  z <- seq(N_Plants,nrow(Plant_Names),N_Plants)

  if(nrow(Plant_Names) %% N_Plants != 0){
    z <- c(z, nrow(Plant_Names))
  }

  Plant_Names[ , c('genus', 'species')] <- Preprocessing(Plant_Names[ , c('genus', 'species')])

  all_results <- data.frame()
  failed <- data.frame()
  for(i in 1:length(a)){
    sel <- Plant_Names[a[i]:z[i],]
    URL <- paste0('http://tnrs.iplantc.org/tnrsm-svc/matchNames?retrieve=best&names=',
           paste(paste(sel$genus, sel$species, sep="%20"),collapse=','))
    tryCatch({out <- fromJSON(getURL(URL))$items
                out$original <- paste(sel$genus, sel$species, sep=' ')
                out$id <- sel$id
                out$distance <- 1-stringdist(out$original, out$nameScientific, method='jw')
                all_results <- rbind.fill(all_results, out)},
              error=function(e){
                failed <- rbind.fill(failed, data.frame(list(error=e, id=sel$id, genus=sel$genus, species=sel$species)))}
                )
    cat('\n', z[i]/max(z)*100, ' percent done')
  }
  
  all_results$distance <- 1-stringdist(all_results$nameSubmitted, all_results$nameScientific, method='jw')
  
  return(list(all_results, failed))
}

plant_names <- read.csv('plant_species.csv')

results <- TNRSQuery(plant_names)

all_results <- results[[1]]
failed <- results[[2]]

write.csv(all_results, 'ProcessedNames.csv', row.names=F)

