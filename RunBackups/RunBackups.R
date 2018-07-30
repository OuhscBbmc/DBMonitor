rm(list=ls(all=TRUE))  #Clear the variables from previous runs.  UNcomment this only during testing, or else it will wipe out the calling code's memory.
require(RCurl, quietly=TRUE)
# require(plyr, quietly=TRUE)
# require(reshape2, quietly=TRUE)
# require(lubridate, quietly=TRUE)
# require(stringr, quietly=TRUE)
require(RODBC, quietly=TRUE)

#############################
### Global Declarations & Functions
#############################
compressionExtension <- ".gzip"
# sqlServerTablesToExclude <- c("dtproperties", "sysdiagrams")


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
  .opts=curlOptions(cainfo="./Dal/Certs/ca-bundle.crt")
)
# head(rawCsvText) #Inspect the raw data, if desired.
dsRoster <- read.csv(text=rawCsvText, stringsAsFactors=FALSE) #Convert the raw text to a dataset.
# dsRoster$RowID <- as.integer(row.names(dsRoster))
object.size(dsRoster)

rm(tokenRoster, rawCsvText)

## Groom dsRoster
dsRoster$server_type <- factor(dsRoster$server_type, levels=1, labels=c("SQL Server"))
dsRoster$backup_path <- file.path(dsRoster$backup_path,  strftime(x=Sys.time(), format="%Y-%m-%d_%H-%M-%S"))

#############################
### Build up data.frame of tables from each of the databases
#############################
dsTableName <- NULL
for( i in seq_len(nrow(dsRoster)) ) {
  channel <- RODBC::odbcConnect(dsRoster[i, 'dsn']) 
  RODBC::odbcGetInfo(channel)
  dsTableNameInDatabase <- RODBC::sqlTables(channel, catalog=dsRoster[i, 'database'], tableType="TABLE")
  RODBC::odbcClose(channel)
  
  dsTableNameInDatabase$type <- NULL #This always should be a table, when RODBC::sqlTables is passed " tableType="TABLE" "
  dsTableNameInDatabase$remarks <- NULL #Unlikely to ever be used in this application
  
  sqlServerTablesToExclude <- unlist(strsplit(dsRoster$tables_to_ignore[i],  ";"))
  dsTableNameInDatabase$table <- paste0(dsTableNameInDatabase$TABLE_SCHEM, ".", dsTableNameInDatabase$TABLE_NAME)  
  dsTableNameInDatabase$table_escaped <- paste0("[", dsTableNameInDatabase$TABLE_SCHEM, "].[", dsTableNameInDatabase$TABLE_NAME, "]")  
  dsTableNameInDatabase <- dsTableNameInDatabase[!(dsTableNameInDatabase$table %in% sqlServerTablesToExclude), ]
  
  dsTableName <- rbind(dsTableName, dsTableNameInDatabase)
  
  rm(channel, dsTableNameInDatabase, sqlServerTablesToExclude)  
}
rm(i)

dsTableName <- plyr::rename(dsTableName, replace=c(
  "TABLE_CAT"="database", 
  "TABLE_SCHEM"="schema", 
  "TABLE_NAME"="table_core"#, 
#   "TABLE_TYPE"="type", 
#   "REMARKS"="remarks"
))

dsRosterAndTable <- plyr::join(x=dsRoster, y=dsTableName, by="database", type="left", match="all")
dsRosterAndTable$table_file_safe <- gsub(pattern="\\.", replacement="_", x=dsRosterAndTable$table)
dsRosterAndTable$backup_path <- paste0(file.path(dsRosterAndTable$backup_path, dsRosterAndTable$table_file_safe), ".csv", compressionExtension)

#############################
### Create a directory for each database's backups
#############################
for( i in seq_len(nrow(dsRoster)) ) {
  dir.create(dsRoster$backup_path[i])  
}

#############################
### Backup each table
#############################
for( i in seq_len(nrow(dsRosterAndTable)) ) {
  cnnString <- paste0("driver={SQL Server};server=", dsRosterAndTable[i, 'server'], ";database=", dsRosterAndTable[i, 'database'], ";trusted_connection=true")
  channel <- RODBC::odbcDriverConnect(cnnString) #RODBC::odbcGetInfo(channel)
  
  dsFresh <- RODBC::sqlFetch(channel, sqtable=dsRosterAndTable[i, 'table'], stringsAsFactors=F)
  RODBC::odbcClose(channel)
  
  write.csv(dsFresh, file=gzfile(dsRosterAndTable$backup_path[i]))
  
  rm(channel, dsFresh)  
}
rm(i)
