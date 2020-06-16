find_gdb_dir = function(dir_name, base_dir = "~")
{
    dir(base_dir, pattern = dir_name, full.names = TRUE, recursive = TRUE)
}

find_gdb = function(base_dir = "~", db_filename = "")
{
    list.files(base_dir, pattern = db_filename, recursive = TRUE, full.names = TRUE)
}

##' Connect to GDB
##'
##' This is a convienence wrapper which first checks if the database
##' exists before attempting to open it. This avoids sqlite creating a
##' new database if the path is misspecified.
##' @title Connect to GDB
##' @param db_path the full path to the database. Can be searched for
##'     using \code{find_gdb()}
##' @param driver the result of RSQLite::SQLite()
##' @return a connection to the specified database
##' @author Matt Espe
##' @export
connectGDB = function(db_path, driver)
{
    if(!file.exists(db_path))
        stop("Data base does not exist at specified location")
    dbConnect(driver, db_path)
}



