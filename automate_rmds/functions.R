recodeString <- function(values){
  #Ad-Hoc coding of 71 = bananas
  #71 used to be bananas but we got rid of that category
  if (grepl("300: 'Green Tomato'", values)){
    values <- paste0(values, ", 71: 'Bananas'")
  }
  
  t <- gsub(': ', '=', values)
  t <- gsub('\\{|\\}', '', t)
  
  #Add ticks to numbers
  nums <- '1|2|3|4|5|6|7|8|9|0'
  if (grepl(nums, substr(t,1,1))){
    t <- paste0('`', t)
  }
  for (i in rev(gregexpr('=', t)[[1]])){
    if (!grepl('\'|"|`', substr(t, i-1, i-1))){
      t <- paste0(substr(t,1,i-1), '`', substr(t,i,nchar(t)))
    }
  }
  for (i in rev(gregexpr(', ', t)[[1]])){
    if (!(grepl('\'|"|`', substr(t, i+2, i+2)))){
      t <- paste0(substr(t,1,i+1), '`', substr(t,i+2,nchar(t)))
    }
  }
  t
}


handleDuplicates <- function(df){
  #create columns indexing all duplicate groups
  df$id <- seq(1,nrow(df))
  
  df$u <- paste0(df$User_Vars, df$User_Tables)
  tab <- table(df$u)
  tab <- tab[tab > 1]
  newdf <- data.frame(u=names(tab), group=seq(1,length(tab)))
  df <- merge(df, newdf, all.x=T)
  df$u <- NULL
  df$group[is.na(df$group)] <- 0
  
  for (g in unique(df$group[df$group > 0])){
    sel <- df[which(df$group==g), ]
    
    #lat longs should not be selects and should be type 'decimal'
    if ((sum(grepl('latitude', sel$User_Vars))>0 | sum(grepl('longitude', sel$User_Vars))>0) & (sum(grepl('select', sel$type))>0 & sum(!grepl('select', sel$type))>0)){
      df <- df[!(grepl('select', df$type) & df$group==g), ]
    }
    #give priority to ones where label is not blank
    else if (sum(sel$label=='')>0 & sum(sel$label!='')>0){
      df <- df[!(df$label=='' & df$group==g), ]
    }
    #give priority to select data types
    else if (sum(grepl('select', sel$type))>0 & sum(!grepl('select', sel$type))>0){
      df <- df[!(df$group==g & !grepl('select', df$type)), ]
    }
    #Then prioritize those that are NOT calculate types
    else if (sum(grepl('calculate', sel$type))>0 & sum(!grepl('calculate', sel$type))>0){
      df <- df[!(df$group==g & grepl('calculate', df$type)), ]
    }
    #Then give priority to barcode types
    else if (sum(grepl('barcode', sel$type))>0 & sum(!grepl('barcode', sel$type))>0){
      df <- df[!(df$group==g & !grepl('barcode', df$type)), ]
    }
  }
  
  #For remaining duplicates, just take the first row
  df <- df[!duplicated(df[ , c('User_Tables', 'User_Vars')]), ]
  
  df <- df[order(df$id), ]
  df$id <- NULL
  
  df
}


get_gp_var <- function(country){
  if (country %in% c('GHA', 'TZA', 'RWA', 'UGA')){
    gp_var <- 'Landscape..'
    data <- filter(data, Country==country)
  }
  else if (country == 'ALL'){
    gp_var <- 'Country'    
  }
  else{
    cat('Unrecognized argument for country')
  }
  gp_var
}

pretty_percent <- function(vec, rnd=1){
  paste0(round(vec*100,rnd), '%')
}
  
#Other functions
count_nulls <- function(data, var, gp_var){
  data$nas <- is.na(data[ , var])
  
  tab <- group_by_(data, gp_var) %>% 
    summarize(Total = n(),
              Filled = mean(!nas),
              Empty = mean(nas)) %>% 
    data.frame
  
  all <- data.frame(groupvar = 'Total', 
                    Total = length(data$nas),
                    Filled = mean(!data$nas),
                    Empty = mean(data$nas)) %>% 
    data.frame
  
  names(tab)[1] <- 'groupvar'
  out <- bind_rows(tab, all)
  names(out)[1] <- gp_var
  
  out$Filled <- pretty_percent(out$Filled)
  out$Empty <- pretty_percent(out$Empty)
  
  list(data=out, colnames=gsub('.', ' ', names(out), fixed = T))
}

getSdCount <- function(var, sds){
  mean(((median(var) + sds*sd(var)) < var) | ((median(var) - sds*sd(var)) > var))
}

#Number >2,3,4 stdev
count_outliers <- function(data, var, gp_var){
  data <- data[!is.na(data[, var]), ]
  data$target <- data[, var]
  
  tab <- group_by_(data, gp_var) %>% 
    summarize(Total = n(),
              Outside.Two.Standard.Deviations = getSdCount(target, 2),
              Outside.Three.Standard.Deviations = getSdCount(target, 3),
              Outside.Four.Standard.Deviations = getSdCount(target, 4),
              Outside.Five.Standard.Deviations = getSdCount(target, 5)) %>%
    data.frame
  
  all <- data.frame(groupvar = 'Total',
                    Total = length(data$target),
                    Outside.Two.Standard.Deviations = getSdCount(data$target, 2),
                    Outside.Three.Standard.Deviations = getSdCount(data$target, 3),
                    Outside.Four.Standard.Deviations = getSdCount(data$target, 4),
                    Outside.Five.Standard.Deviations = getSdCount(data$target, 5))

  names(tab)[1] <- 'groupvar'
  out <- bind_rows(tab, all)
  names(out)[1] <- gp_var

  out$Outside.Two.Standard.Deviations <- pretty_percent(out$Outside.Two.Standard.Deviations)
  out$Outside.Three.Standard.Deviations <- pretty_percent(out$Outside.Three.Standard.Deviations)
  out$Outside.Four.Standard.Deviations <- pretty_percent(out$Outside.Four.Standard.Deviations)
  out$Outside.Five.Standard.Deviations <- pretty_percent(out$Outside.Five.Standard.Deviations)
    
  list(data=out, colnames=gsub('.', ' ', names(out), fixed = T))
}

getFlags <- function(data){
  flags <- data[, 'flag'] %>% sapply(FUN=str_split, pattern = "; ")
  names(flags) <- NULL
  flags <- unlist(flags)
  flags <- flags[flags != '']
  flags
}

tableFlags <- function(flags, var){
  tab <- flags[grepl(var, flags, fixed=TRUE)] %>% table()
  df <- data.frame(Flag=names(tab), Count=as.numeric(tab))
  df
}

