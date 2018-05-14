# Load dependencies, install if they're not already installed

list.of.packages <- c("dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Declare dplyr
library(dplyr)


# set url for data file to download
file_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

# before downloading into the data directory, check to see if it exists,
# - if it doesn't already exist, create it.

if (!dir.exists('./raw_data')) { dir.create('./raw_data') }

setwd("./raw_data")

destination_file <- 'UCI HAR Dataset.zip'

download.file(file_url,destination_file,method = 'curl')

unzip(destination_file)

setwd('..')

# 1.  First criterion:  "Merges the training and the test sets to create one data set"
#     a.  Load data in:
#         - Load the test data

print('Loading test data...')
subject_test_dt <- read.table('./raw_data/UCI HAR Dataset/test/subject_test.txt')
X_test_dt <- read.table('./raw_data/UCI HAR Dataset/test/X_test.txt')
y_test_dt <- read.table('./raw_data/UCI HAR Dataset/test/y_test.txt')

#         - Load the train data

print('Loading train data...')
subject_train_dt <- read.table('./raw_data/UCI HAR Dataset/train/subject_train.txt')
X_train_dt <- read.table('./raw_data/UCI HAR Dataset/train/X_train.txt')
y_train_dt <- read.table('./raw_data/UCI HAR Dataset/train/y_train.txt')

#         - Load in the activity labels and features to create a more tidy dataset
#           - Activity Labels apply to the values found in the y_test/y_train datasets

print('Loading activity labels...')
activity_labels_dt <- read.table('./raw_data/UCI HAR Dataset/activity_labels.txt')
activity_column_labels <- c('activity_id','activity_label')
colnames(activity_labels_dt) <- activity_column_labels

#           - Features apply to the column names contained in the x_test/x_train datasets

print('Loading features...')
features_dt <- read.table('./raw_data/UCI HAR Dataset/features.txt')

#     b.  With all of the datasets loaded, start combining.
#         1.  First cbind-ing the test datasets into one, do same with train datasets
#             Each will be Subject ID, X data, Y data

print('Combining subject, y, and X data...')
test_dt <- cbind(subject_test_dt,y_test_dt,X_test_dt)
train_dt <- cbind(subject_train_dt,y_train_dt,X_train_dt)

#     c.  Then stack the test and train tables together to create merged_ds using rbind

print('Combining test and train data...')
merged_dt <- rbind(test_dt, train_dt)

# 2.  Fourth criterion: "Appropriately labels the data set with descriptive variable names."
#     - Put the column names back onto the dataframe

print('Putting descriptive variable names on...')
column_names <- c('subject_id','activity_id',as.character(features_dt[,2]))
colnames(merged_dt) <- column_names

# 3.  Second criterion: "Extracts only the measurements on the mean and standard deviation for each measurement."
#     a.  Find all of the columns with "mean" and "std" via grep-ing the colnames for the dt

print('Finding "mean" and "std" measurements, subject, activity and subsetting into nw dt...')
core_measurement_columns <- grep("[Mm]ean|std",colnames(merged_dt),value = TRUE)
reduced_dt <- merged_dt[c('subject_id','activity_id',core_measurement_columns)]

# 4.  Third criterion: "Uses descriptive activity names to name the activities in the data set."

print('Matching activities from activity labels data table and using those instead of indices in reduced data table')
reduced_dt <- merge(reduced_dt,activity_labels_dt,by.x = "activity_id", by.y = "activity_id")

# We now have blended the data sets together, and added the descriptive columns

# 5.  Fifth criterion: "From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."

new_dt <- reduced_dt %>% 
  group_by(activity_label,subject_id) %>% 
  summarise_all(funs(mean))

write.table(new_dt,file = "tidy_dt.txt",row.names = FALSE)