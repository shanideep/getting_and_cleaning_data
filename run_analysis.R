##Coursera Assignment for Getting and Cleaning Data

##Read activities and column name
activity_labels <- read.table("./activity_labels.txt",col.names=c("activity_id","activity_name"))

##Read features
features <- read.table("./features.txt")
features_list <- features[,2]

##Read test data and and name the column
X_test <- read.table("./test/X_test.txt")
colnames(X_test) <- features_list

##Read training data and name the column
X_train <- read.table("./train/X_train.txt")
colnames(X_train) <- features_list

##Read subject test and name the column
subject_test <- read.table("./test/subject_test.txt")
colnames(subject_test) <- "subject_id"

##Read activities from y_test and name the column
y_test <- read.table("./test/y_test.txt")
colnames(y_test) <- "activity_id"

##Read subject train and name the column
subject_train <- read.table("./train/subject_train.txt")
colnames(subject_train) <- "subject_id"

##Read activities from y_train and name the column
y_train <- read.table("./train/y_train.txt")
colnames(y_train) <- "activity_id"

##Combine test and train data
test_activities <- cbind(subject_test , y_test , X_test)
train_activities <- cbind(subject_train , y_train , X_train)

##Append test and train data
complete_data <- rbind(train_activities,test_activities)

##Keep only mean and std cols
mean_cols <- grep("mean",names(complete_data),ignore.case=TRUE)
mean_col_names <- names(complete_data)[mean_cols]
std_cols <- grep("std",names(complete_data),ignore.case=TRUE)
std_col_names <- names(complete_data)[std_cols]
meanstddata <-complete_data[,c("subject_id","activity_id",mean_col_names,std_col_names)]

##Merge datasets
final_data <- merge(activity_labels,meanstddata,by.x="activity_id",by.y="activity_id",all=TRUE)

##Calculate average of each variable for each activity and each subject
melted_data <- melt(final_data, id = c("subject_id", "activity_name", "activity_id"))
cast_data <- dcast(melted_data, subject_id + activity_id ~ variable, mean)

##Create independent tidy dataset
write.table(cast_data, "tidy.txt", row.names = FALSE, quote = FALSE)
