# Step1. Merges the training and the test sets to create one data set.
setwd("E:/DataScience/GETTING AND CLEANING DATA/WEEK 4/UCI HAR Dataset")
q1test<-read.table("./test/y_test.txt")
q1train<- read.table("./train/y_train.txt")
label<-  rbind(q1test,q1train)
labeltrain<- read.table("./train/X_train.txt")
labeltest<- read.table("./test/X_test.txt")
setdata<- rbind(labeltest, labeltrain)
subjecttrain<- read.table("./train/subject_train.txt")
subjecttest<- read.table("./test/subject_test.txt")
subject<- rbind(subjecttest, subjecttrain)
feature<- read.table("features.txt")
colnames(setdata)<- feature$V2
names(subject)<- "subject_id"
names(label)<- "activity_id"
fulldata<- cbind(subject, label, setdata)

# Step2. Extracts only the measurements on the mean and standard 
# deviation for each measurement.
meanid<- grep("mean", names(fulldata))
stdid<- grep("std", names(fulldata))
mean<- names(fulldata)[meanid]
std<- names(fulldata)[stdid]
meanstd<- fulldata[,c("activity_id","subject_id",mean,std)]

# Step3.Uses descriptive activity names to name the activities in the data set
fulldata$activity_id[fulldata$activity_id==1]<- "WALKING"
fulldata$activity_id[fulldata$activity_id==2]<- "WALKING_UPSTAIRS"
fulldata$activity_id[fulldata$activity_id==3]<- "WALKING_DOWNSTAIRS"
fulldata$activity_id[fulldata$activity_id==4]<- "SITTING"
fulldata$activity_id[fulldata$activity_id==5]<- "STANDING"
fulldata$activity_id[fulldata$activity_id==6]<- "LAYING"
fulldata$activity_id<- as.factor(fulldata$activity_id)
fulldata$subject_id<- as.factor(fulldata$subject_id)

# Step4. tidy dataset

master<- data.table(fulldata)
fulldata<- master[,lapply(.SD,mean), by= 'subject_id,activity_id']
write.table(fulldata, file = "tidy.txt", row.names = FALSE)


