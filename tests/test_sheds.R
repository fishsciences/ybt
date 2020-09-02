library(ybt)
library(tagtales)

load("tag_tale_test_df.rda")

d = tag_tales(tag_tale_test_df, "TagID", "GroupedStn", "DateTimePST")

ybt:::id_one_shed(d)

identify_sheds(d)
