#This next line is run when the whole file is executed, but not when knitr calls individual chunks.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

## @knitr LoadPackages
############################
require(grid, quietly=TRUE)
require(plyr, quietly=TRUE)
require(ggplot2, quietly=TRUE)
require(scales, quietly=TRUE)
require(lubridate, quietly=TRUE)
suppressPackageStartupMessages(require(googleVis))
# require(xtable, quietly=TRUE) #For formatting LaTeX and HTML tables

## @knitr DeclareGlobalFunctions
############################
integer_breaks <- function(n = 5, ...) {
  #from http://stackoverflow.com/questions/10558918/ggplot-2-facet-grid-free-y-but-forcing-y-axis-to-be-rounded-to-nearest-whole-n
  breaker <- pretty_breaks(n, ...)
  function(x) {
    breaks <- breaker(x)
    breaks <- breaks[breaks == floor(breaks)]
    
#     if( length(breaks) == 1 ) 
#       breaks <- breaks + -1:1 #It doesn't expand the scale
#     print(breaks)
    return( breaks )
  }
}
GraphTableHistoryGG <- function( databaseName, tableName ) {
  dsPlot <- dsLog[dsLog$database==databaseName & dsLog$table==tableName, ]
  
  g <- ggplot(dsPlot, aes(x=probe_date, y=row_count, label=change_pretty, color=sign_plus)) +
    #geom_text(vjust=-.5) +
    geom_text(hjust=-.4, vjust=1.2) +
    geom_point() +
    geom_line(mapping=aes(color=sign_minus)) +
    scale_y_continuous(breaks=integer_breaks(), expand=c(.2, 2)) +
    scale_color_gradient2(low="red", mid="gray70", high="blue", guide=FALSE) +
    theme_bw() + 
    labs(title=tableName, x="Probe Date", y="Row Count in Table")
  print(g)
}
GraphTableHistoryGV <- function( databaseName, tableName ) {
  dsPlot <- dsLog[dsLog$database==databaseName & dsLog$table==tableName, ]
  optionsList <- list(
      colors="['blue', 'lightblue']",
      zoomStartTime=min(dsPlot$probe_date),
      zoomEndTime=as.Date(Sys.time() ),
      legendPosition='newRow',
      width=600, height=200, #scaleColumns='[0,1]',
      scaleType='allmaximized')
  
  cat("\n####", tableName,"\n")
  g <- gvisAnnotatedTimeLine(dsPlot, datevar="probe_date",
                        numvar="row_count",# idvar="Type",
                        options=optionsList)
  googleVis:::print.gvis(g, tag="chart")
                        
}
## @knitr LoadDS
############################
# { #This bracket permits the 'else' clause (because it's located on the top layer of the code.)
#   if( basename(getwd()) == "DBMonitor" ) {#This clause executes when run from the *.R file.
#     pathDirectoryCode <- file.path(getwd(), "Dal", "DualTM.R")
#   }
#   else if( basename(getwd()) == "RowCountHistory" ) {#This clause executes when run from the *.Rmd/Rnw file.
#     pathDirectoryCode <- file.path(dirname(dirname(getwd())), "Dal", "DualTM.R")
#   }
#   else {
#     stop(paste0("The working directory '", basename(getwd()),"' was not anticipated.  If appropriate, please go near the top of the 'RowCountHistory.R' code and add this new location."))
#   }
# }
pathDirectoryCode <- "./Dal/DualTM.R"

if( !file.exists(pathDirectoryCode) ) stop(paste0("The file '", pathDirectoryCode, "' could not be found.  Check the path.  For this to work correctly, the 'MReporting.Rproj' needed to be opend in RStudio.  Otherwise the working directory."))
source(pathDirectoryCode)
if( is.null(dsRoster) ) stop("The extracting code did not run properly.  The data.frame 'dsRoster' should not be null.")
if( is.null(dsLog) ) stop("The extracting code did not run properly.  The data.frame 'dsLog' should not be null.")
rm(pathDirectoryCode)

## @knitr TweakDS
############################
SummarizeTableRecords <- function( df ) {
#   print(df$table)
#   print(df$probe_date)
#   print(diff(df$probe_date))
  
  df <- df[order(df$probe_date), ]
  df$change_plus=c(NA, diff(df$row_count)) 
  df$change_minus=c(diff(df$row_count), NA)
  #df$time_gap_in_seconds=c(NA, diff(df$probe_date)) #This way doesn't guarantee what the differences will be (eg, seconds, minutes, days, etc)
  df$time_gap_in_hours=c(NA, lubridate::int_length(lubridate::int_diff(df$probe_date))/(60*60))
  return( df )  
}
dsLog <- plyr::ddply(dsLog, c("database", "table"), SummarizeTableRecords) 
                     
# dsLog <- plyr::ddply(dsLog, c("database", "table"), transform, 
#                      change_plus=c(NA, diff(row_count)), 
#                      change_minus=c(diff(row_count), NA), 
#                      time_gap_in_seconds=c(NA, diff(probe_date))
#                      )

dsLog$row_count_pretty <- scales::comma(dsLog$row_count)
dsLog$change_pretty <- scales::comma(dsLog$change_plus)
dsLog$change_pretty <- ifelse(dsLog$change_plus>0, paste0("+", dsLog$change_pretty), dsLog$change_pretty)
dsLog$change_pretty <- ifelse(is.na(dsLog$change_pretty), "", dsLog$change_pretty)
dsLog$sign_plus <- sign(dsLog$change_plus)
dsLog$sign_minus <- sign(dsLog$change_minus)

##Create a table to display the status of the last probe
dsLogLast <- plyr::ddply(dsLog, .variables=c("database", "table"), subset, probe_date==max(probe_date))
# colnames(dsLogLast)
dsLogLast$record_id <- NULL
dsLogLast$row_count <- NULL
dsLogLast$change_plus <- NULL
dsLogLast$change_minus <- NULL
dsLogLast$sign_plus <- NULL
dsLogLast$sign_minus <- NULL
dsLogLast <- plyr::rename(dsLogLast, replace=c(
  "change_pretty"="change",
  "row_count_pretty"="row_count"
  ))

dsLogLast <- dsLogLast[order(dsLogLast$database, dsLogLast$table), ]

## @knitr RowCountTable
############################
dsLogLast

## @knitr RowCountGraph
############################
for( databaseName in sort(unique(dsLog$database)) ) {
  cat("\n##", databaseName, " database graphs\n")
  for( tableName in sort(unique(dsLog[dsLog$database==databaseName, 'table'])) ) {
    GraphTableHistoryGG(databaseName, tableName)
#     GraphTableHistoryGV(databaseName, tableName)
  }
}
# GraphTableHistory("Tfcbt", "dbo.tblPresenter")
# GraphTableHistory("Tfcbt", "dbo.tblLUGender")
# GraphTableHistory("Tfcbt", "dbo.tblTherapist")
# dsSingle$probe_date
# dsSingle <- dsLog[dsLog$database=="Tfcbt" & dsLog$table=="dbo.tblTherapist", ]
# # dsSingle$probe_date <- as.Date(dsSingle$probe_date)
# 
# g <- gvisAnnotatedTimeLine(dsSingle, datevar="probe_date",
#                            numvar="row_count",# idvar="Type",
#                             
#                            options=list(
#                              colors="['blue', 'lightblue']",
#                              zoomStartTime=min(dsSingle$probe_date),
#                              zoomEndTime=as.Date(Sys.time() ),
#                              legendPosition='newRow',
#                              width=600, height=200, #scaleColumns='[0,1]',
#                              scaleType='allmaximized')
# )
# 
# plot(g)