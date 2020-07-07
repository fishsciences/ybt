#' The Yolo Bypass Telemetry package (ybt)
#' 
#' @description Database, formatting, and analysis functions for DWR's Yolo Telemetry Project.  #'    Data covers tagged fish detections from 2011-2020.
#' 
#'  @docType package
#'  @name ybt-package
#'  @aliases ybt
#'  @import ggplot2
#'  @import lubridate
#'  @importFrom data.table rleid rbindlist foverlaps setkey as.data.table
#'  @importFrom readxl read_excel