#--------------------------------------------#
# append new rows to tables 
#--------------------------------------------#

# DETECTIONS
#-------------------------------------------------------#
gdb_append_detections = function(new_detections_df, db_path, driver = SQLite(),
                                 detection_table_nm = "detections")
{
    con = connectGDB(db_path, driver)
    before = dbGetRowCount(con, detection_table_nm)
    dbCreateTable(con, "det_tmp", dets)

    on.exit({
        dbRemoveTable(con, "det_tmp")
        dbDisconnect(con)
    })

    query = sprintf("INSERT OR IGNORE INTO %s (SELECT * FROM det_tmp)",
                    detection_table_nm)
    dbSendQuery(con, query)

    after = dbGetRowCount(con, detection_table_nm)
    message(sprintf("%s records appended to %s", after - before, detection_table,nm))
    return(invisible(NULL))
}


# DEPLOYMENTS
#-------------------------------------------------------#
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
