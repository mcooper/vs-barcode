disp <- function(var, type, values=NA){
  #A function to take in a Vital Signs variable and display it.
  
  ##Type: date
  if (grepl('date', type)){
    #summary of all datas since ...
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
        kable("**This variable is entirely NULL**")
      }else{
        data$date <- ymd(data[ ,"', var, '"])
        
        if (sum(is.na(data$date)) == length(data$date)){
          kable("**This variable was not in a recognizeable date format**")
        } else{

            data$Year.Month <- floor_date(data$date, "month")
                  
            freq <- data %>% 
            group_by_("Year.Month", gp_var) %>%
            summarize(Records=n())
            
            freqj <- data.frame(Year.Month=seq(min(freq$Year.Month, na.rm=T), max(freq$Year.Month, na.rm=T), by="month"))
            
            freq <- merge(freq, freqj, all.y=T)
            freq$Records[is.na(freq$Records)] <- 0
            
            print(
              ggplot(freq) + geom_bar(aes_string("Year.Month", "Records", fill=gp_var), stat="identity")+ 
              xlab("Year and Month") + scale_x_date(expand=c(0,0))
            )

            nullsd <- count_nulls(data, "', var, '", gp_var)
            kable(nullsd[[1]], col.names=nullsd[[2]])  
        }
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

                      data$Hour <- hms(data[ , "', var, '"]) %>% hour()

                      freq <- data %>% 
                        group_by_("Hour", gp_var) %>%
                        summarize(Records=n())
                      
                      print(
                        ggplot(freq) + geom_bar(aes_string("Hour", "Records", fill=gp_var), stat="identity")+ 
                        xlab("Hour of Day")
                      ) 

                    nullsd <- count_nulls(data, "', var, '", gp_var)
                    kable(nullsd[[1]], col.names=nullsd[[2]])  
                  
                  }')
    return(out)
  }
  
  ##Type: text, string
  else if (grepl('text|string', type)){
    #summarize all received strings, with count, cols for each gp_var, and a total col
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
                  kable("**This variable is entirely NULL**")
      }else if(nrow(data[ , c("', var, '", gp_var)]) < 15){
        kable(table(data[ , c("', var, '", gp_var)]))
      }else{
        DT::datatable(as.data.frame.matrix(table(data[ , c("', var, '", gp_var)])))       
      }')
    return(out)
  }
  
  ##Type: select
  else if (grepl('select', type)){
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
        kable("**This variable is entirely NULL**")
      }else if(is.logical(data[ , "', var, '"])){
      
      print(

      ggplot(data) +
          geom_bar(aes_string("', var, '", fill=gp_var), position=\'stack\') +
                  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + 
                  xlab("', var, '")
      )

      nullsd <- count_nulls(data, "', var, '", gp_var)

      kable(nullsd[[1]], col.names=nullsd[[2]])

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
      geom_histogram(binwidth=signif(((max(data[ , "', var, '"], na.rm=T)-min(data[ , "', var, '"], na.rm=T))+1)/50, 2))

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
        
        if(nrow(data[!is.na(data$', var, '), ]) > 200){
        
        print(

        ggplot(data, aes_string(x="', var, '", fill=gp_var)) +
        geom_histogram()

        )
        
        nullsd <- count_nulls(data, "', var, '", gp_var)
        outsd <- count_outliers(data, "', var, '", gp_var)
        
        kable(nullsd[[1]], col.names=nullsd[[2]])
        kable(outsd[[1]], col.names=outsd[[2]])

        }else{
        
        print(

        ggplot(data, aes_string(x="', var, '", fill=gp_var)) +
        geom_histogram(binwidth=1)

        )
        
        nullsd <- count_nulls(data, "', var, '", gp_var)
        outsd <- count_outliers(data, "', var, '", gp_var)
        
        kable(nullsd[[1]], col.names=nullsd[[2]])
        kable(outsd[[1]], col.names=outsd[[2]])
      }
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
  
  else if (grepl('plant_species', type)){
    out <- paste0('
      if (sum(is.na(data[, "', var, '"])) == length(data[, "', var, '"])){
                  kable("**This variable is entirely NULL**")
      }else if (!(grepl("Genus|genus", "', var, '"))){
                  kable("**This is documented in the genus variable**")
      }else{
        DT::datatable(as.data.frame.matrix(table(data[ , c("', var, '", gp_var)])))
      }
          
  ')
    return(out)
  }
  
  else{
    cat('Variable:', var, 'Type:', type, ' is not a recognized variable type\n')
  }
  
}