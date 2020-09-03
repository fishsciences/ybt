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
  
  # change columns to character if not already:
dd[ , c("TagName", "TagSN","SensorValue", "SensorUnit")] = lapply(dd[ , c("TagName", "TagSN","SensorValue", "SensorUnit")], as.character)
  
  message(sprintf("Format complete; removed %d duplicate detections within TagIDs from %s", 
                  dups, basename(filepath)))
  return(dd)

}


#' Format detections that have been queried from database
#' 
#' This function parses the TagID and Receiver columns from the detections table of the database, creates a DateTimePST column, and formats all date columns to "%Y-%m-%d %H:%M:%S".
#' 
#' @param dets_df Detections dataframe as it is returned by dbGetQuery("select * from detections").
#' @param tagid_col Quoted name of the column with Tag or Fish IDs in it (defaults to "TagID"); passed along to parse_tagid_col().
#' @param rec_col Quoted name of the column with the Receiver ID in it (defaults to "Receiver"); passed along to parse_receiver_col().
#' @param datetime_col Quoted name of the column with detection date time stamps; defaults to "DateTimeUTC".
#' @return A dataframe with 10 formatted columns.
#' @export


format_detections <- function(dets_df, tagid_col = "TagID", 
                              rec_col = "Receiver",
                              datetime_col = "DateTimeUTC") {
  
  df = parse_tagid_col(dets_df, tagcol = tagid_col)
  df = parse_receiver_col(df, reccol = "Receiver")
  df[[datetime_col]] = ymd_hms(df[[datetime_col]])
  df$DateTimePST = with_tz(df[[datetime_col]], "Pacific/Pitcairn")
  
  return(df)
  
  
}
