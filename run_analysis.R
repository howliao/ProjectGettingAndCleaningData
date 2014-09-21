## create "data" directory under the working directory
if(!file.exists("./data")){dir.create("./data")} 

## download data to "data" folder and named it as "Dataset.zip"
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
download.file(dataUrl, destfile="./data/Dataset.zip", method="curl")  

## extract the downloaded .zip file and put them under the "data" directory
unzip("./data/Dataset.zip", exdir="./data")  

## use "data.table" and "reshape2" packages
sapply(c("data.table", "reshape2"), require, character.only=TRUE, quietly=TRUE)

## list extracted files
pathEx <- file.path("./data", "UCI HAR Dataset")
list.files(pathEx, recursive=TRUE)

## read the files
## subject files
SubjTrain <- fread("./data/UCI HAR Dataset/train/subject_train.txt")
SubjTest <- fread("./data/UCI HAR Dataset/test/subject_test.txt")
## activity label files
ActlTrain <- fread("./data/UCI HAR Dataset/train/y_train.txt")
ActlTest <- fread("./data/UCI HAR Dataset/test/y_test.txt")
## measure data files, fread() doesn't work with these files
## read.table() load the data into data frame, then data.table() converts it to data table
MeasTrain <- data.table(read.table("./data/UCI HAR Dataset/train/X_train.txt"))
MeasTest <- data.table(read.table("./data/UCI HAR Dataset/test/X_test.txt"))

## Merge the training and the test sets
## subject data table, append test beneath train, rename the only variable to "subject"
Subj_TT <- rbind(SubjTrain, SubjTest)
setnames(Subj_TT, "V1", "subject")
## activity lable data table, append test beneath train, rename the only variable to "activity"
Actl_TT <- rbind(ActlTrain, ActlTest)
setnames(Actl_TT, "V1", "activity")
## measure data table, append test beneath train
Meas_TT <- rbind(MeasTrain, MeasTest)

## Extracts only the mean and standard deviation measurements
## get feature/variable names and their position index from feature.txt file
Feature <- fread("./data/UCI HAR Dataset/features.txt")
setnames(Feature, c("V1", "V2"), c("featureIndex", "featureName"))
## get feature index of those features that has either "mean()" or "std()" in their names
Index_mean <- grep("mean\\(\\)", Feature$featureName)
Index_std <- grep("std\\(\\)", Feature$featureName)
Index <- sort(c(Index_mean, Index_std))
## compose colume name by paste()
col_name <- paste("V", Index, sep="")
## subset measure data table by these columns
Meas_TT_ms <- Meas_TT[, col_name, with=FALSE]

## replace activity label with descriptive activity name
Actl_TT$activity <- gsub("1", "WALKING", Actl_TT$activity)
Actl_TT$activity <- gsub("2", "WALKING_UPSTAIRS", Actl_TT$activity)
Actl_TT$activity <- gsub("3", "WALKING_DOWNSTAIRS", Actl_TT$activity)
Actl_TT$activity <- gsub("4", "SITTING", Actl_TT$activity)
Actl_TT$activity <- gsub("5", "STANDING", Actl_TT$activity)
Actl_TT$activity <- gsub("6", "LAYING", Actl_TT$activity)
Actl_TT$activity <- factor(Actl_TT$activity, levels=c("WALKING", "WALKING_UPSTAIRS", 
                                                      "WALKING_DOWNSTAIRS", "SITTING", 
                                                      "STANDING", "LAYING"))

## label the measure data table with descriptive variable names
Feature$featureName <- gsub("\\(\\)", "", Feature$featureName)
Feature$featureName <- gsub("^t", "Time", Feature$featureName)
Feature$featureName <- gsub("^f", "Freq", Feature$featureName)
Feature$featureName <- gsub("Acc", "Accelerometer", Feature$featureName)
Feature$featureName <- gsub("Gyro", "Gyroscope", Feature$featureName)
Feature$featureName <- gsub("Mag", "Magnitude", Feature$featureName)
var_name <- Feature$featureName[Index]
setnames(Meas_TT_ms, col_name, var_name)

## combine the three data tables for subject, activity and measurement data into one
dt <- cbind(Subj_TT, Actl_TT, Meas_TT_ms)

## melt data to reshape from short wide format to tall and narrow format
setkey(dt, subject, activity)
dt_reshape <- data.table(melt(dt, key(dt), variable.name="featureName"))
## separate featureName to make it more descriptive
## separate signal domain info from featureName by adding a new variable feature_Domain
dt_reshape$feature_Domain <- factor(ifelse(grepl("Time", dt_reshape$featureName), "Time", "Frequency"), 
                                    levels=c("Time","Frequency"))
## separate acceleration info from featureName by adding a new variable feature_Acceleration
dt_reshape$feature_Acceleration <- factor(ifelse(grepl("Body", dt_reshape$featureName), 
                                                 "Body", "Gravity"))
## separate calculation info from featureName by adding a new variable feature_Calc
dt_reshape$feature_Calc <- factor(ifelse(grepl("Magnitude", dt_reshape$featureName), 
                                         ifelse(grepl("Jerk", dt_reshape$featureName),
                                                ifelse(grepl("Accelerometer", dt_reshape$featureName),
                                                       "linear acceleration Jerk magnitude",
                                                       "angular velocity Jerk magnitude"),
                                                ifelse(grepl("Accelerometer", dt_reshape$featureName),
                                                       "linear acceleration magnitude",
                                                       "angular velocity magnitude")), 
                                         ifelse(grepl("Jerk", dt_reshape$featureName),
                                                ifelse(grepl("Accelerometer", dt_reshape$featureName),
                                                       "linear acceleration Jerk",
                                                       "angular velocity Jerk"),
                                                ifelse(grepl("Accelerometer", dt_reshape$featureName),
                                                       "linear acceleration",
                                                       "angular velocity"))))
## separate recording instrument info from featureName by adding a new variable feature_Instrument
dt_reshape$feature_Instrument <- factor(ifelse(grepl("Accelerometer", dt_reshape$featureName), 
                                               "Accelerometer", "Gyroscope"))
## separate recording axis info from featureName by adding a new variable feature_Axis
dt_reshape$feature_Axis <- factor(ifelse(grepl("-X", dt_reshape$featureName), 
                                               "X", 
                                         ifelse(grepl("-Y", dt_reshape$featureName),
                                                "Y", 
                                                ifelse(grepl("-Z",dt_reshape$featureName), 
                                                       "Z", ""))))
## separate data estimation info from featureName by adding a new variable feature_Estimation
dt_reshape$feature_Estimation <- factor(ifelse(grepl("mean", dt_reshape$featureName), 
                                               "Mean", "SD"))

## create a tidy data set with the average of each variable for each activity and each subject
setkey(dt_reshape, subject, activity, feature_Domain, feature_Acceleration, feature_Instrument, feature_Calc, feature_Estimation, feature_Axis)
dt_tidy <- dt_reshape[, list(count = .N, average = mean(value)), by=key(dt_reshape)]

## export the data table as a text file
write.table(dt_tidy, file="./tidy.txt", row.name=FALSE, sep="\t", quote=FALSE)
