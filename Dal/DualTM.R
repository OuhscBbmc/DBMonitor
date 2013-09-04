#This calls REDCap and returns the unfiltered records of the Roster (PID #90) and the Log (PID #89)

# rm(list=ls(all=TRUE))  #Clear the variables from previous runs.  UNcomment this only during testing, or else it will wipe out the calling code's memory.
require(RCurl, quietly=TRUE)
require(plyr, quietly=TRUE)
# require(reshape2, quietly=TRUE)
# require(lubridate, quietly=TRUE)
# require(stringr, quietly=TRUE)
require(RODBC, quietly=TRUE)

#############################
### Global Declarations & Functions
#############################

#############################
### Retrieve token and REDCap URL
#############################
dsnName <- "MiechvEvaluation"
channel <- RODBC::odbcConnect(dsnName) #getSqlTypeInfo("Microsoft SQL Server") #odbcGetInfo(channel)

redcapUri <- RODBC::sqlQuery(channel, "EXEC Security.prcUri @UriName = 'Redcap1'", stringsAsFactors=FALSE)[1, 'Value']
tokenRoster <- RODBC::sqlQuery(channel, "EXEC [Security].[prcRedcapToken] @RedcapProjectName = 'DatabaseManagementRoster'", stringsAsFactors=FALSE)[1, 'Token']
tokenLog <- RODBC::sqlQuery(channel, "EXEC [Security].[prcRedcapToken] @RedcapProjectName = 'DatabaseManagementLog'", stringsAsFactors=FALSE)[1, 'Token']
RODBC::odbcClose(channel)
 
rm(channel, dsnName)
#############################
### Query REDCap to get the roster of databases
#############################
rawCsvText <- RCurl::postForm(
  uri=redcapUri, 
  token=tokenRoster,
  content='record',
  format='csv', 
  type='flat', 
  .opts=curlOptions(ssl.verifypeer=FALSE)
)
# head(rawCsvText) #Inspect the raw data, if desired.
dsRoster <- read.csv(text=rawCsvText, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
object.size(dsRoster)
# lapply(dsRoster, class)

## Groom some variables
dsRoster$server_type <- factor(dsRoster$server_type, levels=c(1), labels=c("SQL Server"))
dsRoster$should_backup <- as.logical(dsRoster$should_backup)
dsRoster$monitor_row_count <- as.logical(dsRoster$monitor_row_count)
dsRoster$characteristics_complete <- NULL

rm(tokenRoster, rawCsvText)
#############################
### Query REDCap to get the log of the row counts
#############################
rawCsvText <- RCurl::postForm(
  uri=redcapUri, 
  token=tokenLog,
  content='record',
  format='csv', 
  type='flat', 
  .opts=curlOptions(ssl.verifypeer=FALSE)
)
# head(rawCsvText) #Inspect the raw data, if desired.
dsLog <- read.csv(text=rawCsvText, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
# dsRoster$RowID <- as.integer(row.names(dsRoster))
# object.size(dsLog)
# lapply(dsLog, class)

## Groom some variables
dsLog$probe_date <- as.POSIXct(dsLog$probe_date, tz="") #Zero-length character specifies the current time zone.
dsLog$database_monitor_complete <- NULL

rm(tokenLog, rawCsvText, redcapUri)

#############################
### Exclude the undesired tables
#############################
tablesToExclude <- character(0)

for( i in seq_len(nrow(dsRoster)) ) {
  sqlServerTablesToExclude <- unlist(strsplit(dsRoster$tables_to_ignore[i],  ";"))
  tablesToExclude <- c(tablesToExclude, paste0(dsRoster$database[i], ".", sqlServerTablesToExclude))
  rm(sqlServerTablesToExclude)
}
dsLog <- dsLog[!(paste0(dsLog$database, ".", dsLog$table) %in% tablesToExclude), ]
rm(tablesToExclude, i)
