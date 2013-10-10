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
This report covers records between 2013-08-30 00:30:28 and 2013-10-10 15:55:54.
This report contains information from 2 databases, 34 tables, and 908 records.
```


## Row Count of Each Table of Each Database
The table displays the number of records in each table, and how that count has increased or decreased since the last occasion the table was probed.

Below the table are line graphs that show the history of each database table.  The text above each line is the change since the last probe.


```
   database                        table          probe_date time_gap_in_hours row_count change
1    Autism            dbo.AEPS ADAPTIVE 2013-10-10 15:55:54             14.93         0      0
2    Autism           dbo.AEPS COGNITIVE 2013-10-10 15:55:54             14.93         0      0
3    Autism           dbo.AEPS FINEMOTOR 2013-10-10 15:55:54             14.93         0      0
4    Autism          dbo.AEPS GROSSMOTOR 2013-10-10 15:55:54             14.93         0      0
5    Autism              dbo.AEPS SOCIAL 2013-10-10 15:55:54             14.93         0      0
6    Autism          dbo.AEPS SOCIALCOMM 2013-10-10 15:55:54             14.93         0      0
7    Autism             dbo.Demographics 2013-10-10 15:55:54             14.93        19      0
8    Autism         dbo.Demographics old 2013-10-10 15:55:54             14.93         7      0
9    Autism              dbo.EFdatasheet 2013-10-10 15:55:54             14.93    15,719   +131
10   Autism                   dbo.Mullen 2013-10-10 15:55:54             14.93         0      0
11   Autism      dbo.Satisfaction_Survey 2013-10-10 15:55:54             14.93         0      0
12   Autism          dbo.SkillsChecklist 2013-10-10 15:55:54             14.93         0      0
13   Autism                   dbo.tblABC 2013-10-10 15:55:54             14.93         5      0
14   Autism      dbo.Treatment Questions 2013-10-10 15:55:54             14.93         0      0
15   Autism                 dbo.Vineland 2013-10-10 15:55:54             14.93         0      0
16   Autism                dbo.Vineland2 2013-10-10 15:55:54             14.93         0      0
17    Tfcbt                dbo.tblAgency 2013-10-10 15:55:54             14.93        89      0
18    Tfcbt        dbo.tblAgencyLocation 2013-10-10 15:55:54             14.93       206      0
19    Tfcbt             dbo.tblCallGroup 2013-10-10 15:55:54             14.93        29      0
20    Tfcbt      dbo.tblCallGroupMeeting 2013-10-10 15:55:54             14.93       169      0
21    Tfcbt                  dbo.tblEval 2013-10-10 15:55:54             14.93         0      0
22    Tfcbt  dbo.tblImplementationSurvey 2013-10-10 15:55:54             14.93         0      0
23    Tfcbt             dbo.tblLUDecided 2013-10-10 15:55:54             14.93         3      0
24    Tfcbt              dbo.tblLUGender 2013-10-10 15:55:54             14.93         3      0
25    Tfcbt              dbo.tblLUSource 2013-10-10 15:55:54             14.93         5      0
26    Tfcbt        dbo.tblLUTrainingType 2013-10-10 15:55:54             14.93        10      0
27    Tfcbt             dbo.tblPresenter 2013-10-10 15:55:54             14.93         6      0
28    Tfcbt               dbo.tblSession 2013-10-10 15:55:54             14.93         2      0
29    Tfcbt             dbo.tblTherapist 2013-10-10 15:55:54             14.93       356      0
30    Tfcbt         dbo.tblTherapistEval 2013-10-10 15:55:54             14.93         0      0
31    Tfcbt dbo.tblTherapistGroupMeeting 2013-10-10 15:55:54             14.93         0      0
32    Tfcbt     dbo.tblTherapistTraining 2013-10-10 15:55:54             14.93       485      0
33    Tfcbt              dbo.tblTraining 2013-10-10 15:55:54             14.93        48      0
34    Tfcbt              dbo.tblUclaPtsd 2013-10-10 15:55:54             14.93         0      0
```



## Autism  database graphs
![plot of chunk RowCountGraph](FigureRmd/RowCountGraph1.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph2.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph3.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph4.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph5.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph6.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph7.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph8.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph9.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph10.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph11.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph12.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph13.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph14.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph15.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph16.png) 
## Tfcbt  database graphs
![plot of chunk RowCountGraph](FigureRmd/RowCountGraph17.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph18.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph19.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph20.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph21.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph22.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph23.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph24.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph25.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph26.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph27.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph28.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph29.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph30.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph31.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph32.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph33.png) ![plot of chunk RowCountGraph](FigureRmd/RowCountGraph34.png) 

