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
bard_query = function(tagids,
                        dateStart = "2012-01-01", dateEnd = Sys.Date(),
                        baseurl = "http://sandbox5.metro.ucdavis.edu/memo/getTagCSV/",
                        curlH = curl, ...)
{
    url = paste0(baseurl,
                 paste(tagIDs, collapse = ","), "/",
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

