# parsing functions

## rec column should never have items with more or less than 6 digits?
## no characters or NAs in TAgID, rec, or codespace cols

# formatting functions

# format_detections:
load("test_rawdets_df.rda") # 6 rows of raw db queried detections; basically head(dbGetQuery(con, "select * from detections))

df = format_detections(rawdets)
stopifnot(tz(df$DateTimeUTC) == "UTC")
stopifnot(tz(df$DateTimePST) == "Pacific/Pitcairn")
## no characters or NAs in TAgID, rec, or codespace cols
