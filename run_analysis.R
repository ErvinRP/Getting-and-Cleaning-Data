library(dplyr)

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
sub_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
sub_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

vars<-read.table("./UCI HAR Dataset/features.txt")

activity<-read.table("./UCI HAR Dataset/activity_labels.txt")

X<-rbind(X_train, X_test)
y<-rbind(y_train, y_test)
sub<-rbind(sub_train, sub_test)

select_var<-vars[grep("mean\\(\\)|std\\(\\)", vars[, 2]),]
X<-X[, select_var[,1]]

colnames(y) <- "activity"
y$activity_name<- factor(y$activity, labels = as.character(activity[,2]))
labels<-y[,-1]

colnames(X) <- vars[select_var[,1],2]

colnames(sub) <- "subject"
total <- cbind(X, labels, sub)
total_m<-total %>% group_by(labels, subject) %>% summarize_each(funs(mean))
write.table(total_m, file = "./tidy.txt", row.names = F, col.names = T)