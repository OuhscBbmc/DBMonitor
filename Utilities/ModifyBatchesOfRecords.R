#This next line is run when the whole file is executed, but not when knitr calls individual chunks.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

require(grid, quietly=TRUE)
require(plyr, quietly=TRUE)
require(ggplot2, quietly=TRUE)
require(scales, quietly=TRUE)
# require(xtable, quietly=TRUE) #For formatting LaTeX and HTML tables

#############################
### LoadDS
#############################
pathDirectoryCode <- "./Dal/DualTM.R"

if( !file.exists(pathDirectoryCode) ) stop(paste0("The file '", pathDirectoryCode, "' could not be found.  Check the path.  For this to work correctly, the 'MReporting.Rproj' needed to be opend in RStudio.  Otherwise the working directory."))
source(pathDirectoryCode)
if( is.null(dsRoster) ) stop("The extracting code did not run properly.  The data.frame 'dsRoster' should not be null.")
if( is.null(dsLog) ) stop("The extracting code did not run properly.  The data.frame 'dsLog' should not be null.")
rm(pathDirectoryCode)

#############################
### Fix record count
#############################
dateBreak <- ISOdatetime(2013, 09, 06, 11, 00, 00)
# tableToFix <- "dbo.tblAgency"; multiplier <- 3
# tableToFix <- "dbo.tblLUTrainingType"; multiplier <- 3
# tableToFix <- "dbo.tblPresenter"; multiplier <- 3
# tableToFix <- "dbo.tblSession"; multiplier <- 4
# tableToFix <- "dbo.tblTherapist"; multiplier <- 5
# tableToFix <- "dbo.tblTraining"; multiplier <- 7
stop("A table name and multiplier value need to be specified.")

dsToFix <- dsLog[dsLog$table==tableToFix & dsLog$probe_date <= dateBreak, ]

dsToFix$row_count <- dsToFix$row_count/ multiplier

#############################
### Convert to a CSV for uploading
#############################
write.csv(dsToFix, textConnection('csvElements', 'w'), row.names = FALSE)

#Convert the vector of csv elements to one long CSV string
csv <- paste(csvElements, collapse="\n")
rm(csvElements)

#############################
### Write to REDCap with API
#############################
recordsAffected <- RCurl::postForm(
  uri=redcapUri, 
  token=tokenLog,
  content='record',
  format='csv', 
  type='flat', 
  overwriteBehavior='normal', #overwriteBehavior: *normal* - blank/empty values will be ignored [default]; *overwrite* - blank/empty values are valid and will overwrite data
  data=csv,
  .opts=curlOptions(cainfo="./Dal/Certs/ca-bundle.crt")
)
message(paste("Count of records (ie, database tables being monitored) written & updated to REDCap:", as.integer(recordsAffected)))
rm(csv, recordsAffected)