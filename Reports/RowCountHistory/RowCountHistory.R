#This next line is run when the whole file is executed, but not when knitr calls individual chunks.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

## @knitr LoadPackages
############################
require(grid, quietly=TRUE)
require(plyr, quietly=TRUE)
require(ggplot2, quietly=TRUE)
require(scales, quietly=TRUE)
# require(xtable, quietly=TRUE) #For formatting LaTeX and HTML tables

## @knitr DeclareGlobalFunctions
############################

GraphTableHistory <- function( databaseName, tableName ) {
  dsPlot <- dsLog[dsLog$database==databaseName & dsLog$table==tableName, ]
  
  ggplot(dsPlot, aes(x=probe_date, y=row_count, label=change, color=sign_plus)) +
    #geom_text(vjust=-.5) +
    geom_text(hjust=-.4) +
    geom_point() +
    geom_line(mapping=aes(color=sign_minus)) +
    scale_color_gradient2(low="red", mid="gray50", high="blue", guide=FALSE) +
    theme_bw() + 
    labs(title=tableName, x="Probe Data", y="Row Count in Table")
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
dsLog <- plyr::ddply(dsLog, c("database", "table"), transform, 
                     change_plus=c(NA, diff(row_count)), 
                     change_minus=c(diff(row_count), NA), 
                     time_gap_in_seconds=c(NA, diff(probe_date))
                     )

dsLog$time_gap_in_hours <- dsLog$time_gap_in_seconds/(60*60)

dsLog$change_pretty <- scales::comma(dsLog$change_plus)
dsLog$change_pretty <- ifelse(dsLog$change_plus>0, paste0("+", dsLog$change_pretty), dsLog$change_pretty)
dsLog$change_pretty <- ifelse(is.na(dsLog$change_pretty), "", dsLog$change_pretty)
dsLog$sign_plus <- sign(dsLog$change_plus)
dsLog$sign_minus <- sign(dsLog$change_minus)

##Create a table to display the status of the last probe
dsLogLast <- plyr::ddply(dsLog, .variables=c("database", "table"), subset, probe_date==max(probe_date))
# colnames(dsLogLast)
dsLogLast$record_id <- NULL
dsLogLast$change_plus <- NULL
dsLogLast$change_minus <- NULL
dsLogLast$sign_plus <- NULL
dsLogLast$sign_minus <- NULL
dsLogLast$time_gap_in_seconds <- NULL
dsLog <- plyr::rename(dsLog, replace=c("change_pretty"="change"))

dsLogLast <- dsLogLast[order(dsLogLast$database, dsLogLast$table), ]

## @knitr RowCountTable
############################
dsLogLast

## @knitr RowCountGraph
############################
for( databaseName in sort(unique(dsLog$database)) ) {
  cat("\n##", databaseName, " database graphs\n")
  for( tableName in sort(unique(dsLog[dsLog$database==databaseName, 'table'])) ) {
    g <- GraphTableHistory(databaseName, tableName)
    print(g)
  }
}