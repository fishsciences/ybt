% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_stations.R
\name{get_stations}
\alias{get_stations}
\title{Get stations - merge deployments and detections data frame so that the correct station name is associated with a given detection and receiver number}
\usage{
get_stations(detections_df, deployments_df)
}
\arguments{
\item{detections_df}{Dataframe of Detections - currently requires that the datetime column be named "DateTimePST" and that the Receiver column be named "Receiver"}

\item{deployments_df}{Dataframe of receiver deployments.  Must have a Receiver column, a DeploymentStart column, and a DeploymentEnd column.}
}
\value{
A merged dataframe with Receiver, DateTimePST, Station, and any other columns the detections_df had originally
}
\description{
Get stations - merge deployments and detections data frame so that the correct station name is associated with a given detection and receiver number
}
\details{
It's important to appropriately join receiver and detection data in a way that ensures:
\enumerate{
\item the appropriate station is associated with receiver detections of a certain date range.
\item we can double check that each detection is associated with a valid receiver deployment, i.e. that there are no "orphan" detections.
The get_stations() function does this in one step.  If you have NAs in your results (basically, detections that don't fall within any particular deployment window), the function will not fail but it will trip a warning.
}
}
\examples{
\dontrun{
get_stations(dets, deps)}
}
