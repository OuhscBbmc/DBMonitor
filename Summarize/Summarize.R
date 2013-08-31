rm(list=ls(all=TRUE))  #Clear the variables from previous runs.  UNcomment this only during testing, or else it will wipe out the calling code's memory.
require(RCurl, quietly=TRUE)
require(plyr, quietly=TRUE)
# require(reshape2, quietly=TRUE)
require(lubridate, quietly=TRUE)
require(stringr, quietly=TRUE)
require(RODBC, quietly=TRUE)

#############################
### Global Declarations & Functions
#############################
# databaseNames <- c("Tfcbt")
dsRoster <- data.frame(Database=NA_character_, DsnName=NA_character_, BackupPath=NA_character_, stringsAsFactors=F)
dsRoster[1, ] <- c("Tfcbt", "PedsISDB", "")

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
dsRoster$RowID <- as.integer(row.names(dsRoster))
object.size(dsRoster)

rm(tokenRoster, rawCsvText)

## Groom dsRoster
dsRoster$server_type <- factor(dsRoster$server_type, levels=1, labels=c("SQL Server"))

#############################
### Query REDCap to get the largest record_id value
#############################
rawCsvText <- RCurl::postForm(
  uri=redcapUri, 
  token=tokenLog,
  content='record',
  format='csv', 
  type='flat', 
  fields=c("record_id"), 
  .opts=curlOptions(ssl.verifypeer=FALSE)
)
# head(rawCsvText) #Inspect the raw data, if desired.
dsRecordIDs <- read.csv(text=rawCsvText, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
maxRecordID <- max(as.integer(dsRecordIDs$record_id))
object.size(dsRecordIDs)

rm(dsRecordIDs, rawCsvText)

#############################
### Retrieve Row Counts from the databases
#############################
#http://stackoverflow.com/questions/2221555/how-to-fetch-the-row-count-for-all-tables-in-a-sql-server-database
sql <- "SELECT SCHEMA_NAME(A.schema_id) + '.' + A.Name as [table], SUM(B.rows) AS 'row_count' FROM sys.objects A INNER JOIN sys.partitions B ON A.object_id = B.object_id WHERE A.type = 'U' GROUP BY A.schema_id, A.Name"
dsRow <- NULL
for( i in seq_len(nrow(dsRoster)) ) {
  channel <- RODBC::odbcConnect(dsRoster[i, 'dsn']) 
  RODBC::odbcGetInfo(channel)
#   dsTableList <- RODBC::sqlTables(channel, catalog=dsRoster[i, 'database'], tableType="TABLE")
  
  stopifnot(dsRoster[i, 'dsn'] != "SQL Server" ) #Currently, only SQL Server is supported
  RODBC::sqlQuery(channel, paste("USE", dsRoster[i, 'database']))
  dsRowCountInDatabase <- RODBC::sqlQuery(channel, sql)
  RODBC::odbcClose(channel)
  
  dsRowCountInDatabase$probe_date <- Sys.time()
  dsRowCountInDatabase$database <-  dsRoster[i, 'database']
  dsRow <- rbind(dsRow, dsRowCountInDatabase)
  rm(channel, dsRowCountInDatabase)  
}
rm(dsRoster, sql, i)

dsRow$record_id <- seq_len(nrow(dsRow)) + maxRecordID
dsRow <- dsRow[, c("record_id", "database", "table", "probe_date", "row_count")] #"record_id", 

#Approach #1 for converting to csv elements
# t <- tempfile()
# write.csv(dsBig[, ], file=t, quote=F, row.names=F)
# csvElements <- readLines(con=t )[]
# unlink(t)

#Approach #2 for converting to csv elements
# http://comments.gmane.org/gmane.comp.lang.r.general/274735
# http://stackoverflow.com/questions/12393004/parsing-back-to-messy-api-strcuture/12435389#12435389
write.csv(dsRow, textConnection('csvElements', 'w'), row.names = FALSE)

#Convert vector of csv elements to one long CSV string
csv <- paste(csvElements, collapse="\n")
rm(dsRow, csvElements, maxRecordID)

#############################
### Write to REDCap with API
#############################
recordsAffected <- RCurl::postForm(
  uri=redcapUri, 
  token=tokenLog,
  content='record',
  format='csv', 
  type='flat', 
  overwriteBehavior='normal',
  data=csv,
  .opts=curlOptions(ssl.verifypeer=FALSE)
)
message(paste("Records written & updated to REDCap:", as.integer(recordsAffected)))
rm(csv, recordsAffected)
#############################
### Read from REDCap  if you want to verify
#############################
# rawCsvText <- RCurl::postForm(
#   uri=redcapUri, 
#   token=tokenLog,
#   content='record',
#   format='csv', 
#   type='flat', 
#   .opts=curlOptions(ssl.verifypeer=FALSE)
# )
# # head(rawCsvText) #Inspect the raw data, if desired.
# dsLog <- read.csv(text=rawCsvText, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
# object.size(dsLog)
# rm(dsLog, rawCsvText, redcapUri)

rm(tokenLog)
