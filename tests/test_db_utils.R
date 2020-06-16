library(ybt)

gdb_dir = find_gdb_dir("tests", ".")
stopifnot(length(gdb_dir) > 0)

gdb = find_gdb(gdb_dir, "toy.sqlite")
stopifnot(length(gdb) > 0)


