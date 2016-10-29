getwd()
setwd("C:/Users/tiago_000/Documents//GitHub/R_progamming")
if(!file.exists("data_cleaning")){
    dir.create("data_cleaning")
}
library(dplyr)

#Suject
subject <-read.table("./data_cleaning/UCI HAR Dataset/train/subject_train.txt", col.names=c("subject"), fill=FALSE,strip.white=TRUE)

#Training Set
xtrain <-read.table("./data_cleaning/UCI HAR Dataset/train/x_train.txt")

#Training Label
ytrain <-read.csv("./data_cleaning/UCI HAR Dataset/train/y_train.txt", col.names=c("label"), na.strings = c("NA", "") )
#Training Files
body_acc_x_train <-read.table("./data_cleaning/UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt", na.strings = c("NA", "") )
body_acc_y_train <-read.table("./data_cleaning/UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt")
body_acc_z_train <-read.table("./data_cleaning/UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt")
total_acc_x_train <-read.table("./data_cleaning/UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
total_acc_y_train <-read.table("./data_cleaning/UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt")
total_acc_z_train <-read.table("./data_cleaning/UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt")
body_gyro_x_train <-read.table("./data_cleaning/UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt")
body_gyro_y_train <-read.table("./data_cleaning/UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt")
body_gyro_z_train <-read.table("./data_cleaning/UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt")
head(body_acc_x_train,10)
tail(body_acc_x_train,10)
length(body_acc_x_train$V1)
str(body_acc_x_train$V1)
summary(body_acc_x_train$V1,10)
length(ytrain$label)