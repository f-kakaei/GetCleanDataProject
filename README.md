---
title: "README"
output:
  html_document:
    number_sections: yes
    toc: yes
    toc_depth: 2  
---

# How does the script work?
1- First the activity labels file `("activity_labels.txt")` is loaded to a data frame called *acivities* and its names attribute is set, so that the first column is named `"acivity_id"` and the second is named "activity_name"`.

```r
# Load activity data and modify name
activities <- read.csv("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=" ")
names(activities)<-c("activity_id", "activity_name")
```

2- Features are loaded from features.txt file to *features* data frame.

```r
# Load feature names
features<-read.csv(file="UCI HAR Dataset/features.txt", header=FALSE, sep="", na.strings="", stringsAsFactors=FALSE)
```

3- Train activities are loaded from y_train.txt file in /train folder into *trainActivities* data frame. Then its names attributes is set, so that it can be immediately merged with activities data frame.

```r
# Load train activities and merge with activities labels
trainActivities <- read.csv("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep=" ")
names(trainActivities)<-c("activity_id")
trainActivities <- merge(activities, trainActivities, by="activity_id")
```

4- Test activities are loaded just in the same way as the train activities and merged with activities data frame.

```r
# Load test activities and merge with activities labels
testActivities <- read.csv("UCI HAR Dataset/test/y_test.txt", header=FALSE, sep=" ")
names(testActivities)<-c("activity_id")
testActivities <- merge(activities, testActivities, by="activity_id")
```

5- Train subjects are loaded from subject_train.txt file into *trainSubjects* data frame and its name is assigned.

```r
# Load train subjects and modify name
trainSubjects <- read.csv("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep=" ")
names(trainSubjects)<-c("subject_id")
```

```r
6- Test subjects are loaded into *testSubjects* data frame in the same way.
# Load test subjects and modify name
testSubjects <- read.csv("UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep=" ")
names(testSubjects)<-c("subject_id")
```
7- Train and test data sets are loaded into trainData and testData data frames. Note that only columns containg mean and standard deviation of measurments are loaded.

```r
# Load train and test data and set column names
columnClass <- rep("NULL", 561)
extraxtColumns <- c(1:6,41:46, 81:86, 121:126, 161:166, 201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266:271, 345:350, 424:429, 503, 504, 516, 517, 529, 530, 542,543)

columnClass[extraxtColumns] <- NA
trainData <- read.csv(file="UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="", colClasses=columnClass, na.strings="")
names(trainData)<-gsub("()", "", features[extraxtColumns, 2], fixed="TRUE")
testData <- read.csv(file="UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="", colClasses=columnClass, na.strings="")
names(testData)<-gsub("()", "", features[extraxtColumns, 2], fixed="TRUE")
```

7- Subject and activity columns are inserted at the beginning of columns list of trainData and testData data frames.

```r
# add subject and activity columns to train and test data
trainData<-data.frame(trainSubjects[1], trainActivities[2], trainData[1:ncol(trainData)])
testData<-data.frame(testSubjects[1], testActivities[2], testData[1:ncol(testData)])
```
8- The two data frames are now unioned to create the allData data frame which is used to be grouped by applying mean
function to numeric columns. The result, tidyData data frame, is ordered according to subject_id column and is written to a file named "tidyData.txt".  

```r
# union train and test data set
allData<-rbind(trainData, testData)
trainData<-NULL
testData<-NULL
tidyData <- aggregate(allData[3:68], by = allData[c("subject_id","activity_name")], FUN=mean)
tidyData<-tidyData[order(tidyData$subject_id),]

# write tidy data set to file
write.table(tidyData, "tidyData.txt", row.name=FALSE) 
```

# Running the script
To run the run_analysis.R script:  
1- Make sure the dataset "UCI HAR Dataset"" is in working directory (You should unzip the zipped data set in working directory so that it would contain a folder named "UCI HAR Dataset").
2- Copy the run_analysis.R file to the working directory.  
3- In R or RStudio type the following command:

```r
source("run_analysis.R")
```
4- Wait until the run is completed.

# The output of the script
Upon finishing, the script creates a dataset named "tidyData.txt" in the working directory.
