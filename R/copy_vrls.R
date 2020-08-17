##' Copies vrl files from field directory
##'
##' Copies files
##' @title Copy VRLS files to new directory
##' @param dir string, the base directory to begin looking for files
##' @param dest string, a destination directory. Will be created if it doesn't exist
##' @param file_regex regex for matching
##' @param file_type the file extension for files to move
##' @param regex_exclude logical, whether the regex should match files to exclude or include
##' @param all_files all prospective files to copy
##' @param full.names logical
##' @param recursive logical
##' @param match_files files which match the parameters from the regex and file type
##' @param ... additional args passed to \code{file.copy}
##' @return NULL
##' @author Matt Espe
##' @export
copy_vrls = function(dir = ".",
                     dest,
                     file_regex = "RLD",
                     file_type = "vrl",
                     regex_exclude = TRUE,
                     all_files = list.files(
                       dir,
                       pattern = paste0("\\.", file_type, "$"),
                       full.names = TRUE,
                       recursive = TRUE
                     ),
                     match_files = grep(all_files,
                                        pattern = file_regex,
                                        invert = regex_exclude,
                                        value = TRUE),
                     ...)
{
  if (!dir.exists(dest))
    dir.create(dest)
  
  file.copy(match_files, dest, ...)
  return(invisible(NULL))
}