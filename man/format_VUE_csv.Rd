% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_VUE_csv.R
\name{format_VUE_csv}
\alias{format_VUE_csv}
\title{Format detections that have been exported from VUE}
\usage{
format_VUE_csv(filepath)
}
\arguments{
\item{filepath}{The full filepath to the exported .csv}
}
\value{
A dataframe with 10 formatted columns.
}
\description{
This function reads the exported .csv from VUE, formats the column names and data types, and checks for duplicate detections of the same TagID at single receivers (it does not remove simultaneous detections that take place on multiple receivers).
}
\details{
This function has only been tested on data that was exported using VUE's defaults (The 10 default columns, calibrated sensor values, UTC time stamps).
}
