library(ybt)
library(RSQLite)

ff = tempfile()
db_init(ff)

stopifnot(file.exists(ff))

con = dbConnect(SQLite(), ff)
stopifnot(all(dbListTables(con) %in% c("chn", "deployments", "detections", "tags")))
