#' format data for BARD query
#'
#' @param tagids a vector of numeric TagIDs
#' @param df a data frame that contains (at minimum) columns for TagID and Codespace
#' @param tagVar The name of the TagID column in df
#' @param codeVar The name of the CodeSpace column in df
#' @return A vector of tagids formatted for a query of the BARD database
#' @examples
#'
#'
bard_tags <- function(tagids, df = alltags, tagVar = "TagID", codeVar = "CodeSpace"){

   cs = df[[codeVar]][df[[tagVar]] %in% tagids]  # creates logical vector of matching tagids, pulls correct codespaces via that logical vector
   sprintf("%s-%i-%i", "A69", cs, tagids) # pastes a string, integer, integer together
}

