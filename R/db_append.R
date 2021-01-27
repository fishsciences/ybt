#--------------------------------------------#
# append new rows to tables 
#--------------------------------------------#

##' Appends new data to an existing database.
##' 
##' Appends new data to an existing database.
##' @title YBT Append Detection Observations
##' @param new_df data.frame containing the new observations to append
##'     to the database
##' @param db_table character, the name of the database table to
##'     append into
##' @param db_path character, the file path to the database
##' @param driver the SQLite driver to use
##' @return NULL. This function is called for its side effects.
##' @author Matt Espe
##' @export
ybt_db_append = function(new_df, db_table, db_path, driver = SQLite())
{
    con = connectGDB(db_path, driver)
    if(!dbExistsTable(con, db_table))
        stop(db_table, " not found in database ", db_path)
    
    before = db_nrow(con, db_table)
    dbCreateTable(con, "tmp", new_df)

    # not sure why this workaround is needed
    if(db_nrow(con, "tmp") == 0)
        dbAppendTable(con, "tmp", new_df)
    
    on.exit({
        dbRemoveTable(con, "tmp")
        dbDisconnect(con)
    })

    query = sprintf("INSERT OR IGNORE INTO %s SELECT * FROM tmp",
                    db_table)
    dbExecute(con, query)

    after = db_nrow(con, db_table)
    message(sprintf("%s records appended to %s", after - before, db_table))
    return(invisible(NULL))
}

db_nrow = function(con, tbl)
{
    dbGetQuery(con, sprintf("SELECT COUNT(*) FROM %s", tbl))[[1]]
}



# DEPLOYMENTS
#-------------------------------------------------------#
#'@export
write_deployments = function(deps_csv, db_path,
                             driver = SQLite())
{
    con = connectGDB(db_path, driver)
    on.exit(dbDisconnect(con))
    d = read.csv(deps_csv, stringsAsFactors = FALSE)
    
    ## format date/time columns as text
    cols = c("DeploymentStart", "DeploymentEnd", "VRLDate")
    d[cols]  = sapply(d[cols], as.character)
    
    dbWriteTable(conn = con, 
                 name = "deployments", 
                 value = d, 
                 overwrite = TRUE,
                 field.types = c("Location" = "text", 
                                 "StationAbbOld" = "text", 
                                 "Station" = "text", 
                                 "Receiver" = "integer", 
                                 "DeploymentStart" = "text", 
                                 "DeploymentEnd" = "text", 
                                 "VRLDate" = "text", 
                                 "DeploymentNotes" = "text", 
                                 "VRLNotes" = "text")
                 )
    return(invisible(NULL))    
}
