##' Calculate total residence time within the Yolo Bypass receiver array for a single detection year
##' 
##' Assumes: you have a detections dataframe for a single detection year that has the following columns:
##' 
##' -  A "ReleaseTime" column that indicates the release time for each TagID, formatted as Y-m-d hh:mm:ss.
##' 
##' - arrival and departure columns, like those resulting from the tag_tales() function.


# R script used to calculate residence in past:
#-------------------------------------------------------#
library(lubridate)

# Steps:
## 1. split detections df by TagID col
## 2. see if TagID was detected at each of the three exit stations, by priority; take the departure time corresponding to the minimum arrival time at that receiver (to catch their first departure).
## 3. Bind their release times and departure times together, and calculate the time elapsed between them in days.

get_exit_times <- function(df, TagID_col){    # df = detections data frame
  test <- split(df, TagID_col)                # split by TagID col
  tmp = lapply(test, get_exit_times_onefish)     # apply get exit times one fish fxn
  fishdeps = do.call(rbind, tmp)              # combine into a fish departures df
  fishdeps = calc_TE(fishdeps)                # calculate time elapsed
}

get_exit_times_onefish <- function(test){
    stations = c("BCS", "BCN", "YBBTD")

    stn = which(stations %in% test$GroupStn)[1]
    
    test$ExitTime = if ("BCS" %in% test$GroupedStn) {
                        exit_time(test, "BCS")
                    } else if ("BCN" %in% test$GroupedStn) {
                        exit_time(test, "BCN")
                    } else if ("YBBTD" %in% test$GroupedStn) {
                        exit_time(test, "YBBTD")
                    } else {
                        test$ExitTime = "NA"}
  
  return(test)
}

exit_time = function(df, station)
{
    df$departure[df$arrival == min(df$arrival[df$GroupedStn == "BCS"])]
}

calc_TE <- function(df){
  df <- df[ , c("TagID", "ReleaseTime", "ExitTime")]
  df <- df[!duplicated(df$TagID), ]
  df$TE = as.numeric(as.duration(df$ExitTime - df$ReleaseTime), "days")
  return(df)
}
