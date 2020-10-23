# Create and append ybt sqlite database
# M. Johnston
# Tue Oct 20 10:31:10 2020 ------------------------------

library(ybt)
library(RSQLite) 
source("R/utils.R")

# database filepath
db_fp = "~/DropboxCFS/NewPROJECTS/AECCA-2018-YoloTelemetry/DELIVERABLES/Database/ybt_database.sqlite" 

# initialize database - uncomment after deleting old db if rebuilding from scratch
#ybt::db_init(db_fp)

# test schema
con = dbConnect(RSQLite::SQLite(), db_fp)
dbListTables(con)
dbDisconnect(con)

#-------------------------------------------------------#
# DETECTIONS
#-------------------------------------------------------#
# copy all drift-corrected csvs to a folder; these are the flat files that make up the entire database.
copy_vrls(dir = "~/DropboxCFS/NewPROJECTS/AECCA-2018-YoloTelemetry/WORKING/YB_Vemco/",
          dest = "data_raw/all_csvs/",
                     file_regex = "_dc",
                     file_type = "csv",
                     regex_exclude = FALSE
                    )

# copy only the non-FDA files to a dc folder; hacky but it works
copy_vrls(dir = "data_raw/all_csvs/",
          dest = "data_raw/dc_csvs/",
          file_regex = "FDA",
          file_type = "csv",
          regex_exclude = TRUE)

# apply format_VUE_csv to all files; bind rows
dfiles = list.files("data_raw/dc_csvs", 
                    full.names = TRUE, 
                    recursive = FALSE)

dd = do.call(rbind, lapply(dfiles, format_VUE_csv))

# Creates detections table by appending all non-duplicate records
ybt_db_append(dd, 
              db_table = "detections", 
              db_path = db_fp)


#-------------------------------------------------------#
# DEPLOYMENTS
#-------------------------------------------------------#
# Last appended/overwritten: 
# Thu Sep  3 09:53:53 2020 ------------------------------

# deployments table filepath
deps_fp = "~/DropboxCFS/NewPROJECTS/AECCA-2018-YoloTelemetry/WORKING/YB_SQL_BaseTables/Deployments.csv"

# In case you have to delete and replace the table entries without borking the schema:
# con = dbConnect(RSQLite::SQLite(), db_fp)
# deps = dbGetQuery(con, "SELECT * FROM deployments")
# depsdbSendQuery(con, "DELETE FROM deployments")
# dbDisconnect(con)

ybt::write_deployments(deps_fp, db_fp)
#-------------------------------------------------------#


#-------------------------------------------------------#
# TAGS
#-------------------------------------------------------#
tags = read.csv("~/DropboxCFS/NewPROJECTS/AECCA-2018-YoloTelemetry/WORKING/YB_SQL_BaseTables/Tags/Tags.csv", 
                  na.strings = c("NA", ""))

ybt::ybt_db_append(new_df = tags, 
                   db_path = db_fp, 
                   db_table = "tags")

# CHN

chn = read.csv("~/DropboxCFS/NewPROJECTS/AECCA-2018-YoloTelemetry/WORKING/YB_SQL_BaseTables/Tags/Chinook.csv", 
               na.strings = c("NA", ""))


ybt::ybt_db_append(new_df = chn, 
                   db_path = db_fp, 
                   db_table = "chn")

# WST
wst = read.csv("~/DropboxCFS/NewPROJECTS/AECCA-2018-YoloTelemetry/WORKING/YB_SQL_BaseTables/Tags/WhiteSturgeon.csv", na.strings = c("NA", ""))

ybt::ybt_db_append(new_df = wst, db_path = db_fp, db_table = "wst")
