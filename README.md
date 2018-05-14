# clean-data-wk4

## This repository contains:

* Code book:  [features_info.txt](https://github.com/bthornton/clean-data-wk4/features_info.txt)
* [raw_data](https://github.com/bthornton/clean-data-wk4/raw_data): More information on the raw data can be found in its [README.txt](https://github.com/bthornton/clean-data-wk4/raw_data/UCI HAR Dataset/README.txt)
* [run_analysis.R](https://github.com/bthornton/clean-data-wk4/run_analysis.R)
* More information on the raw data

## How the script works

* run_analysis.R will also download and unzip the files from the course repository as well as check the install status for dependent libraries, in this case the **dplyr** library.
* The script will read the required txt files, and will:
  * merge them into one each test and train data table;
  * merge the test and train tables into one table;
  * subset that merged table into a new table with only the subject, activity, mean and standard deviation values;
  * use merge to swap the activity_id for the more reader-friendly activity_label
  * group the data on the activity and subject and output the means for each measurement
  * output that data into a file called tidy_dt.txt 

