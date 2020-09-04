#' Execute a BARD query
#'
#' @param tagids a vector of tag IDs formatted like those returned from `bard_tags()`
#' @param dateStart start date of query
#' @param dateEnd end date of query, defaults to today
#' @param baseurl BARD query homepage
#' @param curlH curl handle; defaults to curl, which if you've run setup.R is in the global environment; running the following code will recreate it: \code{curl = getCurlHandle(useragent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36", followlocation = TRUE)}
#' @return a data frame of BARD detections; note that these detections are in a summarized format that is NOT the same as our detections.
#' @export
#' @examples
#' bard_query(tagIDS = bard_tags(c(2841, 2842)), curlH = getCurlHandle(useragent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36", followlocation = TRUE) )
#'
bard_query = function(tagIDs,
                        dateStart = "2012-01-01", dateEnd = Sys.Date(),
                        baseurl = "http://sandbox5.metro.ucdavis.edu/memo/getTagCSV/",
                        curlH = curl, ...)
{
    url = paste0(baseurl,
                 paste(tagids, collapse = ","), "/",
                 dateStart, "/", dateEnd)
    bq <- fromJSON(getURL(url, curl = curlH, ...))
    bq <- as.data.frame(data.table::rbindlist(bq))
}

#' format TagIDs for BARD query
#'
#' @param tagids a vector of numeric TagIDs
#' @param df a data frame that contains (at minimum) columns for TagID and Codespace
#' @param tagVar The name of the TagID column in df
#' @param codeVar The name of the CodeSpace column in df
#' @details This function assumes your tags are operating on the 69khz frequency.
#' @return A vector of tagids formatted for a query of the BARD database
#' @export
#' @examples
#'bard_tags(tagids = c(2841, 2842))
#'
bard_tags <- function(tagids, df = alltags, tagVar = "TagID", codeVar = "CodeSpace"){

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

