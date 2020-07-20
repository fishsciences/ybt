library(ybt)

ff = c("VR2W_106679_20120429_1_BCW.vrl", "VR2W_106679_20121010_1_BCW.vrl", 
"VR2W_106680_20120502_1_I80_1.vrl", "VR2W_106681_20120429_1_BCE.vrl", 
"VR2W_106681_20121011_1_BCE.vrl", "VR2W_106682_20120502_1_cachecreek.vrl", 
"VR2W_106683_20120429_1_RSTR.vrl", "VR2W_106683_20120709_1_RSTR.vrl", 
"VR2W_106684_20120516_1_knaggs.vrl", "VR2W_115458_20120502_1_BlwLisbon.vrl", 
"VR2W_115458_20130329_1BlwLisbon.vrl")

ans = grab_serial_date(ff)

if(FALSE){
library(RSQLite)
base_dir = "~/Dropbox"    
db_loc = file.path(base_dir, "YBTelemetryStudy/yb_database.sqlite")
con = dbConnect(SQLite(), db_loc)

ans2 = check_vrls(serial_date_df = ans, con = con)

ans3 = check_vrls(serial_date_df = ans, con = con,
                  date_range = c("2012-01-01", "2012-08-01"))

}
