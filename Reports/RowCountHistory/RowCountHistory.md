<!-- Specify the report's official name, goal & description. -->
# Row Counts
**Report Description**: This report helps monitor the activity and (partial) health of the databases.

<!-- Point knitr to the underlying code file so it knows where to look for the chunks. -->



<!-- Load the packages.  Suppress the output when loading packages. --> 



<!-- Load any Global Functions declared in the R file.  Suppress the output. --> 



<!-- Declare any global functions specific to a Rmd output.  Suppress the output. --> 


<!-- Load the dataset.   -->


<!-- Tweak the dataset.   -->




```
## This report covers records between 2013-08-30 00:30:28 and 2013-09-06 11:30:40.
## This report contains information from 1 databases, 37 tables, and 415 records.
```


## Row Count of Each Table of Each Database
The table displays the number of records in each table, and how that count has increased or decreased since the last occasion the table was probed.

Below the table are line graphs that show the history of each database table.  The text above each line is the change since the last probe.


```
##    database                        table          probe_date row_count time_gap_in_hours change_pretty
## 1     Tfcbt                dbo.tblAgency 2013-09-06 11:30:40        86             1.316          -172
## 2     Tfcbt        dbo.tblAgencyLocation 2013-09-06 11:30:40       203             1.316             0
## 3     Tfcbt             dbo.tblCallGroup 2013-09-06 11:30:40        29             1.316             0
## 4     Tfcbt      dbo.tblCallGroupMeeting 2013-09-06 11:30:40       169             1.316             0
## 5     Tfcbt                  dbo.tblEval 2013-09-06 11:30:40         0             1.316             0
## 6     Tfcbt  dbo.tblImplementationSurvey 2013-09-06 11:30:40         0             1.316             0
## 7     Tfcbt             dbo.tblLUDecided 2013-09-06 11:30:40         3             1.316             0
## 8     Tfcbt              dbo.tblLUGender 2013-09-06 11:30:40         3             1.316             0
## 9     Tfcbt              dbo.tblLUSource 2013-09-06 11:30:40         5             1.316             0
## 10    Tfcbt        dbo.tblLUTrainingType 2013-09-06 11:30:40        10             1.316           -20
## 11    Tfcbt             dbo.tblPresenter 2013-09-06 11:30:40         6             1.316           -12
## 12    Tfcbt               dbo.tblSession 2013-09-06 11:30:40         2             1.316            -6
## 13    Tfcbt             dbo.tblTherapist 2013-09-06 11:30:40       223             1.316          -892
## 14    Tfcbt         dbo.tblTherapistEval 2013-09-06 11:30:40         0             1.316             0
## 15    Tfcbt dbo.tblTherapistGroupMeeting 2013-09-06 11:30:40         0             1.316             0
## 16    Tfcbt     dbo.tblTherapistTraining 2013-09-06 11:30:40       341             1.316            +2
## 17    Tfcbt              dbo.tblTraining 2013-09-06 11:30:40        47             1.316          -282
## 18    Tfcbt              dbo.tblUclaPtsd 2013-09-06 11:30:40         0             1.316             0
## 19    Tfcbt                  sysdiagrams 2013-09-06 11:26:49         1                NA              
## 20    Tfcbt                    tblAgency 2013-09-06 11:26:49        86                NA              
## 21    Tfcbt            tblAgencyLocation 2013-09-06 11:26:49       203                NA              
## 22    Tfcbt                 tblCallGroup 2013-09-06 11:26:49        29                NA              
## 23    Tfcbt          tblCallGroupMeeting 2013-09-06 11:26:49       169                NA              
## 24    Tfcbt                      tblEval 2013-09-06 11:26:49         0                NA              
## 25    Tfcbt      tblImplementationSurvey 2013-09-06 11:26:49         0                NA              
## 26    Tfcbt                 tblLUDecided 2013-09-06 11:26:49         3                NA              
## 27    Tfcbt                  tblLUGender 2013-09-06 11:26:49         3                NA              
## 28    Tfcbt                  tblLUSource 2013-09-06 11:26:49         5                NA              
## 29    Tfcbt            tblLUTrainingType 2013-09-06 11:26:49        10                NA              
## 30    Tfcbt                 tblPresenter 2013-09-06 11:26:49         6                NA              
## 31    Tfcbt                   tblSession 2013-09-06 11:26:49         2                NA              
## 32    Tfcbt                 tblTherapist 2013-09-06 11:26:49       223                NA              
## 33    Tfcbt             tblTherapistEval 2013-09-06 11:26:49         0                NA              
## 34    Tfcbt     tblTherapistGroupMeeting 2013-09-06 11:26:49         0                NA              
## 35    Tfcbt         tblTherapistTraining 2013-09-06 11:26:49       341                NA              
## 36    Tfcbt                  tblTraining 2013-09-06 11:26:49        47                NA              
## 37    Tfcbt                  tblUclaPtsd 2013-09-06 11:26:49         0                NA
```


## Tfcbt  database graphs
![plot of chunk RowCountGraph](FigureRmd/RowCountGraph1.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph2.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph3.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph4.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph5.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph6.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph7.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph8.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph9.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph10.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph11.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph12.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph13.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph14.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph15.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph16.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph17.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph18.png) 

```
## Error: range too small for 'min.n'
```

