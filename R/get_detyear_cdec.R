#' Get cdec data for a given detection year
#'
#' Will pull data for the detection window of a given Detection year; that is, will pull CDEC data for the time that tagged fish are detected in the array.
#'
#' @param detyear Detection year for which you want data
#' @param detsdf Detections dataframe
#' @param timecol Name of the date-time column for detections, in quotes
#' @param cdecstn Three-letter acronym of the CDEC station, i.e. "LIS"
#' @param sensor Sensor number for the CDEC station
#' @param durtype Type of duration, i.e. "E" for event, "H" for hourly, "D" for daily.  See \code{\?cdeq_query} for more info.
#' @return a dataframe returned by \code{cdeq_query()} for the specified detection year
#' @export
#' @details Note that this function calls get_det_year() and get_det_window internally, so you don't need to call these first.
#'
get_detyear_cdec <- function(detyear, detsdf, timecol, cdecstn, sensor, durtype) {

#function testing
 # detsdf = ybs; timecol = "DateTimePST"
  dets_df <- get_det_year(detsdf, timecol = timecol)
  start_end_lu <- get_det_window(dets_df, timecol = timecol)
# function testing
  #detyear = 2013; cdec_stn = "LIS"; sensor = 20; durtype = "E"
  data = cdec_query(station = cdecstn,
                    sensor_num = sensor,
                    dur_code = durtype,
                    start_date = as.Date(start_end_lu$first_det[start_end_lu$Detyear == detyear]),
                    end_date = as.Date(start_end_lu$last_det[start_end_lu$Detyear == detyear]),
                    tzone = "Pacific/Pitcairn")
  return(data)
}
