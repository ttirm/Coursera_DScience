library(dplyr)

#Read files
#Features
features <-read.table("./DataSets/UCI HAR Dataset/features.txt", sep = "")
#Activity Labels
activity_labels <-read.table("./DataSets/UCI HAR Dataset/activity_labels.txt", sep = "", colClasses = c("numeric", "factor"), col.names=c("label", "labelName"))
#Training Suject
subject <-read.table("./DataSets/UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"), sep = "")
#Training Set
xtrain <-read.table("./DataSets/UCI HAR Dataset/train/x_train.txt", sep = "", col.names=features$V2)
#Training Label
ytrain <-read.table("./DataSets/UCI HAR Dataset/train/y_train.txt", col.names=c("label"), sep = "", colClasses = c("factor"))
#Test Suject
tsubject <-read.table("./DataSets/UCI HAR Dataset/test/subject_test.txt", col.names=c("subject"), sep = "")
#Test Set
xtest <-read.table("./DataSets/UCI HAR Dataset/test/x_test.txt", sep = "", col.names=features$V2)
#Test Label
ytest <-read.table("./DataSets/UCI HAR Dataset/test/y_test.txt", col.names=c("label"), sep = "", colClasses = c("factor"))


#First question
#Merging files
ymerged <- rbind(ytrain,ytest)
xmerged <- rbind(xtrain, xtest)
tmerged <- rbind(subject,tsubject)
data.init <- cbind(tmerged, ymerged, xmerged)


#Second question
#Extracts only the measurements on the mean and standard deviation for each measurement
data.sec <- data.init[,c(names(data.init)[1:2], names(data.init)[grep("[Mm]ean|[Ss]td",names(data.init))])]

#Third question
#Uses descriptive activity names to name the activities in the data set
data.labels <- merge(data.sec,activity_labels,all = TRUE )

#Fourth question
#Appropriately labels the data set with descriptive variable names
names(data.labels) <- gsub("\\.","",gsub("(\\.[a-z])","\\U\\1",names(data.labels),perl=TRUE),perl=TRUE)

#Fifth question
# creates tidy data set with the average of each variable for each activity and each subject
data.grouped <- group_by(select(data.labels,-label),labelName, subject)
data.tidy <- summarise_each(data.grouped,funs(mean))
write.table(data.tidy, file = "./DataSets/tidydata.txt", row.names = FALSE)

