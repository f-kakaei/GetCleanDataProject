
# Load activity data and modify name
activities <- read.csv("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=" ")
names(activities)<-c("activity_id", "activity_name")


# Load feature names
features<-read.csv(file="UCI HAR Dataset/features.txt", header=FALSE, sep="", na.strings="", stringsAsFactors=FALSE)


# Load train activities and merge with activities labels
trainActivities <- read.csv("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep=" ")
names(trainActivities)<-c("activity_id")
trainActivities <- merge(activities, trainActivities, by="activity_id")


# Load test activities and merge with activities labels
testActivities <- read.csv("UCI HAR Dataset/test/y_test.txt", header=FALSE, sep=" ")
names(testActivities)<-c("activity_id")
testActivities <- merge(activities, testActivities, by="activity_id")

# Load train subjects and modify name
trainSubjects <- read.csv("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep=" ")
names(trainSubjects)<-c("subject_id")


# Load test subjects and modify name
testSubjects <- read.csv("UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep=" ")
names(testSubjects)<-c("subject_id")

# Load train and test data and set column names
columnClass <- rep("NULL", 561)
extraxtColumns <- c(1:6,41:46, 81:86, 121:126, 161:166, 201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266:271, 345:350, 424:429, 503, 504, 516, 517, 529, 530, 542,543)

columnClass[extraxtColumns] <- NA
trainData <- read.csv(file="UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="", colClasses=columnClass, na.strings="")
names(trainData)<-gsub("()", "", features[extraxtColumns, 2], fixed="TRUE")
testData <- read.csv(file="UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="", colClasses=columnClass, na.strings="")
names(testData)<-gsub("()", "", features[extraxtColumns, 2], fixed="TRUE")

# add subject and activity columns to train and test data
trainData<-data.frame(trainSubjects[1], trainActivities[2], trainData[1:ncol(trainData)])
testData<-data.frame(testSubjects[1], testActivities[2], testData[1:ncol(testData)])

# union train and test data set
allData<-rbind(trainData, testData)
trainData<-NULL
testData<-NULL
tidyData <- aggregate(allData[3:68], by = allData[c("subject_id","activity_name")], FUN=mean)
tidyData<-tidyData[order(tidyData$subject_id),]

# write tidy data set to file
write.table(tidyData, "tidyData.txt", row.name=FALSE) 


