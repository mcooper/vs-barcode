disp <- function(var, type, values=NA){
  #A function to take in a Vital Signs variable and display it.
  
  ##Type: date
  if (grepl('date', type)){
    #summary of all datas since ...
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
        kable("**This variable is entirely NULL**")
      }else{

      }')
    return(out)
  }
  
  ##Type: text, string
  else if (grepl('text|string', type)){
    #summarize all received strings, with count, cols for each gp_var, and a total col
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
                  kable("**This variable is entirely NULL**")
      }else{
        kable(table(data[ , c("', var, '", gp_var)]))
      }')
    return(out)
  }
  
  ##Type: time
  else if (grepl('time', type)){
    #summary of times
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
                  kable("**This variable is entirely NULL**")
        }else{
                      
        }')
    return(out)
  }
  
  ##Type: select
  else if (grepl('select', type)){
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
        kable("**This variable is entirely NULL**")
      }else{
      data$recoded <- recode(data[ , "', var, '"], ', recodeString(values), ')

      print(
      
      ggplot(data) +
          geom_bar(aes_string("recoded", fill=gp_var), position=\'stack\') +
                  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + 
                  xlab("', var, '")

      )

      nullsd <- count_nulls(data, "', var, '", gp_var)

      kable(nullsd[[1]], col.names=nullsd[[2]])}
    ')
    return(out)
  }
  
  ##Type: decimal
  else if (grepl('decimal', type)){
    #Outsd calculates sd based on global rates, so landsacpe level calculations can be off.
    
    out <- paste0(
      '
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
        kable("**This variable is entirely NULL**")
      }else{

      print(

      ggplot(data, aes_string(x="', var, '", fill=gp_var)) +
      geom_histogram(binwidth=signif((max(data[ , "', var, '"], na.rm=T)-min(data[ , "', var, '"], na.rm=T))/50, 2))

      )
      
      nullsd <- count_nulls(data, "', var, '", gp_var)
      outsd <- count_outliers(data, "', var, '", gp_var)
      
      kable(nullsd[[1]], col.names=nullsd[[2]])
      kable(outsd[[1]], col.names=outsd[[2]])
      }')
    return(out)
  }
  
  ##Type: int
  else if (grepl('int', type)){
    out <- paste0(
      '
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
        kable("**This variable is entirely NULL**")
      }else{
        data[ , "', var, '"] <- as.numeric(data[ , "', var, '"])
        
        print(

        ggplot(data, aes_string(x="', var, '", fill=gp_var)) +
        geom_histogram(binwidth=1)

        )
        
        nullsd <- count_nulls(data, "', var, '", gp_var)
        outsd <- count_outliers(data, "', var, '", gp_var)
        
        kable(nullsd[[1]], col.names=nullsd[[2]])
        kable(outsd[[1]], col.names=outsd[[2]])
      }')
    return(out)
  }
  
  ##Type: audio
  else if (grepl('audio', type)){
    #count of audio files received
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
                  kable("**This variable is entirely NULL**")
      }else{
                  nullsd <- count_nulls(data, "', var, '", gp_var)
                  kable(nullsd[[1]], col.names=nullsd[[2]])         
      }')
    return(out)
  }
  
  ##Type: barcode
  else if (grepl('barcode', type)){
    #count of barcodes received
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
                  kable("**This variable is entirely NULL**")
      }else{
                  nullsd <- count_nulls(data, "', var, '", gp_var)
                  kable(nullsd[[1]], col.names=nullsd[[2]])     
      }')
    return(out)
  }
  
  ##image:
  else if (grepl('image', type)){
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
                  kable("**This variable is entirely NULL**")
      }else{
                  nullsd <- count_nulls(data, "', var, '", gp_var)
                  kable(nullsd[[1]], col.names=nullsd[[2]])         
      }')
    return(out)
  }
  
  else{
    cat('Variable:', var, 'Type:', type, ' is not a recognized variable type\n')
  }
  
}