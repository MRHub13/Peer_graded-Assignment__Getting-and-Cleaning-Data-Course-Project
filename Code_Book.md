
# Code Book

This document describes the data used in this project, as well as the
processing steps in script `run_analysis.R` required to create the
resulting tidy data set `FinalData.txt`.

### Overview

30 volunteers performed 6 different activities while wearing a
smartphone. The smartphone captured various data about their movements.
The data linked to from the course website represent data collected from
the accelerometers from the Samsung Galaxy S smartphone. A full
description of the experiments is available at the site where the data
was obtained:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Data for the project can be found @
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>


### Short explanation of files

-   `features.txt` … names of the 561 features
-   `activity_labels.txt` … names and IDs for each of the 6 activities
-   `X_train.txt` … 7352 observations of the 561 features, for 21 of the
    30 volunteers
-   `subject_train.txt` … a vector of 7352 integers, denoting the ID of
    the volunteer related to each of the observations in X\_train.txt
-   `y_train.txt` … a vector of 7352 integers, denoting the ID of the
    activity related to each of the observations in X\_train.txt
-   `X_test.txt` … 2947 observations of the 561 features, for 9 of the
    30 volunteers
-   `subject_test.txt` … a vector of 2947 integers, denoting the ID of
    the volunteer related to each of the observations in X\_test.txt
-   `y_test.txt` … a vector of 2947 integers, denoting the ID of the
    activity related to each of the observations in X\_test.txt

#### Not used data files

This analysis was performed using only the files above. Therefore, the
data files in the folders `Inertial Signals` (raw signal data) were
ignored.

### Processing steps

-   All of the relevant data files were read into data frames,
    appropriate column headers were added, and the training and test
    sets were combined into a single data set.
-   All feature columns were removed that did not contain the exact
    string “mean()” or “std()”. This left 66 feature columns, plus the
    subjectID and activity columns.
-   The activity column was converted from a integer to a factor, using
    labels describing the activities.
-   A tidy data set was created containing the mean of each feature for
    each subject and each activity. Thus, subject \#1 has 6 rows in the
    tidy data set (one row for each activity), and each row contains the
    mean value for each of the 66 features for that subject/activity
    combination. Since there are 30 subjects, there are a total of 180
    rows.
-   The tidy data set was output to a `txt` file.

The `run_analysis.R` script performs the data preparation and then
followed by the 5 steps required as described in the course project’s
definition:

##### 1. Download the dataset

-   Dataset downloaded and extracted under the folder called
    `UCI HAR Dataset`

##### 2. Assign each data to variables

-   `features` &lt;- `features.txt` … 561 rows, 2 columns The features
    selected for this database come from the accelerometer and gyroscope
    3-axial raw signals tAcc-XYZ and tGyro-XYZ.
-   `activity_l` &lt;- `activity_labels.txt` … 6 rows, 2 columns List of
    activities performed when the corresponding measurements were taken
    and its codes (labels)
-   `subject_test` &lt;- `test/subject_test.txt` … 2947 rows, 1 column
    contains test data of 9/30 volunteer test subjects being observed
-   `X_test` &lt;- `test/X_test.txt` … 2947 rows, 561 columns contains
    recorded features test data
-   `y_test` &lt;- `test/y_test.txt` … 2947 rows, 1 columns contains
    test data of activities’code labels
-   `subject_train` &lt;- `test/subject_train.txt` … 7352 rows, 1 column
    contains train data of 21/30 volunteer subjects being observed
-   `X_train` &lt;- `test/X_train.txt` … 7352 rows, 561 columns contains
    recorded features train data
-   `y_train` &lt;- `test/y_train.txt` … 7352 rows, 1 columns contains
    train data of activities’code labels

##### 3. Merges the training and the test sets to create one data set

-   `X` (10299 rows, 561 columns) is created by merging `X_train` and
    `X_test` using **rbind()** function
-   `Y` (10299 rows, 1 column) is created by merging `y_train` and
    `y_test` using **rbind()** function
-   `Subject` (10299 rows, 1 column) is created by merging
    `subject_train` and `subject_test` using **rbind()** function
-   `M_DataSet` (10299 rows, 563 column) is created by merging `Subject`,
    `Y` and `X` using **cbind()** function

##### 4. Extracts only the measurements on the mean and standard deviation for each measurement

-   `T_Data` (10299 rows, 88 columns) is created by subsetting `M_Data`,
    selecting only columns: `subject`, `code` and the `measurements` on
    the `mean` and `std` (standard deviation) for each measurement

##### 5. Uses descriptive activity names to name the activities in the data set

-   Numbers in `code` column of the `T_Data` are replaced with
    corresponding activity taken from second column of the `activities`
    variable

##### 6. Appropriately labels the data set with descriptive variable names

-   `code` column in `T_Data` renamed into `activity`
-   all `Acc` in column’s name replaced by `Accelerometer`
-   all `Gyro` in column’s name replaced by `Gyroscope`
-   all `BodyBody` in column’s name replaced by `Body`
-   all `Mag` in column’s name replaced by `Magnitude`
-   all beginnings with character `f` in column’s name replaced by
    `Frequency`
-   all beginnings with character `t` in column’s name replaced by
    `Time`

##### 7. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

-   `F_Data` (180 rows, 88 columns) is created by sumarizing `T_Data`
    taking the means of each variable for each activity and each
    subject, after groupped by subject and activity.
-   `F_Data` is exported into `FinalData.txt` file
