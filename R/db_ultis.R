find_gdb_dir = function(dir_name, base_dir = "~")
{
    dir(base_dir, pattern = dir_name, full.names = TRUE, recursive = TRUE)
}

find_gdb = function(base_dir = "~", db_filename = "")
{
    list.files(base_dir, pattern = db_filename, recursive = TRUE, full.names = TRUE)
}

connectGBD = function(db_path, driver)
{
    if(!file.exists(db_path))
        stop("Data base does not exist at specified location")
    dbConnect(driver, db_path)
}

