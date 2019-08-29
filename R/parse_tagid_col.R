#' parse vemco tag info
#'@description separates the vemco-dictated column formatting of freq-codespace-tagid, then just keeps the codespace and tagids as separate columns
#'@param df dataframe with a transmitter column that is formatted as 'Freq-CodeSpace-Transmitter'
#'@param tagcol the name of the column you wish to parse
#'@return A dataframe with the CodeSpace and TagID columns at the end, with frequency columns removed.
#'@export
#' @examples
#' df <- structure(list(TagID = c("A69-1206-112", "A69-1206-152", "A69-1206-1908"
#' ), Monitor = c("VR2W-106683", "VR2W-106683", "VR2W-106683"),
#'     Detections = c(1L, 1L, 1L)), row.names = c(NA, 3L), class = "data.frame")
#' parse_tagid_col(df, "TagID")

parse_tagid_col <- function(df, tagcol = "TagID") {
  names(df)[names(df) == tagcol] <- "SepTagID" # rename the old combined tagid col
  out <- as.data.frame(do.call(rbind, strsplit(as.character(df$SepTagID),'-')),
                       stringsAsFactors = FALSE)

  colnames(out) <- c("freq", "CodeSpace", "TagID")
  final <- cbind(df, out)
  drops <- c("freq", "SepTagID")
  final <- final[ , !names(final) %in% drops]
  final$CodeSpace <- as.integer(final$CodeSpace)
  final$TagID <- as.integer(final$TagID)
  return(final)
  }
