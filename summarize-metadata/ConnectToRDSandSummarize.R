library(RPostgreSQL)
library(plyr)

drv <- dbDriver("PostgreSQL")

source('connection.R')

#To get the proper host, I had to look around with: netstat -a -o until I found the port I had created.
con <- dbConnect(drv, dbname = dbname, host=host, port = port, user=user, password=password)

tabs_cols <- dbGetQuery(con, 'SELECT * FROM information_schema.columns WHERE table_schema = \'public\'')

out <- data.frame()
for (i in 1:nrow(tabs_cols)){
  t <- tabs_cols$table_name[i]
  c <- tabs_cols$column_name[i]
  q <- paste0('select cast(sum(case when "', c, '" is null then 1 else 0 end) AS float)/count(*) AS percent_null from "', t, '"')
  res <- dbGetQuery(con, q)
  out <- rbind.fill(out,data.frame(table=t, column=c, percent_null=res))
  print(paste0('Table ', t, ' and Column ', c, ' is donezo!'))
}

write.csv(out, "D:/Documents and Settings/mcooper/Documents/Staging Form and DD Updates/RDS_Nulls_summary.csv", row.names=F)

#Other summary stats to get - min, max, mean, quartiles, random, 