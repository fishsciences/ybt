# Documents how ybt_database.sqlite was originally created from source files
# M. Johnston
# Wed Sep  2 13:02:28 2020 ------------------------------

library(ybt)
library(RSQLite) 
source("R/utils.R")

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

# Creates database by appending all non-duplicate records
ybt::db_init("~/DropboxCFS/NewPROJECTS/AECCA-2018-YoloTelemetry/DELIVERABLES/Database/ybt_database.sqlite")

ybt_db_append(dd, 
              db_table = "detections", 
              db_path ="~/DropboxCFS/NewPROJECTS/AECCA-2018-YoloTelemetry/DELIVERABLES/Database/ybt_database.sqlite")



