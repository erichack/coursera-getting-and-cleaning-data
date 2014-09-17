library(reshape2)

#1. Merges the training and the test sets to create one data set.
#Get the feature list and activity label
activity_label<-read.table("./UCI HAR Dataset/activity_labels.txt")
features<-read.table("./UCI HAR Dataset/features.txt")
#Merge all test set data into 1 data set
testSet<-read.table("./UCI HAR Dataset/test/X_test.txt")
testLabel<-read.table("./UCI HAR Dataset/test/Y_test.txt")
testSubject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
testData<-cbind(testSet,testLabel,testSubject)
#Merge all train set data into 1 data set
trainSet<-read.table("./UCI HAR Dataset/train/X_train.txt")
trainLabel<-read.table("./UCI HAR Dataset/train/Y_train.txt")
trainSubject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
trainData<-cbind(trainSet,trainLabel,trainSubject)
#Merge test and train set into 1 data set
allData<-rbind(testData,trainData)

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
selectedCol<-grep("std\\(\\)|mean\\(\\)",features[,2])
allData<-allData[,c(selectedCol,length(allData)-1,length(allData))]


#3. Uses descriptive activity names to name the activities in the data set
allData[,length(allData)-1]<-as.character(activity_label[allData[,length(allData)-1],2])


#4. Appropriately labels the data set with descriptive variable names. 
colnames(allData) <- c(as.character(features[selectedCol,2]),"activity","subject")


#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
melt<-melt(allData,id=c("subject","activity"))
castData<-dcast(melt,subject+activity~variable,mean)
write.table(castData,file="tidy.txt",row.names=F)
