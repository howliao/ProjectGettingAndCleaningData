README
======
>
>This is an R Markdown readme document for the project in Getting and Cleaning Data. The purpose of
>this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is 
>to prepare tidy data that can be used for later analysis. 
>
>Submission of 
>>1) a tidy data set as described below, 
>>
>>2) a link to a Github repository with your script for performing the analysis, 
>>
>>3) a code book (CodeBook.md) that describes the variables, the data, and any transformations or 
>>>work that you performed to clean up the data, 
>>
>>and 4) a README.md in the repo explains how all of the scripts work and how they are connected 
>have been done.
>
>Data for the project are from: 
>
>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
>
>The R script called run_analysis.R has been created that
>>  1.  Checks the existance of/creates "data" folder under your working directory.
>>
>>  2.  Downloads and extracts the dataset file into "data" folder.
>>
>>  3.  Merges the training and the test sets to create one data set.
>>
>>  4.  Extracts only the measurements on the mean and standard deviation for each measurement.
>>
>>  5.  Uses descriptive activity names to name the activities in the data set.
>>
>>  6.  Labeles the data set with descriptive activity names.
>>
>>  7.  Creates a second tidy data set with the average of each variable for each activity and each
        subject.
>
>The two .Rmd files help make formatted .md files using knit() command from knitr and markdown
>packages.       
