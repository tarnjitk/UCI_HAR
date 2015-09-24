  require(dplyr)
  require(tidyr)
  
#   "UCI_HAR_Dataset/test/subject_test.txt", id of participant
#   "UCI_HAR_Dataset/test/X_test.txt", 561 variables
#   "UCI_HAR_Dataset/test/y_test.txt",integer which corresponds to activityType
#   "UCI_HAR_Dataset/train/subject_train.txt", 
#   "UCI_HAR_Dataset/train/X_train.txt", 
#   "UCI_HAR_Dataset/train/y_train.txt"
#   
#   'features.txt': List of all features. The variable names of the 561 variables in X_* data.  

  file_list_dir <- list("UCI_HAR_Dataset/test/subject_test.txt", "UCI_HAR_Dataset/test/X_test.txt", 
                        "UCI_HAR_Dataset/test/y_test.txt", 
                        "UCI_HAR_Dataset/train/subject_train.txt", "UCI_HAR_Dataset/train/X_train.txt", 
                        "UCI_HAR_Dataset/train/y_train.txt")

  
  subject_test <- read.table("UCI_HAR_Dataset/test/subject_test.txt")
  X_test <- read.table("UCI_HAR_Dataset/test/X_test.txt")
  y_test <- read.table("UCI_HAR_Dataset/test/y_test.txt")
  
  subject_train <- read.table("UCI_HAR_Dataset/train/subject_train.txt")
  X_train <- read.table("UCI_HAR_Dataset/train/X_train.txt")
  y_train <- read.table("UCI_HAR_Dataset/train/y_train.txt")
  
  
  
#  activityType <- factor(y_test$V1,  levels = 1:6, labels = c("WALKING", "WALKING_UPSTAIRS", 
#                        "WALKING_DOWNSTAIRS", "SITTING", "STANDING", 
#                         "LAYING"))
  
  #print(activityType)
  #dim(activityType)
  
  
  compositeTestData <- data.frame(y_test, subject_test, X_test)
  
#  testgather <- gather(compositeTestData, activityType, na.rm = FALSE, convert = FALSE)
  
#  compositeTestData <- cbind(activityType, subject_test, X_test)
  
  compositeTrainData <- data.frame(y_train, subject_train, X_train)
  
#  compositeDataFrame <- ldply(file_list_dir, read.table, na.strings=c("NA", "-", "?","unknown"), stringsAsFactors = FALSE)
  
#  print(head(compositeDataFrame)
  
  