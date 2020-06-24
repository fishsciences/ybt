#' Get stations - merge deployments and detections data frame so that the correct station name is associated with a given detection and receiver number
#' @param detections_df Dataframe of Detections - currently requires that the datetime column be named "DateTimePST" and that the Receiver column be named "Receiver"
#' @param deployments_df Dataframe of receiver deployments.  Must have a Receiver column, a Start column, and an End column.
#'
#' @details It's important to appropriately join receiver and detection data in a way that ensures:
#' \enumerate{
#' \item the appropriate station is associated with receiver detections of a certain date range.
#' \item we can double check that each detection is associated with a valid receiver deployment, i.e. that there are no "orphan" detections.
#' The get_stations() function does this in one step.  If you have NAs in your results (basically, detections that don't fall within any particular deployment window), the function will not fail but it will trip a warning.
#' }
#'
#' @return A merged dataframe with Receiver, DateTimePST, Station, and any other columns the detections_df had originally
#' @export
#' @examples
#' \dontrun{
#' get_stations(dets, deps)}

get_stations <- function(detections_df, deployments_df) {
  
  x$end = detections_df$DateTimePST
  x = as.data.table(detections_df)
  y = as.data.table(deployments_df)
  setkey(y, Receiver, Start, End)
  result = foverlaps(x, y, by.x = c('Receiver', 'DateTimePST', 'end'), type = 'within')
  result <- as.data.frame(result)
  result$end = NULL
  if(sum(is.na(result$Start)) > 0){
    warning("warning: the resulting dataframe contains NAs in the joining columns - check for orphan detections")
    }
  return(result)
}
