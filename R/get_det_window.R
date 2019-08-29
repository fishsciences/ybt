#' Get detection window
#' get the range of detections for each detection year of a dataframe
#'
#' @param dets_df Detections dataframe with a Detyear column.  To add the Detyear column, call \code{get_det_year()} on your dataframe first.
#' @param timecol The name of the date-time column for the detections, in quotes
#' @return A dataframe with the date and time of the first and last detection for each Detection Year present in the dataframe (between 2011 and 2018).
#' @export
#' @examples
#' get_det_window(chn_detections, "DateTimePST")
#'
get_det_window <- function(dets_df, timecol) {
  dw <- do.call(rbind, by(dets_df, dets_df$Detyear, function(x) {
    return(data.frame(
       Detyear = as.numeric(unique(x$Detyear)),
       first_det = min(x[[timecol]]),
       last_det = max(x[[timecol]]),
       stringsAsFactors = FALSE)
     )
  }
  )
)
  return(dw)
}

