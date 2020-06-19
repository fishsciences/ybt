#' Get Minimum and Maximum Detection of a Tagged Fish
#'
#' @param df A detections dataframe - currently requires the following columns:
#' \item{TagID}{TagID column called "TagID"}
#' \item{DateTimePST}{Date-time column called "DateTimePST"}
#' \item{GroupedStn}{Grouped station column called "GroupedStn}
#' @return A dataframe with the TagIDs, first and last detections, and first and last stations for each fish.
#' @export
#' @examples
#' min_and_max_stn(dets)

min_and_max_stn <- function(df){

   do.call(rbind, lapply(split(df, df$TagID), function(x) {
     x = x[order(x$DateTimePST), ]
     return(data.frame(
       TagID = as.numeric(unique(x$TagID)),
       first_det = min(x$DateTimePST),
       first_stn = x$GroupedStn[x$DateTimePST == min(x$DateTimePST)],
       last_det = max(x$DateTimePST),
       last_stn = x$GroupedStn[x$DateTimePST == max(x$DateTimePST)],
       stringsAsFactors = FALSE)
     )
   }
   ))
 }
