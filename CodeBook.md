Codebook
========

Variable list and descriptions
------------------------------

Variable name        | Description
---------------------|------------
subject              | Subject ID, ranging from 1 to 30.
activity             | Activity name (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
feature_Domain       | Time domain or frequency domain signal (Time or Frequency)
feature_Instrument   | Measuring instrument (Accelerometer, Gyroscope)
feature_Acceleration | Acceleration signal (Body or Gravity)
feature_Calc         | Type of calculated data from signals (linear acceleration, angular velocity, linear acceleration Jerk, angular velocity Jerk, linear acceleration magnitude, angular velocity magnitude, linear acceleration Jerk magnitude, angular velocity Jerk magnitude)
feature_Estimation   | Estimation of statistical values (Mean, SD)
feature_Axis         | 3-axial signals in the X, Y and Z directions (X, Y, Z)
count                | Count of data points per group
average              | Average of each variable for each activity and each subject

Dataset structure
-----------------


```r
str(dt_tidy)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  10 variables:
##  $ subject             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity            : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ feature_Domain      : Factor w/ 2 levels "Time","Frequency": 1 1 1 1 1 1 1 1 1 1 ...
##  $ feature_Acceleration: Factor w/ 2 levels "Body","Gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ feature_Instrument  : Factor w/ 2 levels "Accelerometer",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ feature_Calc        : Factor w/ 8 levels "angular velocity",..: 5 5 5 5 5 5 6 6 6 6 ...
##  $ feature_Estimation  : Factor w/ 2 levels "Mean","SD": 1 1 1 2 2 2 1 1 1 2 ...
##  $ feature_Axis        : Factor w/ 4 levels "","X","Y","Z": 2 3 4 2 3 4 2 3 4 2 ...
##  $ count               : int  95 95 95 95 95 95 95 95 95 95 ...
##  $ average             : num  0.2773 -0.0174 -0.1111 -0.2837 0.1145 ...
##  - attr(*, "sorted")= chr  "subject" "activity" "feature_Domain" "feature_Acceleration" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

List the key variables in the data table
----------------------------------------


```r
key(dt_tidy)
```

```
## [1] "subject"              "activity"             "feature_Domain"      
## [4] "feature_Acceleration" "feature_Instrument"   "feature_Calc"        
## [7] "feature_Estimation"   "feature_Axis"
```

Summary of variables
--------------------


```r
summary(dt_tidy)
```

```
##     subject                   activity      feature_Domain
##  Min.   : 1.0   WALKING           :1980   Time     :7200  
##  1st Qu.: 8.0   WALKING_UPSTAIRS  :1980   Frequency:4680  
##  Median :15.5   WALKING_DOWNSTAIRS:1980                   
##  Mean   :15.5   SITTING           :1980                   
##  3rd Qu.:23.0   STANDING          :1980                   
##  Max.   :30.0   LAYING            :1980                   
##                                                           
##  feature_Acceleration     feature_Instrument
##  Body   :10440        Accelerometer:7200    
##  Gravity: 1440        Gyroscope    :4680    
##                                             
##                                             
##                                             
##                                             
##                                             
##                           feature_Calc  feature_Estimation feature_Axis
##  linear acceleration            :3240   Mean:5940           :3240      
##  angular velocity               :2160   SD  :5940          X:2880      
##  linear acceleration Jerk       :2160                      Y:2880      
##  angular velocity Jerk          :1080                      Z:2880      
##  linear acceleration magnitude  :1080                                  
##  angular velocity Jerk magnitude: 720                                  
##  (Other)                        :1440                                  
##      count         average       
##  Min.   :36.0   Min.   :-0.9977  
##  1st Qu.:49.0   1st Qu.:-0.9621  
##  Median :54.5   Median :-0.4699  
##  Mean   :57.2   Mean   :-0.4844  
##  3rd Qu.:63.2   3rd Qu.:-0.0784  
##  Max.   :95.0   Max.   : 0.9745  
## 
```

Save to file
------------

Save data table objects to a tab-delimited text file called `tidy.txt`.


```r
write.table(dt_tidy, file="./tidy.txt", row.name=FALSE, sep="\t", quote=FALSE)
```
