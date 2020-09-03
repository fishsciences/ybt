# parsing functions


# formatting functions

# format_detections:
load("test_rawdets_df.rda") # 6 rows of raw db queried detections; basically head(dbGetQuery(con, "select * from detections))

df = format_detections(rawdets)
stopifnot(tz(df$DateTimeUTC) == "UTC")