#' Execute a BARD query
#'
#' @param tagIDs formatted like those returned from `bard_tags()`
#' @param dateStart start date of query
#' @param dateEnd end date of query, defaults to today
#' @param baseurl BARD query homepage
#' @param curlH curl handle; defaults to curl, which if you've run setup.R is in the global environment; running the following code will recreate it: `curl = getCurlHandle(useragent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36", followlocation = TRUE)`
#' @return a data frame of BARD detections; note that these detections are in a summarized format that is NOT the same as our detections.
#'
bard_query = function(tagIDs,
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
