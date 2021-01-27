#-------------------------------------------------------#
# M. Johnston
# Yolo Telemetry Project 2019 Final Report
# Setup script - sourced by most report subsections in docs/
#-------------------------------------------------------#
# Sun Nov 29 22:17:08 2020 ------------------------------

library(ybt)
library(RSQLite)
library(lubridate)
library(data.table)
source("R/utils.R")
latefalls <- c(31570, 13720, 13723)

# change this filepath to point to your local copy of the database
db_path = "~/DropboxCFS/NewPROJECTS/AECCA-2018-YoloTelemetry/DELIVERABLES/Database/ybt_database.sqlite"

# open a connection
con = RSQLite::dbConnect(drv = RSQLite::SQLite(), db_path)

# Get full data from database
tags = dbGetQuery(con, "select * from tags")
dets = dbGetQuery(con, "select * from detections")
chn = dbGetQuery(con, "select * from chn") # chinook tags only
deps = dbGetQuery(con, "select * from deployments")
wst = dbGetQuery(con, "select * from wst") # wst tags only

# close connection
dbDisconnect(con)

#-------------------------------------------------------#
# DETECTIONS
#-------------------------------------------------------#

# format date-time columns
dets = format_detections(dets)

# make combo columns
dets$combo = paste(dets$TagID, dets$CodeSpace, sep = "-")
tags$combo = paste(tags$TagID, tags$CodeSpace, sep = "-")

# subset to our TagIDs and the columns we want
dets = dets[dets$combo %in% tags$combo, ]

# check false detections (detection prior to tagging)
dets = merge(dets, tags[ , c("TagID", "DateTagged")], all.x = TRUE, by = "TagID")
falsedets = dets$DateTimePST < dets$DateTagged # as of 2019, 36 false detections here
dets = dets[!falsedets, ]

# subset down to columns we want
dets = dets[ , c("TagID","CodeSpace", "Receiver", "DateTimePST")]


#-------------------------------------------------------#
# DEPLOYMENTS
#-------------------------------------------------------#
# format deployments datetime cols
deps$DeploymentEnd = force_tz(ymd_hms(deps$DeploymentEnd), 
                              "Pacific/Pitcairn")
deps$DeploymentStart = force_tz(ymd_hms(deps$DeploymentStart),
                                "Pacific/Pitcairn")

# only work with complete deployments
deps = deps[!is.na(deps$DeploymentEnd), ]
# there should be no deployments that end before they begin
stopifnot(nrow(deps[deps$DeploymentStart > deps$DeploymentEnd, ]) == 0)

# check for orphan detections; if you get a warning here, stop and examine the columns with NAs
dets = ybt::get_stations(dets, deps)

# subset back down to columns we will need going forward
dets = dets[ , c("TagID", "CodeSpace", "Receiver", "DateTimePST",  "Station")] 

# Group stations

dets = dplyr::mutate(
  dets,
  GroupedStn = dplyr::case_when(
    Station == "YBCSNE" ~ "BCN",
    Station == "YBCSNW" ~ "BCN",
    Station == "YBCSSE" ~ "BCS",
    Station == "YBCSSW" ~ "BCS",
    TRUE ~ Station
  )
) 


# Remove simultaneous detections
#-------------------------------------------------------#
d = dets
i = duplicated(d[, c("TagID", "GroupedStn", "DateTimePST")])
# all stations in i should be those where simultaneous dets are possible/known
stopifnot(unique(d[d$Station %in% d$Station[i], ]$Station) %in% c("YBCSSW", "YBCSNW", "YBCSNE", "YBCSSE", "YBRSTR", "YBBLW"))

dets = dets[!i, ]
print(paste("Removing", sum(i), "duplicate detections", sep = " ")) # 38K duplicate detections
stopifnot(nrow(d) - nrow(dets) == sum(i))


# handle redeployed tag
dets = handle_redeployed_tag(dets_df = dets)
stopifnot(len(dets$TagID) == len(tags$TagID)) # should now have the same number of tags

# add riverkm to detections
dets = merge(dets, ybt::stns, all.x = TRUE, by = "GroupedStn")

# format dates
chn$DateTagged = as.Date(chn$DateTagged)
wst$DateTagged = as.Date(wst$DateTagged)
tags$DateTagged = as.Date(tags$DateTagged)

# remove the column we made
tags$combo = NULL


# Truncate Shed tags
#-------------------------------------------------------#
# database of known shed/recovered tags and their truncation points
shed_rec = as.data.frame(readxl::read_excel("data_clean/Sheds.xlsx"))
shed_rec$DateTimePST_truncated <- force_tz(shed_rec$DateTimePST_truncated, "Pacific/Pitcairn")
shed_rec$truncated_adj = shed_rec$DateTimePST_truncated + as.numeric(duration(2, "hours"))


dets2019 = truncate_sheds(raw_detection_df = dets, 
                     TagIDs = shed_rec$TagID,
                    time_stamps = shed_rec$truncated_adj
                    )


# finally - remove fca_2012 and latefalls from the detections df for the 2019 report:
dets2019 = dets2019[!(dets2019$TagID %in% tags$TagID[tags$TagGroup == "fca_2012"]) & !(dets2019$TagID %in% latefalls), ]

stopifnot(len(dets2019$TagID) == 378-12-3) # last line should have removed 15 tags from total


# save cleaned formatted objects 
#-------------------------------------------------------#
saveRDS(dets2019, "data_clean/clean_dets_2019_report.rds")
saveRDS(chn,  "data_clean/setup_cleaned_chn.rds")
saveRDS(wst, "data_clean/setup_cleaned_wst.rds")
saveRDS(tags, "data_clean/setup_cleaned_tags.rds")
saveRDS(deps, "data_clean/setup_cleaned_deps.rds")

# how to recreate dd object saved to data_clean/tagtales_dets_2019_report.rds
if(FALSE){
  
load("data_clean/clean_dets_2019_report.rda")
    
ddf = tagtales::tag_tales(dets2019, dets2019$TagID, dets2019$GroupedStn, "DateTimePST", allow_overlap = FALSE)

ddf = ybt::get_det_year(ddf, "DateTimePST")

saveRDS(ddf, "data_clean/overlapsfalse_dets_2019_report.rds") 

ddt = tagtales::tag_tales(dets2019, dets2019$TagID, dets2019$GroupedStn, "DateTimePST", allow_overlap = TRUE)

ddt = ybt::get_det_year(ddt, "DateTimePST")

saveRDS(ddt, "data_clean/overlapsTRUE_dets_2019_report.rds")

}
