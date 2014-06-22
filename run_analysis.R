library(plyr)

#point 4: Appropriately labels the data set with descriptive variable names.
#I used the variable names stored in the features.txt file contined in the 
#getdata-projectfiles-UCI HAR Dataset.zip file.
X.feature.names <- read.table("./UCI HAR Dataset/features.txt", sep=" ", 
                              col.names=c("feature.id", "feature.name"))

#point 3: Uses descriptive activity names to name the activities in the data set.
#I used the activity labels stored in the activity_labels.txt file contained in
#the getdata-projectfiles-UCI HAR Dataset.zip file.
activity.id2labels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep=" ",
                                 col.names=c("activity.id", "activity.label"))

## For Test Set.
#point 4: Appropriately labels the data set with descriptive variable names.
X.test.raw <- read.table("./UCI HAR Dataset/test/X_test.txt", sep=" ", 
                         col.names=X.feature.names$feature.name)

#point 2: Extracts only the measurements on the mean and standard deviation 
#for each measurement. I did this by subsetting those columns containning
#"mean" or "std" in their names.
X.test.raw <- X.test.raw[, grepl("mean|std" , names(X.test.raw))]

#point 3: Uses descriptive activity names to name the activities in the data set.
y.test.raw <- read.table("./UCI HAR Dataset/test/y_test.txt",
                         col.names=c("activity.id"))
y.test.id2label <- join(y.test.raw, activity.id2labels)
activity.label <- y.test.id2label$activity.label

#Intermediate step: I used the subject ids stored in the subject_test.txt file
#contained in the getdata-projectfiles-UCI HAR Dataset.zip file.
subject.ids.test <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                               col.names=c("subject.id"))

#Intermediate step for point 1: I horizontally combine subject ids,
#activity labels, and measurement values.
test.data <- cbind(subject.ids.test, activity.label, X.test.raw)


## For training Set.
#point 4: Appropriately labels the data set with descriptive variable names.
X.train.raw <- read.table("./UCI HAR Dataset/train/X_train.txt", sep=" ", 
                         col.names=X.feature.names$feature.name)

#point 2: Extracts only the measurements on the mean and standard deviation 
#for each measurement. I did this by subsetting those columns containning
#"mean" or "std" in their names.
X.train.raw <- X.train.raw[, grepl("mean|std" , names(X.train.raw))]

#point 3: Uses descriptive activity names to name the activities in the data set.
y.train.raw <- read.table("./UCI HAR Dataset/train/y_train.txt",
                         col.names=c("activity.id"))
y.train.id2label <- join(y.train.raw, activity.id2labels)
activity.label <- y.train.id2label$activity.label

#Intermediate step: I used the subject ids stored in the subject_test.txt file
#contained in the getdata-projectfiles-UCI HAR Dataset.zip file.
subject.ids.train <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                               col.names=c("subject.id"))

#Intermediate step for point 1: I horizontally combine subject ids,
#activity labels, and measurement values.
train.data <- cbind(subject.ids.train, activity.label, X.train.raw)

#point 1:Merges the training and the test sets to create one data set.
whole.data <- rbind(test.data, train.data)
whole.data$subject.id <- as.factor(whole.data$subject.id)
#point 5: Creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject. 
library(reshape)
melted.whole.data <- melt(whole.data, id=c("subject.id", "activity.label"))
tidy.data <- cast(melted.whole.data, subject.id + activity.label~variable,
                       mean)
column.names <- colnames(tidy.data)
colnames(tidy.data) <- c(column.names[1:2],
                              paste("average.", 
                                    column.names[3:length(column.names)],
                                    sep=""))
write.table(tidy.data, file = "HAR_tidy.txt", row.names=F)
