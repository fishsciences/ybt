#' Format detections that have been exported from VUE
#' 
#' This function reads the exported .csv from VUE, formats the column names and data types, and checks for duplicate detections of the same TagID at single receivers (it does not remove simultaneous detections that take place on multiple receivers).
#' 
#' @param filepath The full filepath to the exported .csv
#' @details This function has only been tested on data that was exported using VUE's defaults (The 10 default columns, calibrated sensor values, UTC time stamps).
#' @return A dataframe with 10 formatted columns.
#' @export

format_VUE_csv <- function(filepath) {
  
  dd = read.csv(filepath, stringsAsFactors = FALSE)
  
  if(ncol(dd) != 10) stop("incorrect number of columns in detections dataframe")

# these columns should always be there as the raw output of VUE
colnames(dd) = c("DateTimeUTC", 
                 "Receiver", 
                 "TagID", 
                 "TagName", 
                 "TagSN",
                 "SensorValue", 
                 "SensorUnit", 
                 "StationName", 
                 "Latitude",
                 "Longitude")

dd = dd[ , -(8:10)]

  dd$DateTimeUTC = as.character(lubridate::ymd_hms(dd$DateTimeUTC, tz = "UTC"))
  dd = dd[!is.na(dd$DateTimeUTC), ]
  # remove duplicate detections within tagids + receivers; slow though - maybe switch to data.table?
  i = duplicated(dd[, c("TagID", "Receiver", "DateTimeUTC")])
  dups = sum(i)
  dd = dd[!i,]
  
  message(sprintf("Format complete; removed %d duplicate detections within TagIDs from %s", 
                  dups, basename(filepath)))
  return(dd)

}