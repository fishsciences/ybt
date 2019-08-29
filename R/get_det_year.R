#' Get Detection Year
#' Add a detection year column to a detections dataframe
#' @param detsdf Dataframe of detections data
#' @param timecol The name of the Date-time column, in quotes (like "DateTimePST")
#' @return The dataframe, with a Detyear column added
#' @details Categorizes detections based on whether they fall between July 1st and June 30th of a given year.  Currently supports years 2011 - 2018; future versions of this function will be more flexible and general.
#' @export
#' @examples
#' get_det_year(dets, "DateTimePST")
#'
get_det_year <- function(detsdf, timecol) {
    detsdf$Detyear = ifelse(
      detsdf[[timecol]] %within% (ymd_hms("2011-07-01 00:00:00") %--% ymd_hms("2012-06-30 23:59:59"))
    , 2011, ifelse(
        detsdf[[timecol]] %within% (ymd_hms("2012-07-01 00:00:00") %--% ymd_hms("2013-06-30 23:59:59")),
      2012, ifelse(
        detsdf[[timecol]] %within% (ymd_hms("2013-07-01 00:00:00") %--% ymd_hms("2014-06-30 23:59:59")),
        2013, ifelse(
          detsdf[[timecol]] %within% (ymd_hms("2014-07-01 00:00:00") %--% ymd_hms("2015-06-30 23:59:59")),
          2014, ifelse(
            detsdf[[timecol]] %within% (ymd_hms("2015-07-01 00:00:00") %--% ymd_hms("2016-06-30 23:59:59")), 2015, ifelse(
    detsdf[[timecol]] %within% (ymd_hms("2016-07-01 00:00:00") %--% ymd_hms("2017-06-30 23:59:59")),
    2016, ifelse(
    detsdf[[timecol]] %within% (ymd_hms("2017-07-01 00:00:00") %--% ymd_hms("2018-06-30 23:59:59")),
    2017, 2018)))))))
    return(detsdf)
}
