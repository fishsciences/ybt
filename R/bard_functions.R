#' format TagIDs for BARD query
#'
#' @param tagids a vector of numeric TagIDs
#' @param df a data frame that contains (at minimum) columns for TagID and Codespace
#' @param tagVar The name of the TagID column in df
#' @param codeVar The name of the CodeSpace column in df
#' @details This function assumes your tags are operating on the 69khz frequency.
#' @return A vector of tagids formatted for a query of the BARD database
#' @export
#'
bard_tags <- function(tagids, df, tagVar = "TagID", codeVar = "CodeSpace"){

   cs = df[[codeVar]][df[[tagVar]] %in% tagids]  # creates logical vector of matching tagids, pulls correct codespaces via that logical vector
   sprintf("%s-%i-%i", "A69", cs, tagids) # pastes a string, integer, integer together
}

# internal for get_last_bd
get_last_bd_onefish <- function(bq) {
  bqf <- data.frame(
    TagID = as.numeric(unique(bq$TagID)),
    last_det_bard = max(bq$LastDetect),
    last_loc_bard = bq$GeneralLocation[bq$LastDetect == max(bq$LastDetect)]
    , stringsAsFactors = FALSE)
  return(bqf)
}

