library(ybt)
library(tagtales)

load("tag_tale_test_df.rda")

d = tag_tales(tag_tale_test_df, "TagID", "GroupedStn", "DateTimePST")

ybt:::id_one_shed(d)

identify_sheds(d)

##----------------------------------------##

cutpt = find_one_cutpt(tag_tale_test_df)

## should return last date
stopifnot(cutpt == tag_tale_test_df$DateTimePST[216])


a = truncate_sheds(tag_tale_test_df, 2590)
all.equal(a, tag_tale_test_df, check.attributes = FALSE)

a = truncate_sheds(tag_tale_test_df, 2590,
                   time_stamps = tag_tale_test_df$DateTimePST[200])
stopifnot(nrow(a) == 200)

if(FALSE){
    dd = readRDS("~/Dropbox/2018-AECOMM-Yolo-Telemetry-External/data/sheds_in.rds")
    sheds <- c(13729, 20168, 20164, 37835, 2600, 2625, 9986, 2619)
    ## test on the full dataset
    b = truncate_sheds(dd, sheds)

    d2 = table(dd$TagID)
    b2 = table(b$TagID)
    stopifnot(all(names(d2[d2 != b2]) %in% sheds))
    
}

