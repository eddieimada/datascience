#CourseProject
This is a Repository for the Course Project for Getting and Cleaning Data on Coursera

##AUTHOR

Eddie Imada

##Description

This repository contains data and code related to the Massive Open Online Course "Get and Cleaning Data" which is part of the "Data Science Specialization" offered by professors from the John Hopkins University.

The script file "run_analysis.R" found in this repository, can be sourced from inside an R session. However in order to it work, the current work directory must be set to be the original data set folder (see Data Source).

`setwd("Path_to_dataset_folder")`
`source("run_analysis.R")`

The above command will read and execute the script that turn the raw data set into a tidy data that can be used for later analysis. The final structure and content of the tidy data set is detailed in the file "CodeBook.md".

##Data Source

The data utilized by the script is the data set of "Human Activity Recognition Using Smartphones Data Set" from the UCI Machine Learning Repository. The following link points to the download of a zip file which must be extracted in order to obtain the original data set folder.

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

##Data Set Information (from UCI repository):

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Check the README.txt file for further details about this dataset.

More information is available at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

###Code Overview

The R script named "run_analysis.R", merges the original "training" and "test" data sets, label the variable names, and reports the mean values per subject (experiment volunteers) and activity, that derive from mean and standard deviation values of features. The result is a text file named "course_project.txt" that has been cleaned and rearranged in a way that each row represents the average inertial measurement unit (IMU) for each activity and each subject and for each values of all variables from the original dataset that contained the substring "mean" or "std".

Details

- First the script navigate to the test folder.

`setwd("./test")`<br/>


- Then it load all necessary files in this folder: "X_test.txt", "subject_test.txt" and "y_test.txt" which contains the test data set, the subjects IDs and the Activity type (class) respectively.

`test <- read.table("X_test.txt", sep = "", header = FALSE)`<br/>
`subjTest <- read.table("subject_test.txt")`<br/>
`tested_class <- read.table("y_test.txt")`<br/>

- Return to original folder and loads the "features.txt" file which contain the features names on it's second column (V2) and assign it to the variable features which in turn it's assigned to the test data frame.

`setwd("..")`<br/>
`features <- read.table("features.txt", sep="", header = FALSE)`<br/>
`features <- features$V2`<br/>
`features <- as.character(features)`<br/>
`names(test) <- features`<br/>

- Then it navigates to the train folder and loads all necessary files similar to the previous steps.

`setwd("./train")`<br/>
`train <- read.table("X_train.txt", sep = "", header = FALSE)`<br/>
`subjTrain <- read.table("subject_train.txt")`<br/>
`trained_class <- read.table("y_train.txt")`<br/>
`names(train) <- features`<br/>

- The train and test data frames are merged into the "merged" dataframe.

`merged <- rbind(test,train)`<br/>

- Then only the features containing the substrings "std" and "mean" are collected.

`merged <- merged[,grepl("std|mean",x = names(merged))]`<br/>

- The classes from test and trained are merged and binded to the merged data set. Also the subjetcs are binded to the merged data set as well, generating the fulldata dataset.

`all_classes <- rbind(tested_class, trained_class)`<br/>
`all_classes <- rename(all_classes, ActivityType = V1)`<br/>
`fulldata <- cbind(merged, all_classes)`<br/>
`subjects <- rbind(subjTest, subjTrain)`<br/>
`subjects <- rename(subjects, SubjectsID = V1)`<br/>
`fulldata<- cbind(fulldata, subjects)`<br/>


- The data is then grouped by it's Activity Type a Subjects IDs, the mean value for each feature is calculated.

`grouped <- group_by(fulldata, ActivityType, SubjectsID)`<br/>
`final <- summarise_each(grouped, funs(mean))`<br/>

- Finally the values of Activity Type are changed to a more comprensive descriptor, generating the final data frame.

`final$ActivityType[final$ActivityType == 1 ] <- "Walking"`<br/>
`final$ActivityType[final$ActivityType == 2 ] <- "Walking_upstairs"`<br/>
`final$ActivityType[final$ActivityType == 3 ] <- "Walking_downstairs"`<br/>
`final$ActivityType[final$ActivityType == 4 ] <- "Sitting"`<br/>
`final$ActivityType[final$ActivityType == 5 ] <- "Standing"`<br/>
`final$ActivityType[final$ActivityType == 6 ] <- "Laying"`<br/>

- Last, it returns to the original folder and writes the data frame to a file named "course_project.txt" contained in this repository.

`setwd("..")`<br/>
`write.table(final, file = "course_project.txt", row.names = FALSE)`<br/>

