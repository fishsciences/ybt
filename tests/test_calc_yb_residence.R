library(ybt)
library(tagtales)

load("tag_tale_test_df.rda")
d = tag_tales(tag_tale_test_df, "TagID", "GroupedStn", "DateTimePST")
d$ReleaseTime = as.POSIXct("2017-09-01 00:00:00", tz = "Pacific/Pitcairn")

d2 = get_exit_times(d, "TagID")
