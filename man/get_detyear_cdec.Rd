% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_detyear_cdec.R
\name{get_detyear_cdec}
\alias{get_detyear_cdec}
\title{Get cdec data for a given detection year}
\usage{
get_detyear_cdec(detyear, detsdf, timecol, cdecstn, sensor, durtype)
}
\arguments{
\item{detyear}{Detection year for which you want data}

\item{detsdf}{Detections dataframe}

\item{timecol}{Name of the date-time column for detections, in quotes}

\item{cdecstn}{Three-letter acronym of the CDEC station, i.e. "LIS"}

\item{sensor}{Sensor number for the CDEC station}

\item{durtype}{Type of duration, i.e. "E" for event, "H" for hourly, "D" for daily.  See \code{\?cdeq_query} for more info.}
}
\value{
a dataframe returned by \code{cdeq_query()} for the specified detection year
}
\description{
Will pull data for the detection window of a given Detection year; that is, will pull CDEC data for the time that tagged fish are detected in the array.
}
\details{
NOTE: This function assumes you want date/time column returned from CDEC in **Pacific Standard Time**

Note that this function calls get_det_year() and get_det_window internally, so you don't need to call these first.
}
