#This next line is run when the whole file is executed, but not when knitr calls individual chunks.
rm(list=ls(all=TRUE)) #Clear the memory for any variables set from any previous runs.

## @knitr LoadPackages
############################
require(grid, quietly=TRUE)
require(plyr, quietly=TRUE)
# require(reshape2, quietly=TRUE)
# require(lubridate, quietly=TRUE)
# require(stringr, quietly=TRUE)
require(ggplot2, quietly=TRUE)
require(scales, quietly=TRUE)
# require(xtable, quietly=TRUE) #For formatting LaTeX and HTML tables
# require(mgcv, quietly=TRUE) #For the Generalized Additive Model that smooths the longitudinal graphs.

## @knitr DeclareGlobalFunctions
############################
# directoryForIsolatedGraphs <- "./OsdhReports/FedSiteVisit/Graphics"

ActivityHistogram <- function( dsPlot, responseName="Count", binwidth=NULL, title=NULL, xLabel=NULL, yLabel=NULL, roundedDigits=0) {
  dsMidPoints <- data.frame(Label=c("italic(X)[50]", "bar(italic(X))"), stringsAsFactors=F)  
  dsMidPoints$Value <- c(median(dsPlot[, responseName]), mean(dsPlot[, responseName]))
  dsMidPoints$ValueRounded <- round(dsMidPoints$Value, roundedDigits)
  
  g <- ggplot(dsPlot, aes_string(x=responseName)) 
  g <- g + geom_bar(stat="bin", binwidth=binwidth, fill="gray70", color="gray90" )
  g <- g + geom_vline(xintercept=dsMidPoints$Value, color="gray30")
  g <- g + geom_text(data=dsMidPoints, aes(x=Value, y=0, label=ValueRounded), color="red", hjust=c(1, 0), vjust=.5)
  g <- g + scale_x_continuous(labels=comma_format())
  g <- g + scale_y_continuous(labels=comma_format())
  g <- g + labs(title=title, x=xLabel, y=yLabel)
  g <- g + theme_bw()
  dsMidPoints$Top <- quantile(ggplot_build(g)$panel$ranges[[1]]$y.range, .8)
  g <- g + geom_text(data=dsMidPoints, aes(x=Value, y=Top, label=Label), color="red", hjust=c(1, 0), parse=T)
  return( g )  
}
ActivityScatter <- function( dsplot, xName=NULL, colorName=NULL, responseName="Count", sizeName=NULL, title=NULL, xLabel=NULL, yLabel=NULL, log10Scale=TRUE ) {
  g <- ggplot(dsplot, aes_string(x=xName, y=responseName, label=xName, color=colorName, size=sizeName) )
  g <- g + geom_text()
  if( log10Scale ) {
    g <- g + scale_y_continuous(labels=comma_format(), trans="log10", breaks=c(1, 5, 10, 50, 100, 500,  1000, 5000 ))
    g <- g + annotation_logticks(sides="l")
  }
  if( !log10Scale ) {
    g <- g + scale_y_continuous(labels=percent_format())
  }
  g <- g + scale_size_manual(values=c(3, 5))
  g <- g + guides(colour="none", size="none")
  g <- g + labs(title=title, x=xLabel, y=yLabel)
  g <- g + theme_bw()
  return( g )
}
ActivityEachMonth <- function( dsPlot, colorVariable=NULL, monthVariable="Month", responseVariable="Count", title=NULL, xLabel=NULL, yLabel=NULL ) {
  g <- ggplot(dsPlot, aes_string(x=monthVariable, y=responseVariable, colour=colorVariable))
  g <- g + geom_line(stat="identity", alpha=.5) 
#   g <- g + geom_line(stat="identity", alpha=1)
  g <- g + geom_hline(yintercept=c(median(dsPlot[, responseVariable]), mean(dsPlot[, responseVariable])), color="gray50")
  g <- g + geom_boxplot(aes_string(group=monthVariable), outlier.colour=NA)
  g <- g + geom_smooth(aes(group=1), method="gam", formula=y ~ s(x, bs = "cs"), color="gray30")
  g <- g + scale_x_date(breaks="1 year", labels=date_format("%b %Y"))
  g <- g + scale_y_continuous(labels=comma_format())
  g <- g + guides(colour="none")
  g <- g + labs(title=title, x=xLabel, y=yLabel)
  g <- g + theme_bw()
  return( g )
}
# FillInMonthsForGroups <- function( dsToFillIn, groupVariable, monthVariable, dvNames, startMonth, stopMonth ){
#   possibleMonths <- seq.Date(from=startMonth, to=stopMonth, by="month")
#   groupLevels <- sort(unique(dsToFillIn[, groupVariable]))
#   lubridate::day(possibleMonths) <- 15
#   dsEmpty <- data.frame(Month=rep(possibleMonths, each=length(groupLevels)), Group=rep(groupLevels, times=length(possibleMonths)), stringsAsFactors=FALSE) 
#   
#   dsToFillIn <-  merge(x=dsToFillIn, y=dsEmpty, by.x=c(monthVariable, groupVariable), by.y=c("Month", "Group"), all.y=TRUE)
#   for( dvName in dvNames ) {
#     dsToFillIn[is.na(dsToFillIn[, dvName]), dvName] <- 0  
#   }
#   return( dsToFillIn )
# }
## @knitr LoadDS
############################
{ #This bracket permits the 'else' clause (because it's located on the top layer of the code.)
  if( basename(getwd()) == "DBMonitor" ) #This clause executes when run from the *.R file.
    pathDirectoryCode <- file.path(getwd(), "Dal", "DualTM.R")
  else if( basename(getwd()) == "RowCountHistory" ) #This clause executes when run from the *.Rmd/Rnw file.
    pathDirectoryCode <- file.path(dirname(dirname(getwd())), "Dal", "DualTM.R")
  else
    stop(paste0("The working directory '", basename(getwd()),"' was not anticipated.  If appropriate, please go near the top of the 'RowCountHistory.R' code and add this new location."))
}

if( !file.exists(pathDirectoryCode) ) stop(paste0("The file '", pathDirectoryCode, "' could not be found.  Check the path.  For this to work correctly, the 'MReporting.Rproj' needed to be opend in RStudio.  Otherwise the working directory."))
source(pathDirectoryCode)
if( is.null(dsRoster) ) stop("The extracting code did not run properly.  The data.frame 'dsRoster' should not be null.")
if( is.null(dsLog) ) stop("The extracting code did not run properly.  The data.frame 'dsLog' should not be null.")
rm(pathDirectoryCode)

## @knitr TweakDS
############################
dsLog <- plyr::ddply(dsLog, c("database", "table"), transform, change_plus=c(NA, diff(row_count)), change_minus=c(diff(row_count), NA))
dsLog$change_pretty <- scales::comma(dsLog$change_plus)
dsLog$change_pretty <- ifelse(dsLog$change_plus>0, paste0("+", dsLog$change_pretty), dsLog$change_pretty)
dsLog$change_pretty <- ifelse(is.na(dsLog$change_pretty), "", dsLog$change_pretty)
dsLog$sign_plus <- sign(dsLog$change_plus)
dsLog$sign_minus <- sign(dsLog$change_minus)

# diff(dsLog$row_count)


## @knitr RowCount
############################

databaseName <- "Tfcbt"
# tableName <- "dbo.tblTherapist"
# tableName <- "dbo.tblLUGender"



for( tableName in unique(dsLog$table) ) {
  dsPlot <- dsLog[dsLog$database==databaseName & dsLog$table==tableName, ]
  
#   dsPlot <- dsTable
  g <- ggplot(dsPlot, aes(x=probe_date, y=row_count, label=change_pretty, color=sign_plus)) +
    #geom_text(vjust=-.5) +
    geom_text(hjust=-.4) +
    geom_point() +
    geom_line(mapping=aes(color=sign_minus)) +
  #   scale_color_gradient2(mid="gray50") +
    scale_color_gradient2(low="red", mid="gray50", high="blue", guide=FALSE) +
    theme_bw() + 
    labs(title=tableName, x="Probe Data", y="Row Count in Table")
  print(g)
}

# 
# g <- ActivityEachMonth(dsCountyMonth, colorVariable="CountyIDF", responseVariable="ReferralCount", 
#                        title="Monthly Referrals for each County", x=NULL, y="Number of Referrals per Month")
# g
# g + coord_cartesian(ylim=c(0, 20)) + labs(title="Monthly Referrals for each County (zoomed)")

# ggsave(filename="ReferralsOverTime.png", width=4.5, height=3.5, units="in", dpi=300, path=directoryForIsolatedGraphs); dev.off()
# rm(g)