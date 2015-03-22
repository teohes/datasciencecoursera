## Download and extract the ""UCI HAR Dataset"" data files into current directory.
## Below are the initial folders and files in the current directory
## 		test  --- (directory)
##  	train --- (directory)
##  	activity_labels
##  	features.txt
##  	features_info.txt
##  	README.txt
##
##  This file run_analysis.R is also located in this current directory.
## These are the libraries we will be using
library(dplyr)
library(reshape2)
##
## Examining of the X_train.txt and X_test.txt (using Notepad++ and also loading the files
## into R using read.tables show that they can be concatenated row-wise using rbind.)
##
## NOTE:  The test set data is always added to the bottom of the training set data for consistency.
## 
## STEP 1:  Merging the training dataset and test dataset

X_train<-read.table("train/X_train.txt",header=FALSE, stringsAsFactors=FALSE)
X_test<-read.table("test/X_test.txt",header=FALSE, stringsAsFactors=FALSE)
X_combine<- rbind(X_train,X_test)
##  Add the column names
features<-read.table("features.txt",header=FALSE,stringsAsFactors=FALSE) 
names(X_combine)<-features$V2


## We can similarly concatenate the training set data y_train with
## the test set data y_train.  (y_train and y_test are the activity labels)

y_train<-read.table("train/y_train.txt",header=FALSE, stringsAsFactors=FALSE)
y_test<-read.table("test/y_test.txt",header=FALSE, stringsAsFactors=FALSE)
y_combine<- rbind(y_train,y_test)
##  Label the column "activity"
colnames(y_combine)[colnames(y_combine) == "V1"] <- "activity"

## Similarly concatenate the training set ""subject_train"" with
## the test set data "subject_test"".
subject_train<-read.table("train/subject_train.txt",header=FALSE, stringsAsFactors=FALSE)
subject_test<-read.table("test/subject_test.txt",header=FALSE, stringsAsFactors=FALSE)
subject_combine<- rbind(subject_train,subject_test)
##  Label the column "subject"
colnames(subject_combine)[colnames(subject_combine) == "V1"] <- "subject"

## We can now column combine the above 3 entities into 1 dataset
xcombine<- cbind(subject_combine, y_combine, X_combine)
##
## Clean up the workspace
rm(X_train,X_test)
rm(y_train,y_test)
rm(subject_train,subject_test)
rm(X_combine,subject_combine,y_combine)
##
##  STEP 2
## To extract only the measurements on the mean and standard deviation for each measurement.
## First we add 2 variables to the beginning (left side) of the features.txt data
##  This is to account for the 2 extra columns we added to the xcombine data above

features<- rbind( c("NA","activity"),features)
features<- rbind( c("NA","subject"),features)

## Now find all the columns we wish to keep  (ie. to extract the mean and std)
colToKeep<-grep("mean\\(\\)|std\\(\\)|activity|subject", tolower(features$V2))

## Copy all the columns we want to keep to new dataset
xfinal<-xcombine[,colToKeep]

## Clean up the workspace
rm(xcombine, colToKeep, features)

##
## Reading in The Elements of Data Analytic Style by Jeff Leek
## he highly recommended that labels/variables should be in lowercase
## and that all "." , "-" and special characters be removed.  
## I am following his recommendation and have converted all labels/variables

## STEP 3  Uses descriptive activity names to name the activities in the data set
## Next, insert the actual activity name (in lowercase) into the xfinal dataset using
##			1 walking
##			2 walking_upstairs
##			3 walking_downstairs
##			4 sitting
##			5 standing
##			6 laying
xfinal$activity<-gsub("1","walking",xfinal$activity)
xfinal$activity<-gsub("2","walking_upstairs",xfinal$activity)
xfinal$activity<-gsub("3","walking_downstairs",xfinal$activity)
xfinal$activity<-gsub("4","sitting",xfinal$activity)
xfinal$activity<-gsub("5","standing",xfinal$activity)
xfinal$activity<-gsub("6","laying",xfinal$activity)
##
## STEP 4  Appropriately label the data set with descriptive variable names. 
## We have already labelled the "subject" and "activity" variable earlier
## Here as described above, remove all special characters eg. "-", ")", "(" 
## and lowercase them
simplifynames<-gsub("-","",names(xfinal))
simplifynames<-tolower(gsub("\\(\\)","",simplifynames))
names(xfinal)<-simplifynames
##
## Clean up the workspace
rm(simplifynames)

## 
## STEP 5   From the data set in step 4, creates a second, independent tidy
## data set with the average of each variable for each activity and each subject.
##
##
xfinal<-group_by(xfinal,subject,activity)
xfinal<-summarise_each(xfinal,funs(mean))
##
##
## Save the tidy data set
write.table(xfinal,file="Step5TidyData.txt",row.names=FALSE)

##  To read the saved file and examine in it in R, use the following commands:
##
##       data <- read.table("Step5TidyData.txt", header = TRUE) 
##       View(data)












