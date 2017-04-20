#On the EC2 instance, run:
#mongoexport --db formhub --collection instances --out export.json

#It also looks like odk_logger_instance in the formhub postgres database has the data as well

fileName <- 'export.json'
con=file(fileName,open="r")
line=readLines(con) 

library(jsonlite)

out <- fromJSON(line[sample(1:12345, 1)])
length(out)
out["_xform_id_string"]