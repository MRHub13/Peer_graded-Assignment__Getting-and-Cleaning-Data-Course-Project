## Step 0 ... Preparation
library(dplyr)
filename <- "getdata_projectfiles_UCI HAR Dataset.zip"

# # Checking if archieve already exists.
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
 }  

## Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
 }

## Assigning all data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_l <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

## Step 1 ... Merges the training and the test sets to create one data set.
X <- rbind(X_train, X_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
M_DataSet <- cbind(Subject, Y, X)

# Step 2 ... Extracts only the measurements on the mean and standard deviation for each measurement (form tidy data set). 
T_Data <- M_DataSet %>% 
        select(subject, code, contains("mean"), contains("std"))

# Step 3 ... Uses descriptive activity names to name the activities in the data set
T_Data$code <- activity_l[T_Data$code, 2]

# Step 4 ... Appropriately labels the data set with descriptive variable names. 
names(T_Data)[2] = "activity"
names(T_Data)<-gsub("Acc", "Accelerometer", names(T_Data))
names(T_Data)<-gsub("Gyro", "Gyroscope", names(T_Data))
names(T_Data)<-gsub("BodyBody", "Body", names(T_Data))
names(T_Data)<-gsub("Mag", "Magnitude", names(T_Data))
names(T_Data)<-gsub("^t", "Time", names(T_Data))
names(T_Data)<-gsub("^f", "Frequency", names(T_Data))
names(T_Data)<-gsub("tBody", "TimeBody", names(T_Data))
names(T_Data)<-gsub("-mean()", "Mean", names(T_Data), ignore.case = TRUE)
names(T_Data)<-gsub("-std()", "STD", names(T_Data), ignore.case = TRUE)
names(T_Data)<-gsub("-freq()", "Frequency", names(T_Data), ignore.case = TRUE)
names(T_Data)<-gsub("angle", "Angle", names(T_Data))
names(T_Data)<-gsub("gravity", "Gravity", names(T_Data))

# Step 5 ... From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
F_Data <- T_Data %>%
        group_by(subject, activity) %>%
        summarise_all(list(mean))
write.table(F_Data, "FinalData.txt", row.name=FALSE)

