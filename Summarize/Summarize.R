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
### Retrieve token and REDCap URL
#############################


# sql <- "SELECT sysobjects.Name, sysindexes.Rows FROM sysobjects INNER JOIN sysindexes ON sysobjects.id = sysindexes.id WHERE type = 'U'AND sysindexes.IndId < 2"
sql <- "SELECT SCHEMA_NAME(A.schema_id) + '.' + A.Name as [table], SUM(B.rows) AS 'row_count' FROM sys.objects A INNER JOIN sys.partitions B ON A.object_id = B.object_id WHERE A.type = 'U' GROUP BY A.schema_id, A.Name"
# listOfDs <- list()
dsBig <- NULL
for( i in seq_len(nrow(dsRoster)) ) {
  channel <- RODBC::odbcConnect(dsRoster[i, 'dsn']) 
#   RODBC::getSqlTypeInfo("Microsoft SQL Server") 
  RODBC::odbcGetInfo(channel)
#   tableList <- RODBC::sqlTables(channel, catalog=dsRoster[i, 'database'], tableType="TABLE")
  
  stopifnot(dsRoster[i, 'dsn'] != "SQL Server" ) #Currently, only SQL Server is supported
  #sql_specific <- paste("USE", dsRoster[i, 'database'], " ", sql)  
  RODBC::sqlQuery(channel, paste("USE", dsRoster[i, 'database']))
  dsRows <- RODBC::sqlQuery(channel, sql)
  RODBC::odbcClose(channel)
  
  dsRows$probe_date <- Sys.time()
  dsRows$database <-  dsRoster[i, 'database']
  #listOfDs <- c(listOfDs, dsRows)
  dsBig <- rbind(dsBig, dsRows)
  rm(channel, dsRows)  
}

# dsAllRows <- plyr::join_all()
dsBig <- dsBig[, c("database", "table", "probe_date", "row_count")] #"record_id", 
#csvBig <- write.csv(dsBig)
# con <- textConnection()
# csvAllRos <- readLines()

# a <- ""
# write.csv(dsBig, file=a)

# t <- tempfile()
# write.csv(dsBig[1, ], file=t, quote=F, row.names=T)
# csv <- readLines(con=t )[1:3]
# unlink(t)
# 
# xml <- "
# <?xml version=\"1.0\" encoding=\"UTF-8\" ?>
# <records> 
#   <item>
#     <record_id>1</record_id>
#     <database>Tfcbt</database>
#     <table>dbo.dtproperties</table>
#     <probe_date>2013-08-29 23:37:18</probe_date>
#     <row_count>0/row_count>
#   </item> 
# </records>
# "
#   
# 
# #############################
# ### Write to REDCap with API
# #############################
# #Call REDCap
# m <- RCurl::postForm(
#   uri=redcapUri, 
#   token=tokenLog,
#   content='record',
#   format='xml', 
#   type='flat', 
#   overwriteBehavior='normal',
#   data=xml,
#   .opts=curlOptions(ssl.verifypeer=FALSE)
# )
# 
# 
# # head(rawCsvText) #Inspect the raw data, if desired.
# ds <- read.csv(text=rawCsvText, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
# ds$RowID <- as.integer(row.names(ds))
# object.size(ds)
# 
# rm(redcapUri, tokenLog, rawCsvText)
# 