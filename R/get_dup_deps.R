##' Get duplicate deployments - Find receivers with associated with more than one station in the deployments table

##'@param dep_df Deployments dataframe, like the one returned from `dbGetQuery(con, "select * from deployments)`
##'@return a vector of receiver serial numbers that are associated with more than one station
##'@details  as of July 2019, there are only two receivers that have been used and then re-deployed in another place: Above Ag4/Below Wallace Weir, and Above Wallace Weir/Below Los Rios Check Dam.
#'@export
#'@examples
#'\dontrun{
#' deps <- dbGetQuery(con, "select * from deployments)  # where con = yb database connection
#' get_dup_deps(deps)
#' }

get_dup_deps <- function(dep_df)
{
   tt = tapply(dep_df$Station, dep_df$Receiver, function(x) length(unique(x)) > 1)
   as.numeric(names(tt)[tt])
}
