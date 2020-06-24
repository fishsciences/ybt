##' Initialize an empty database
##'
##' This function initialized a database according to a schema. This
##' is done so that contraints on the data fields, including keys, can
##' be specified. Once initialized, the database can be populated
##' while ensuring that the data meet the constraints.
##' @title Initialize a database
##' @param db_file string, the full path and name of the database file
##'     to be initialized.
##' @param driver A SQLite driver
##' @param con A connection to an empty database. If the database does
##'     not exist, it will be created.
##' @param schema string, a SQLite command to create the database
##' @param schema_file a file with SQLite code specifying the schema
##'     for the database.
##' @return NULL
##' @author Matt Espe
##' @export
db_init = function(db_file, driver = SQLite(),
                   con = dbConnect(driver, db_file),
                   schema = strsplit(paste(readLines(schema_file),
                                           collapse = " "), ";")[[1]],
                   schema_file = system.file("create_db.sql", package = "ybt"))
{
    on.exit(dbDisconnect(con))
    
    if(length(dbListTables(con)))
        stop("Database file ", db_file, "is not empty. Did you mean to call db_populate()?")

    invisible(sapply(schema, function(x) dbExecute(con, x)))
           
    return(invisible(NULL))
}

