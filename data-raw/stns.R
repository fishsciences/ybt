## code to prepare `stns` dataset

stns <- read.csv(system.file("extdata", "stnkms.csv", package = "ybt", mustWork = TRUE), stringsAsFactors = FALSE)
stns <- stns[!is.na(stns$GroupedStn), ]
stns <- stns[!duplicated(stns$GroupedStn), c("GroupedStn", "rkms")]
stns <- stns[order(stns$rkms), ]
usethis::use_data("stns")
