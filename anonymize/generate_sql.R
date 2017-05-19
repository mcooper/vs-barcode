setwd('D://Documents and Settings/mcooper/GitHub/vs-data-tools/anonymize/')

pii <- read.csv('pii fields.csv', stringsAsFactors = F)

str <- ''

for (i in unique(pii$table)){
  str <- paste0(str, '--', i, '\n')
  
  namesel <- pii[pii$table == i & pii$type == 'personal', ]
  geosel <- pii[pii$table == i & pii$type == 'spatial', ]
  
  if(nrow(namesel) > 0){
    #Create New Table
    str <- paste0(str, 'CREATE TABLE ', i, '_piiname\n(uuid text PRIMARY KEY,\n', 
                  paste0(paste(namesel$var, namesel$coltype), collapse=',\n'), 
                  ',\nFOREIGN KEY(uuid) REFERENCES ', i, '(uuid));\n\n')
    
    #Insert into New Table
    str <- paste0(str, 'INSERT INTO ', i, '_piiname\n(SELECT uuid, ', 
                  paste(namesel$var, collapse=', '), '\nFROM ', i, ');\n\n')
    
    #Drop columns from old table
    str <- paste0(str, 'ALTER TABLE ', i, '\n', 
                  paste0(paste('DROP COLUMN', namesel$var, 'CASCADE'), collapse=',\n'),
                  ';\n\n')
  }
  
  if(nrow(geosel) > 0){
    #Create New Table
    str <- paste0(str, 'CREATE TABLE ', i, '_piigeo\n(uuid text PRIMARY KEY,\n', 
                  paste0(paste(geosel$var, geosel$coltype), collapse=',\n'), 
                  ',\nFOREIGN KEY(uuid) REFERENCES ', i, '(uuid));\n\n')
    
    #Insert into New Table
    str <- paste0(str, 'INSERT INTO ', i, '_piigeo\n(SELECT uuid, ', 
                  paste(geosel$var, collapse=', '), '\nFROM ', i, ');\n\n')
    
    #Drop columns from old table
    str <- paste0(str, 'ALTER TABLE ', i, '\n', 
                  paste0(paste('DROP COLUMN', geosel$var, 'CASCADE'), collapse=',\n'),
                  ';\n\n')
  }
}
  
cat(str, file='pii_to_tables.sql')

