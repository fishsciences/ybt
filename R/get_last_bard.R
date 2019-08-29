# internal for get_last_bd
get_last_bd_onefish <- function(bq) {
  bqf <- data.frame(
    TagID = as.numeric(unique(bq$TagID)),
    last_det_bard = max(bq$LastDetect),
    last_loc_bard = bq$GeneralLocation[bq$LastDetect == max(bq$LastDetect)]
    , stringsAsFactors = FALSE)
  return(bqf)
}

#' get final location and detection time for every tagID in the output of a bard query
#' @param bdf Dataframe returned by a BARD query, i.e. the return object of `bard_query`. Note - `get_last_bd()` calls `parse_tagid_col()` internally, so don't call that function before you run this one.
#' @param tagcol Name of the TagID column in `bdf`
#' @return Dataframe with columns: `TagID`, `last_det_bard` = last detection recorded for that TagID in the provided BARD dataframe, `last_loc_bard` = name of the Station associated with the last detection
#' @details Note - `get_last_bd` calls `parse_tagid_col()` internally, so don't call that function before you run this one.
#'
get_last_bard <- function(bdf, tagcol = "TagID") {
  #bds = bq # function testing
  bdf <- parse_tagid_col(bdf, tagcol = tagcol)
  bdf2 <- by(bdf, bdf$TagID, get_last_bd_onefish)
  return(do.call(rbind, bdf2))
}
