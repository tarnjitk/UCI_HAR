# *------------------------------------------------------------------
# | PROGRAM NAME: run_analysis.R
# | DATE: September 2015
# | CREATED BY: Tarnjit Kaur  
# | PROJECT FILE: Getting Clean Data Project           
# *----------------------------------------------------------------
# | PURPOSE:               
# | To create one R script called run_analysis.R that does the following. 
# * Merges the training and the test sets to create one data set.
# * Extracts only the measurements on the mean and standard deviation for each measurement. 
# * Uses descriptive activity names to name the activities in the data set
# * Appropriately labels the data set with descriptive variable names. 
# * From the data set in step 4, creates a second, independent tidy data set with the 
#   average of each variable for each activity and each subject.
# *------------------------------------------------------------------
# | DATA USED:               
# | https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# |
# |*------------------------------------------------------------------
setwd('/Users/tarnjitkaur/GD_tarnjitkaur84/GettingCleanData/UCI_HAR') 

rm(list=ls()) # get rid of any existing data 
ls() # view open data sets

  require(dplyr)
  require(tidyr)

# *------------------------------------------------------------------
# | IMPORT Data files
# | #   "UCI_HAR_Dataset/test/subject_test.txt", id of participant
#       "UCI_HAR_Dataset/test/X_test.txt", 561 variables
#       "UCI_HAR_Dataset/test/y_test.txt",integer which corresponds to activityType
#       "UCI_HAR_Dataset/train/subject_train.txt", 
#       "UCI_HAR_Dataset/train/X_train.txt", 
#       "UCI_HAR_Dataset/train/y_train.txt"   
#   'features.txt': List of all features. The variable names of the 561 variables in X_* data.  
# *-----------------------------------------------------------------
    subject_test <- read.table("UCI_HAR_Dataset/test/subject_test.txt")
    X_test <- read.table("UCI_HAR_Dataset/test/X_test.txt")
    Y_test <- read.table("UCI_HAR_Dataset/test/y_test.txt")


    subject_train <- read.table("UCI_HAR_Dataset/train/subject_train.txt")
    X_train <- read.table("UCI_HAR_Dataset/train/X_train.txt")
    Y_train <- read.table("UCI_HAR_Dataset/train/y_train.txt")

    namesCols <- read.table("UCI_HAR_Dataset/features.txt")

    activityTypeList <- read.table("UCI_HAR_Dataset/activity_labels.txt")

# *------------------------------------------------------------------               
#    using bind_rows(a, b) to append the training data to the bottom of the test data
# *-----------------------------------------------------------------
    Xdata <- bind_rows(X_test, X_train)
    Ydata <- bind_rows(Y_test, Y_train)
    subjectData <- bind_rows(subject_test, subject_train)

# *------------------------------------------------------------------
# |         Associate the key from activityType to Ydata
# *-----------------------------------------------------------------
    activityType <- factor(Ydata$V1)
    levels(activityType) <- activityTypeList$V2
    activityType <- data.frame(activityType)

# *------------------------------------------------------------------
#     colnames(df) <- namesCols : using features.txt for the variable names in X_data
#     gsub(pattern, replacement, x)
# *-----------------------------------------------------------------
     namesColsT1 <- gsub("-", "", namesCols$V2)
     namesColsT2 <- gsub("()", "", namesColsT1)
     namesColsT3 <- gsub(",", "", namesColsT2)
     namesColsT4 <- gsub("", "", namesColsT3)

    colnames(Xdata) <- namesColsT3
    colnames(subjectData) <- "subjectNum"

# *------------------------------------------------------------------            
# | using bind_cols(a, b) to append the activity data (YData) and subject data columns to Xdata
# *-----------------------------------------------------------------
    compositeData <- bind_cols(subjectData, activityType, Xdata)

# *------------------------------------------------------------------
# | Some of the column names derived from features.txt are not syntactically correct
# *-----------------------------------------------------------------
  valid_column_names <- make.names(names=names(compositeData), unique=TRUE, allow_ = TRUE)
  names(compositeData) <- valid_column_names

# *------------------------------------------------------------------
# | Extracts only the measurements on the mean and standard deviation for each measurement.   
# *-----------------------------------------------------------------
  extractData <- select(compositeData, subjectNum, activityType, contains("mean", ignore.case = TRUE),
                  contains("std", ignore.case = TRUE))

# *------------------------------------------------------------------
# |   Create an independent tidy data set with the average of each variable for each activity and each subject.
# *-----------------------------------------------------------------

      meanData <- extractData %>% 
                  group_by(activityType, subjectNum) %>% 
                  summarise_each(funs(mean))

# *------------------------------------------------------------------
# |  Tidy data , long and narrow, set with the average of each variable for each activity and each subject.
# gather(data, key, value, ..., na.rm = FALSE, convert = FALSE)

# Arguments:
#   data:           data frame
#   key:            column name representing new variable
#   value:          column name representing variable values
#   ...:            names of columns to gather (or not gather)
#   na.rm:          option to remove observations with missing values (represented by NAs)
#   convert:        if TRUE will automatically convert values to logical, integer, numeric, complex or 
#   factor as appropriate

# *-----------------------------------------------------------------

     tidyData <- gather(meanData, key, averageActivitySignal, tBodyAccmean..X:fBodyBodyGyroJerkMagstd..)

# *-----------------------------------------------------------------
#  Write narrow, tidy data to file
#
#  write.table(x, file = "", append = FALSE, quote = TRUE, sep = " ",
#             eol = "\n", na = "NA", dec = ".", row.names = TRUE,
#             col.names = TRUE, qmethod = c("escape", "double"),
#             fileEncoding = "")
# write.table() using row.name=FALSE
#
#
# *-----------------------------------------------------------------

    write.table(tidyData, file = "GCD_projectData.txt", row.name=FALSE)

