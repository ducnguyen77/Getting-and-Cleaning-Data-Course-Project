# Coursera-Getting-and-Cleaning-Data-Course-Project
# Written by Duc Van Nguyen
#------------------------------------------------------------------------
library(plyr)

# Download and unzip the data file.

myUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(myUrl,destfile = "Dataset.zip")
unzip("Dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)
#----------------------------------------------------------------------------------------------
## 1. Merge the training and test data sets to create one data set
# loading the training data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# loading the test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

# create a 'merged' data set
merged_data <- cbind(subject_data, y_data, x_data)
#------------------------------------------------------------------------------------------

## 2. Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
wanted_features <- grep(".*mean.*|.*std.*", features[, 2])

# subset the desired columns
x_wanted_data <- x_data[, wanted_features]
mean_std_data <- cbind(subject_data, y_data, x_wanted_data)

#-------------------------------------------------------------------------------------------

# 3. Use descriptive activity names to name the activities in the data set
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
activity <- activity_labels[y_data[, 1], 2]

#-------------------------------------------------------------------------------------------

## 4. Appropriately label the data set with descriptive variable names

# correct the column names
wanted_features.names <- features[wanted_features,2]
wanted_features.names = gsub('-mean', 'Mean', wanted_features.names)
wanted_features.names = gsub('-std', 'Std', wanted_features.names)
wanted_features.names <- gsub('[-()]', '', wanted_features.names)
names(x_wanted_data) <- features[wanted_features, 2]

descriptive_name_data <- cbind(subject_data, activity, x_wanted_data)
colnames(descriptive_name_data) <- c("subject", "activity", wanted_features.names)

#-----------------------------------------------------------------------------------------------

## 5. From the data set in step 4, creates a second, independent tidy data set with the 
## average of each variable for each activity and each subject.

data.melted <- melt(descriptive_name_data, id = c("subject", "activity"))
tidy <- dcast(data.melted, subject + activity ~ variable, mean)

#----------------------------------------------------------------------------------------------------
## 6. Exporting the variables names and the data
# export the column names to use for a book code
write.table(names(tidy), "wanted_features_names.md", row.name=FALSE, col.names = FALSE, quote = FALSE)
# export the tidy data set
write.table(tidy, "tidy.txt", row.name=FALSE)










