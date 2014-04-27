library(data.table)
# 1. Merges the training and the test sets to create one data set.

# read in training set
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("UCI HAR Dataset/train/y_train.txt")

# read in test set
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/y_test.txt")

# combine train and test sets
fullX <- rbind(trainX,testX)
fullY <- rbind(trainY,testY)


# 3. Uses descriptive activity names to name the activities in the data set

# feature names
featureNames <- read.table("UCI HAR Dataset/features.txt")
names(featureNames) <- c("varnum","varname")

names(fullX) <- featureNames$varname


# 4. Appropriately labels the data set with descriptive activity names. 
# activity labels lookup
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activityLabels) <- c("id","activitydesc")

names(fullY) <- "activity"
fullY <- merge(fullY,activityLabels,by.x="activity",by.y="id")
fullY <- fullY$activitydesc

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

mean_names <- grep("mean\\(\\)",names(fullX),value=TRUE)
std_names <- grep("std\\(\\)",names(fullX),value=TRUE)
tidyNames <- c(mean_names,std_names)

# subset only mean and sd vars
tidyDat <- fullX[names(fullX) %in% tidyNames]

# clean up names
cleanNames <- gsub("\\(\\)","", tidyNames)
cleanNames <- gsub("-",".", cleanNames)

names(tidyDat) <- cleanNames

tidyDat$activity <- fullY




# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# subjects lookup
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

subjects <- rbind(trainSubjects, testSubjects)
names(subjects) <- "subject"

tidyDat$subject <- subjects$subject 

tidyDat <- data.table(tidyDat)

tidyDat2 <- tidyDat[, lapply(.SD,mean), by=c("activity","subject")]












