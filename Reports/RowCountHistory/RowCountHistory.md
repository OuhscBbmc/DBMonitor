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
## This report covers records between 2013-08-30 00:30:28 and 2013-09-12 20:43:12.
## This report contains information from 2 databases, 53 tables, and 553 records.
```


## Row Count of Each Table of Each Database
The table displays the number of records in each table, and how that count has increased or decreased since the last occasion the table was probed.

Below the table are line graphs that show the history of each database table.  The text above each line is the change since the last probe.


```
##    database                        table          probe_date row_count time_gap_in_hours change_pretty
## 1    Autism            dbo.AEPS ADAPTIVE 2013-09-12 20:43:12         0            0.7484             0
## 2    Autism           dbo.AEPS COGNITIVE 2013-09-12 20:43:12         0            0.7484             0
## 3    Autism           dbo.AEPS FINEMOTOR 2013-09-12 20:43:12         0            0.7484             0
## 4    Autism          dbo.AEPS GROSSMOTOR 2013-09-12 20:43:12         0            0.7484             0
## 5    Autism              dbo.AEPS SOCIAL 2013-09-12 20:43:12         0            0.7484             0
## 6    Autism          dbo.AEPS SOCIALCOMM 2013-09-12 20:43:12         0            0.7484             0
## 7    Autism             dbo.Demographics 2013-09-12 20:43:12        19            0.7484             0
## 8    Autism         dbo.Demographics old 2013-09-12 20:43:12         7            0.7484             0
## 9    Autism              dbo.EFdatasheet 2013-09-12 20:43:12     13785            0.7484             0
## 10   Autism                   dbo.Mullen 2013-09-12 20:43:12         0            0.7484             0
## 11   Autism      dbo.Satisfaction_Survey 2013-09-12 20:43:12         0            0.7484             0
## 12   Autism          dbo.SkillsChecklist 2013-09-12 20:43:12         0            0.7484             0
## 13   Autism                   dbo.tblABC 2013-09-12 20:43:12         5            0.7484             0
## 14   Autism      dbo.Treatment Questions 2013-09-12 20:43:12         0            0.7484             0
## 15   Autism                 dbo.Vineland 2013-09-12 20:43:12         0            0.7484             0
## 16   Autism                dbo.Vineland2 2013-09-12 20:43:12         0            0.7484             0
## 17    Tfcbt                dbo.tblAgency 2013-09-12 20:43:12        86           44.9050             0
## 18    Tfcbt        dbo.tblAgencyLocation 2013-09-12 20:43:12       203           44.9050             0
## 19    Tfcbt             dbo.tblCallGroup 2013-09-12 20:43:12        29           44.9050             0
## 20    Tfcbt      dbo.tblCallGroupMeeting 2013-09-12 20:43:12       169           44.9050             0
## 21    Tfcbt                  dbo.tblEval 2013-09-12 20:43:12         0           44.9050             0
## 22    Tfcbt  dbo.tblImplementationSurvey 2013-09-12 20:43:12         0           44.9050             0
## 23    Tfcbt             dbo.tblLUDecided 2013-09-12 20:43:12         3           44.9050             0
## 24    Tfcbt              dbo.tblLUGender 2013-09-12 20:43:12         3           44.9050             0
## 25    Tfcbt              dbo.tblLUSource 2013-09-12 20:43:12         5           44.9050             0
## 26    Tfcbt        dbo.tblLUTrainingType 2013-09-12 20:43:12        10           44.9050             0
## 27    Tfcbt             dbo.tblPresenter 2013-09-12 20:43:12         6           44.9050             0
## 28    Tfcbt               dbo.tblSession 2013-09-12 20:43:12         2           44.9050             0
## 29    Tfcbt             dbo.tblTherapist 2013-09-12 20:43:12       235           44.9050            +2
## 30    Tfcbt         dbo.tblTherapistEval 2013-09-12 20:43:12         0           44.9050             0
## 31    Tfcbt dbo.tblTherapistGroupMeeting 2013-09-12 20:43:12         0           44.9050             0
## 32    Tfcbt     dbo.tblTherapistTraining 2013-09-12 20:43:12       344           44.9050             0
## 33    Tfcbt              dbo.tblTraining 2013-09-12 20:43:12        47           44.9050             0
## 34    Tfcbt              dbo.tblUclaPtsd 2013-09-12 20:43:12         0           44.9050             0
## 35    Tfcbt                  sysdiagrams 2013-09-06 11:26:49         1                NA              
## 36    Tfcbt                    tblAgency 2013-09-06 11:26:49        86                NA              
## 37    Tfcbt            tblAgencyLocation 2013-09-06 11:26:49       203                NA              
## 38    Tfcbt                 tblCallGroup 2013-09-06 11:26:49        29                NA              
## 39    Tfcbt          tblCallGroupMeeting 2013-09-06 11:26:49       169                NA              
## 40    Tfcbt                      tblEval 2013-09-06 11:26:49         0                NA              
## 41    Tfcbt      tblImplementationSurvey 2013-09-06 11:26:49         0                NA              
## 42    Tfcbt                 tblLUDecided 2013-09-06 11:26:49         3                NA              
## 43    Tfcbt                  tblLUGender 2013-09-06 11:26:49         3                NA              
## 44    Tfcbt                  tblLUSource 2013-09-06 11:26:49         5                NA              
## 45    Tfcbt            tblLUTrainingType 2013-09-06 11:26:49        10                NA              
## 46    Tfcbt                 tblPresenter 2013-09-06 11:26:49         6                NA              
## 47    Tfcbt                   tblSession 2013-09-06 11:26:49         2                NA              
## 48    Tfcbt                 tblTherapist 2013-09-06 11:26:49       223                NA              
## 49    Tfcbt             tblTherapistEval 2013-09-06 11:26:49         0                NA              
## 50    Tfcbt     tblTherapistGroupMeeting 2013-09-06 11:26:49         0                NA              
## 51    Tfcbt         tblTherapistTraining 2013-09-06 11:26:49       341                NA              
## 52    Tfcbt                  tblTraining 2013-09-06 11:26:49        47                NA              
## 53    Tfcbt                  tblUclaPtsd 2013-09-06 11:26:49         0                NA
```



## Autism  database graphs
![plot of chunk RowCountGraph](FigureRmd/RowCountGraph1.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph2.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph3.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph4.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph5.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph6.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph7.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph8.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph9.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph10.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph11.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph12.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph13.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph14.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph15.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph16.png) 
## Tfcbt  database graphs
![plot of chunk RowCountGraph](FigureRmd/RowCountGraph17.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph18.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph19.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph20.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph21.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph22.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph23.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph24.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph25.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph26.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph27.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph28.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph29.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph30.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph31.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph32.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph33.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph34.png) 

```
## Error: range too small for 'min.n'
```

