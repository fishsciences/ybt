#--------------------------------------------#
# append new rows to tables in toy.sqlite
#--------------------------------------------#
if(FALSE){
# vector of potential GoogleDriveBackup paths on different systems
# can grow this vector rather than breaking the path for different users
# also, using file.path rather than paste to make more portable across operating systems
potential_gdb_paths <- c(
    file.path("~", "Dropbox (Cramer Fish Sciences)", "NewPROJECTS", "AECCA-2018-YoloTelemetry", 
            "WORKING", paste0("GoogleDriveBackup", gdb_date)),
  file.path("~", "Dropbox (Cramer Fish Sciences)", "PROJECTS", "AECCA-2018-YoloTelemetry", 
            "WORKING", paste0("GoogleDriveBackup", gdb_date))
)


#change for the year/file you're appending
detyear <- 2018
detyear_fldr <- paste0("YB_detyear", detyear, "_dc_dets")
dets_csv_path <- file.path(gdb_path, file.path("YB_SQL_BaseTables", "Detections", 
                                               detyear_fldr, paste0(detyear_fldr, ".csv")))

}


##' Appends new data to an existing database.
##' 
##' Appends new data to an existing database. 
##' @title YBT Append Detection Observations
##' @param new_df 
##' @param db_table 
##' @param db_path 
##' @param driver 
##' @return 
##' @author Matt Espe
##' @export
ybt_db_append = function(new_df, db_table, db_path, driver = SQLite())
{
    con = connectGDB(db_path, driver)
    if(!dbExistsTable(con, db_table))
        stop(db_table, " not found in database ", db_path)
    
    before = db_nrow(con, db_table)
    dbCreateTable(con, "tmp", new_df)

    on.exit({
        dbRemoveTable(con, "tmp")
        dbDisconnect(con)
    })

    query = sprintf("INSERT OR IGNORE INTO %s (SELECT * FROM tmp)",
                    db_table)
    dbExecute(con, query)

    after = db_nrow(con, db_table)
    message(sprintf("%s records appended to %s", after - before, detection_table,nm))
    return(invisible(NULL))
}

db_nrow = function(con, tbl)
{
    dbGetQuery(con, sprintf("SELECT COUNT(*) FROM %s", tbl))[[1]]
}

if(FALSE){
################## Travis stopped here when going over this code

# check years/date ranges that are included in the db so far:
dchk = tbl(db, "detections") %>%
  collect() 


dups_raw <- dchk %>% 
  group_by(TagID, Receiver) %>% 
  filter(duplicated(DateTimePST)) %>% 
  ungroup()

unique(dups_raw$Receiver)

dbListFields(db, "detections")
sapply(tbls, function(x) dbGetQuery(db, paste("SELECT COUNT(*) FROM" , x))) 

# after 2011: 201990 detections
# after 2012:  484898 
# after 2013: 846071
# 1340052 after 2014
# 1598332 after 2015
# 1799105 after 2016
# 2192328 after 2017
# 2389975 after 2018 

#--------------------------------------------#
# Deployments tabls - basically build from scratch each time, because it's all in one updated file:
}
write_deployments = function(xlsx_file, db_path,
                             driver = SQLite())
{
    con = connectGDB(db_path, driver)
    on.exit(dbDisconnect(con))
    d = as.data.frame(read_excel(xlsx_file), stringsAsFactors = FALSE)
    
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
                                 "DetectionYear" = "integer", 
                                 "DeploymentStart" = "text", 
                                 "DeploymentEnd" = "text", 
                                 "VRLDate" = "text", 
                                 "DeploymentNotes" = "text", 
                                 "VRLNotes" = "text")
                 )
    return(invisible(NULL))    
}
