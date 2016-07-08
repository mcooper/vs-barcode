##This script defintes a function that finds synonyms for plant names on www.theplantlist.org
##It takes as species name as an argument, and returns either the name itself, the accepted
##name for which the species name given is a synonym, 'DNE' if the given plant name does not 
##exist in the database, or 'Unresolved' if the plant name is currently in dispute.  Plant names
##should first be cleaned by TNRS, and both Genus and species should be given.

##Created by Matt Cooper, 1/29/2016

library(rvest)

getsyns <- function(plantname){
  print(plantname)
  if(!grepl(pattern=' ', plantname)){
    warning('Plant name ', plantname, ' has no space, and will be treated as just a Genus.  This will likely give erroneous results.')
  }
  name <- gsub(pattern=' ', replacement='+', plantname)
  url <- paste0('http://www.theplantlist.org/tpl1.1/search?q=',name)
  out <- html_text(read_html(url))
  if(grepl('The results are below',out)){  #Its a match, with multiple possible cases
    if(grepl('Accepted',out)){
      startind <- gregexpr('\\t',out)[[1]][gregexpr('\\t',out)[[1]] < gregexpr('Accepted',out)[[1]][1]-3]
      start <- startind[length(startind)]+1
    }else if(!grepl('Accepted',out)&grepl('Unresolved',out)&grepl('Synonym',out)){
      startind <- gregexpr('\\t',out)[[1]][gregexpr('\\t',out)[[1]] < gregexpr('Synonym',out)[[1]][1]-3]
      start <- startind[length(startind)]+1      
    }
    else{
      start <- gregexpr('Date supplied',out)[[1]][1] + 27
    }
    finish <- gregexpr('\\n|\\[',out)[[1]][gregexpr('\\n|\\[',out)[[1]] > start][1]
    suppressMessages(link <- follow_link(html_session(url), i=substr(out, start, finish-2)))
    out <- html_text(read_html(link$url))
    if(grepl('This name is a synonym of ',out)){  #Its a one-to-one, an a synonym of an accepted name
      start <- gregexpr('is a synonym of ',out)[[1]][1] + 16
      finish <- gregexpr(' |\\.',out)[[1]][gregexpr(' |\\.',out)[[1]] > start][2]
      return(substr(out, start, finish-1)) #accepted name
    }
    if(grepl('name of a species in the genus',out)){  #Its one-to-one match, and an accepted name
      return(substr(out,8,gregexpr(' ',out)[[1]][2]-1))
    }
    if(grepl('this name either as an accepted name or as a synonym with original publication details', out)){  #So apparently there are 'unresolved' names
      return('Unresolved')
    }
    stop('Followed a bad link on ', url)
  }
  if(grepl('name of a species in the genus',out)){  #Its one-to-one match, and an accepted name
    return(plantname)
  }
  if(grepl('This name is a synonym of ',out)){  #Its a one-to-one, an a synonym of an accepted name
    start <- gregexpr('is a synonym of ',out)[[1]][1] + 16
    finish <- gregexpr(' |\\.',out)[[1]][gregexpr(' |\\.',out)[[1]] > start][2]
    return(substr(out, start, finish-1)) #accepted name
  }
  if(grepl('No plant name records match your search criteria', out)){  #Its not a match, flag it an go back to TNRS
    return('DNE')
  }
  if(grepl('this name either as an accepted name or as a synonym', out)){  #So apparently there are 'unresolved' names
    return('Unresolved')
  }
  warning('Didn\'t get any meaningful results from ', url)
  return('DNE')
}