#' Get duplicate deployments - Find receivers with associated with more than one station in the deployments table

#'@param dep_df Deployments dataframe, like the one returned from `dplyr::tbl(conn, "deployments") %>% collect()`
#'@return a vector of receiver serial numbers that are associated with more than one station
#'@details # as of July 2019, there are only two receivers that have been used and then re-deployed in another place: Above Ag4/Belwo Wallace Weir, and Above Wallace Weir/Below Los Rios Check Dam.
#'@export
#'@examples
#'\dontrun{
#' deps <- dplyr::tbl(conn, "deployments") %>% collect() # where conn = yb database connection
#' get_dup_deps(deps)
#' }

get_dup_deps <- function(dep_df)
{
   tt = tapply(dep_df$Station, dep_df$Receiver, function(x) length(unique(x)) > 1)
   as.numeric(names(tt)[tt])
}
