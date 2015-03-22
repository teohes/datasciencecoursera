# REAME.md

This README file describes the use of the run_analysis.R script to produce the tidy data file "Step5TidyData.txt" using the data from the experiments run by
----------
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws

----------
###  Files and Directory Setup

Download and extract the "UCI HAR Dataset" data files into the current directory.
Below are the initial folders and files that should be in the current directory for the run_analysis.R script to run properly

		- 	test  --(directory containing the test data)
		- 	train --(directory containing the training data)
		- 	activity_labels.txt --(list the six activities and correcsponding code for each)
		- 	features.txt --(lists the 561 features/variables collected/calculated)
		- 	features_info.txt --(description of the feature selection)
		- 	README.txt (Original file describing the above dataset)

The data is available for download here:

			https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##  run_analysis.R

The **run_analysis.R** script is also located in the above directory. The final step of this script will produce the datafile  "Step5TidyData.txt" (in the current directory).


##  Description of run\_analysis.R


### Note: The libraries used in this script are: **library(dplyr)** and **library(reshape2)**.

###  Reading in and examining the dataset
1.  The data files were all read in using the following form:

				dataset <-read.table("filename.txt",header=FALSE, stringsAsFactors=FALSE)
2.  Inspection of the X\_train.txt (in the train directory above) and X\_test.txt (in the test directory above) using both Notepad++ and also in R using View(),head(),tail() show that they can be safely concatenated row-wise using rbind.
3.  The same applies for the y\_train, subject\_train and y\_test and subject\_test data.  They are similarly concatenated
4.  The concatenation of the data is always done by adding the test data to the bottom of the training set data for consistency.

###  STEP 1: MERGING THE DATASETS

1. rbind was used to merge the training dataset and test dataset
2. The features dataset was used as the headers for their respective columns. The column headers were added using the form:  names(X_combine)<-features$V2
3. Next we merged the activity labels (y\_train and y\_test) and labeled the column "activity"
4. and merged the "subject" (subject\_train, subject\_test) and labeled the column "subject"
5. Finally, we combined the 3 entities using cbind to obtain the combined dataset called "xcombine"
6. To keep the R workspace tidy, we occasionally remove old datasets using the rm() command.


###  STEP 2: To extract only the measurements on the mean and standard deviation for each measurement.


1. First we added 2 variables to the beginning of the features.txt data. This is to account for the 2 extra columns we added to the xcombine data above, namely "subject" and "activity" column.
2. Find all the columns we wish to keep  (ie. to extract the columns related to mean() and std() using the grep command.)
3. Copy all the columns we want to keep to a new dataset called xfinal.

###  STEP 3: Use descriptive activity names to name the activities in the data set
1. Using the activity\_label data, replace all numeric activity in the activity column with their corresponding name.  Command used was of the form :

					xfinal$activity<-gsub("1","walking",xfinal$activity)


	- 1 walking
	- 2 walking_upstairs
	- 3 walking_downstairs
	- 4 sitting
	- 5 standing
	- 6 laying

 


###  STEP 4: Appropriately label the data set with descriptive variable names. 
**Note: I read in "The Elements of Data Analytic Style by Jeff Leek" that it is highly recommended that labels/variables for tidy datasets should preferably be in lowercase and that all special characters (eg."." , "-") be removed.  Whilst I have found this peculiar (as it affects readability), I decided to follow this recommendation and have converted all labels/variables to lowercase and removed "special characters"**

1. Using gsub and tolower, this step converts all names/variables to lowercase and removes all special characters eg. "-", ")", "("

###  STEP 5:  Creates an independent tidy data set with the average of each variable for each activity and each subject.
1.  Here we group by each subject (identity) and their activities and calculate the average of the means and the average of the standard deviations we extracted earlier.
2.  This is done using the group_by() and summarise_each() commands.


###  Save the tidy data set 
1. Write the tidy dataset created to a file named "Step5TidyData.txt"
2. The command used to write this file is:

			write.table(xfinal,file="Step5TidyData.txt",row.names=FALSE)

###  To read the saved file and examine in it in R, use the following commands:
		1. 			data <- read.table("Step5TidyData.txt", header = TRUE)
		2. 			View(data)









