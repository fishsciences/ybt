#--------------------------------------------#
# append new rows to tables in toy.sqlite
#--------------------------------------------#
# set working directory to the most recent Google Drive Backup folder
library(RSQLite)
library(dplyr)
drv = SQLite()

# GoogleDriveBackup date
gdb_date <- "2020-03-26"

# vector of potential GoogleDriveBackup paths on different systems
# can grow this vector rather than breaking the path for different users
# also, using file.path rather than paste to make more portable across operating systems
potential_gdb_paths <- c(
  file.path("~", "Dropbox (Cramer Fish Sciences)", "NewPROJECTS", "AECCA-2018-YoloTelemetry", 
            "WORKING", paste0("GoogleDriveBackup", gdb_date)),
  file.path("~", "Dropbox (Cramer Fish Sciences)", "PROJECTS", "AECCA-2018-YoloTelemetry", 
            "WORKING", paste0("GoogleDriveBackup", gdb_date))
)

# check if any of potential_gdb_paths found; if so, set gdb_path
# this chunk of code makes more sense as a function, but I'm assuming that this is an exploratory repo
gdb_paths_exists <- sapply(potential_gdb_paths, dir.exists, USE.NAMES = FALSE)
if (sum(gdb_paths_exists) > 0){
  # use first matching path if multiple paths match (which would be unexpected, I think)
  gdb_path <- potential_gdb_paths[which(gdb_paths_exists == TRUE)[1]]
  message("Setting basetable_path to ", gdb_path)
} else {
  stop("No directory found. Locate directory on your system and add the directory to potential_dirs before proceeding.")
}

# dbConnect creates an empty database if not one found at location specified
# so we first want to check if the database exists at our gdb_path
db_path <- paste0(gdb_path, "/yb_database.sqlite")
if (file.exists(db_path)){
  db <- dbConnect(drv, db_path)
  message("Successfully connected to database.")
}else{
  stop("Unable to connect to database.")
}

#--------------------------------------------#
# beginnings of glimpse() functions for databases
tbls = dbListTables(db)

# thanks to dplyr/dbplyr, you can use glimpse data without loading full table into R
tbl(db, "detections") %>% glimpse()
# total rows are not known, though, because only examining a subset of the table

#--------------------------------------------#
# detections table:

#change for the year/file you're appending
detyear <- 2018
detyear_fldr <- paste0("YB_detyear", detyear, "_dc_dets")
dets_csv_path <- file.path(gdb_path, file.path("YB_SQL_BaseTables", "Detections", 
                                               detyear_fldr, paste0(detyear_fldr, ".csv")))

dets = read.csv(dets_csv_path, stringsAsFactors = FALSE) %>% 
  mutate(ID = paste(TagID, DateTimePST, Receiver, DateTimeUTC, CodeSpace, sep = " - ")) # create unique ID based on values in all 5 columns
str(dets)

# this approach to appending involves first filtering the detections table in the database
# based on dates in the dets dataframe
# that filtering should be reasonably fast because it happens in the database
# then bring that smaller, filtered dataset into R for comparison with dets
# then drop any of the rows in dets that are already found in db_dets
# and append the remaining dets to the database
db_dets <- tbl(db, "detections") %>% 
  filter(DateTimePST >= local(min(dets$DateTimePST, na.rm = TRUE)) & 
           DateTimePST <= local(max(dets$DateTimePST, na.rm = TRUE))) %>%
  mutate(ID = paste(TagID, DateTimePST, Receiver, DateTimeUTC, CodeSpace, sep = " - ")) %>% 
  collect()

dets_append <- dets %>% 
  filter(!(ID %in% db_dets$ID)) %>% 
  select(-ID)

# This piece of code shouldn't be necessary, but kept it here in case you still want it
# dets_raw <- dchk %>% 
#   group_by(TagID, Receiver) %>% 
#   filter(!duplicated(DateTimePST)) %>% 
#   ungroup()

# add new detections to detections table
if (nrow(dets_append) > 0){
  dbAppendTable(conn = db, 
                name = "detections", 
                value = dets_append)
} 
message("Appended ", nrow(dets_append), " rows to detections table in database.")

beepr::beep(0) # recommended if you're appending lots of detections

################## Travis stopped here when going over this code

# check years/date ranges that are included in the db so far:
dchk = tbl(db, "detections") %>%
  collect() 


dups_raw <- dchk %>% 
  group_by(TagID, Receiver) %>% 
  filter(duplicated(DateTimePST)) %>% 
  ungroup()

unique(dups_raw$Receiver)

dbListFields(db, "detections")
sapply(tbls, function(x) dbGetQuery(db, paste("SELECT COUNT(*) FROM" , x))) 

# after 2011: 201990 detections
# after 2012:  484898 
# after 2013: 846071
# 1340052 after 2014
# 1598332 after 2015
# 1799105 after 2016
# 2192328 after 2017
# 2389975 after 2018 

#--------------------------------------------#
# Deployments tabls - basically build from scratch each time, because it's all in one updated file:

d = as.data.frame(readxl::read_excel("YB_SQL_BaseTables/Deployments.xlsx"))

# format date/time columns as text
d[, c("DeploymentStart", "DeploymentEnd", "VRLDate")]  = apply(d[, c("DeploymentStart", "DeploymentEnd", "VRLDate")],
                                                               2,
                                                               as.character)
head(d)

# data checks
str(d)
unclass(d[, 1:8])
table(d$Station)

dbWriteTable(conn = db, 
             name = "deployments", 
             value = d, 
             overwrite = TRUE,
             field.types = c("Location" = "text", 
                             "StationAbbOld" = "text", 
                             "Station" = "text", 
                             "Receiver" = "integer", 
                             "DetectionYear" = "integer", 
                             "DeploymentStart" = "text", 
                             "DeploymentEnd" = "text", 
                             "VRLDate" = "text", 
                             "DeploymentNotes" = "text", 
                             "VRLNotes" = "text")
)


dbListTables(db)
dbListFields(db, "deployments")

#--------------------------------------------#
# Disconnect
dbDisconnect(db)
