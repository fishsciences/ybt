#' Get DateTagged
#' @param tagid The (numeric) TagID of the fish for which you want the date of tagging
#' @details Note that this function requires the alltags global variable
#' @return The DateTagged value for the TagID
#' @export
#' @examples
#' get_dt(2841)
get_dt <- function(tagid) {
  print(as.character(alltags$DateTagged[alltags$TagID == tagid]), quote = FALSE)
}

#' Plot track
#'
#'@description A rudimentary ggplot of a fish track - depends on DateTimePST, GroupedStn, and rkms columns
#'@param df Dataframe of detections
#'@param tagid Numeric TagID of the fish whose track you want to plot
#'@return A ggplot
#'@export
plot_track <- function(df, tagid) {
  dd <- subset(df, TagID == tagid)
  ggplot(dd, aes(x = DateTimePST, y = reorder(GroupedStn, rkms))) +
    geom_jitter(alpha = 0.5)
}
