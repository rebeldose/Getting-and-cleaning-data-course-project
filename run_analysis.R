# Unzipping dataset to data folder

unzip(zipfile="./data/UCI HAR Dataset.zip",exdir="./data")

#loading the dplyr library for manipulating data

library(dplyr)

#reading training data

X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#reading the test data

X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#reading data description

variable_names <- read.table("./data/UCI HAR Dataset/features.txt")

#reading activity labels

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

#merging the traning and test sets to create one data set

X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

#extracting only the measurements on the mean and standard deviation 

selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

#using descriptive activity names to name the activities in the data set

colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

#labeling the data set with descriptive variable names

colnames(X_total) <- variable_names[selected_var[,1],2]

# creating independent tidy data set with the average of 
# each variable for each activity and each subject

colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./data/UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)




