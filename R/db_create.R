##' Initialize an empty database
##'
##' This function initialized a database according to a schema. This
##' is done so that contraints on the data fields, including keys, can
##' be specified. Once initialized, the database can be populated
##' while ensuring that the data meet the constraints.
##' @title Initialize a database
##' @param db_file string, the full path and name of the database file
##'     to be initialize.
##' @param driver A SQLite driver
##' @param con A connection to an empty database. If the database does
##'     not exist, it will be created.
##' @param schema string, a SQLite command to create the database
##' @param schema_file a file with SQLite code specifying the schema
##'     for the database.
##' @return NULL
##' @author Matt Espe
##' @export
db_init = function(db_file, driver = SQLite(),
                   con = dbConnect(driver, db_file),
                   schema = strsplit(paste(readLines(schema_file),
                                           collapse = " "), ";")[[1]],
                   schema_file = system.file("create_db.sql", package = "ybt"))
{
    on.exit(dbDisconnect(con))
    
    if(length(dbListTables(con)))
        stop("Database file ", db_file, "is not empty. Did you mean to call db_populate()?")

    invisible(sapply(schema, function(x) dbExecute(con, x)))
           
    return(invisible(NULL))
}




if(FALSE){
##-------------------------------------------------------#
# Database set up - only do once.  Appending/adding to the database is done in the append_ scripts.
# M. Johnston
# Last done: # Fri Aug 16 14:31:30 2019 ------------------------------
#--------------------------------------------#

#install.packages(c("dbplyr", "RSQLite")) # requires RSQLite >= 2.1.1
library(RSQLite)
library(dplyr)
library(readxl)
#--------------------------------------------#
# create database - don't run the first two commented-out lines unless you want to build everything from scratch
db_file <- "yb_database.sqlite" # placed in the working directory
src_sqlite(db_file, create = TRUE)

db <- dbConnect(RSQLite::SQLite(), "yb_database.sqlite")
db
#--------------------------------------------#
dbListTables(db) # should be empty if you just built from scratch; otherwise, should have base tables
#--------------------------------------------#
# Base Tables - sourced from google drive YB_SQL_BaseTables directory, change relative path as nec; 
basetable_path = "~/Dropbox (Cramer Fish Sciences)/NewPROJECTS/AECCA-2018-YoloTelemetry/WORKING/GoogleDriveBackup20190723/YB_SQL_BaseTables/"

# tags table
tags = as.data.frame(read_excel(path = paste0(basetable_path,"Tags/Tags.xlsx"), na = c("NA", "na", "")))

# data checks
stopifnot(sum(is.na(tags$TagID))==0)
unique(tags$TagLoc) %in% c("ALIS", "BLIS", "BRSTR", "FYKE", "WW") # check for weird locations
stopifnot(length(unique(tags$Sp)) == 2)
head(tags)
range(tags$DateTagged)
range(tags$FishID)
str(tags)
tags$DateTagged = as.character(tags$DateTagged)
table(tags$CodeSpace)

dbWriteTable(conn = db, 
             name = "tags", 
             value = tags, 
             overwrite = TRUE)

dbListTables(db)
dbListFields(db, "tags")

#-------------------------------------------------------#
# detections table
#-------------------------------------------------------#
# baseline: detyear2011 detections
det = read.csv(file = paste0(basetable_path, "Detections/YB_detyear2011_dc_dets/YB_detyear2011_dc_dets.csv"), stringsAsFactors = FALSE)
str(det)


dbWriteTable(conn = db, 
             name = "detections", 
             value = det, 
             overwrite = TRUE)

dbListTables(db)
dbListFields(db, "detections")

#--------------------------------------------#
# load and format the data that will make the deployments table:
#--------------------------------------------#
d = as.data.frame(read_excel(paste0(basetable_path, "Deployments.xlsx"), na = c("NA", "na", "")))

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
chn <- read_excel( paste0(basetable_path, "Tags/Chinook.xlsx"), na = c("NA", "na", "")) %>% 
  mutate(DateTagged = as.character(DateTagged),
         TOC = as.character(hms::as_hms(TOC)),
         SurgStart = as.character(hms::as_hms(SurgStart)),
         SurgEnd = as.character(hms::as_hms(SurgEnd)),
         TOR = as.character(hms::as_hms(TOR)))
str(chn)

#data checks
table(chn$TagLoc)
unclass(chn)
table(chn$Tide)
table(chn$Sex)
colSums(is.na(chn))

dbWriteTable(conn = db, 
             name = "chn", 
             value = chn, 
             overwrite = TRUE,
             field.types = c(
               "DateTagged" = "text",
               "TagLoc" = "text",
               "TagID" = "integer",
               "TagSN" = "integer",
               "CodeSpace" = "integer",
               "Floy" = "text",
               "GeneticAssignment" = "text",
               "TOC" = "text",
               "FL" = "integer",
               "TL" = "integer",
               "CO2" = "numeric",
               "SurgStart" = "text",
               "SurgEnd" = "text",
               "Recov" = "numeric",
               "Adipose" = "text",
               "Sex" = "text",
               "TOR" = "text",
               "Bleeding" = "numeric",
               "Comments" = "text",
               "Surgeon" = "text",
               "RecovDO" = "numeric",
               "RecovTemp" = "numeric",
               "TDTemp" = "numeric",
               "TDDO" = "numeric",
               "TailGrab" = "numeric",
               "BodyFlex" = "numeric",
               "HeadComplex" = "numeric",
               "VOR" = "numeric",
               "Orientation" = "numeric",
               "Tide" = "text"
             )
)

dbListTables(db)
dbListFields(db, "chn")

# Disconnect
dbDisconnect(db)
}
