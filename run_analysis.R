# Reads a set of data and builds a new smaller and tidy dataset from them


#   0.- Reading data from files

#TEST set
measurements_test=read.table("./UCI HAR Dataset/test/X_test.txt") # dimensions 2947*561
activities_test=read.table("./UCI HAR Dataset/test/y_test.txt") # dimensions 2947*1  #activities
subjects_test=read.table("./UCI HAR Dataset/test/subject_test.txt") #dimensions 2947*1 #subjects



#TRAIN set
measurements_train=read.table("./UCI HAR Dataset/train/X_train.txt") # dimensions 2947*561
activities_train=read.table("./UCI HAR Dataset/train/y_train.txt") # dimensions 2947*1  #activities
subjects_train=read.table("./UCI HAR Dataset/train/subject_train.txt") #dimensions 2947*1 #subjects


#labels
feature_names=read.table("./UCI HAR Dataset/features.txt") #dim 561*2
activity_names=read.table("./UCI HAR Dataset/activity_labels.txt")


#   1.- merge test & trainig set

all_data=rbind(measurements_train,measurements_test)
all_activities=rbind(activities_train,activities_test)
all_subjects=rbind(subjects_train,subjects_test)
        
#   2.- extract mean and std features
sss=grep("mean",feature_names$V2)
sss2=grep("std",feature_names$V2)
ss3=c(sss,sss2) #combines all indexes with mean and std values
sort(ss3)
extracted_data=all_data[,ss3]


#   3.- descriptive activity names

actNames=factor(all_activities$V1,levels=activity_names$V1,labels=activity_names$V2)


#   4.- descriptive variable names
extracted_features=feature_names$V2[ss3] #class factor

#   5.- Tidy dataset

#composing all dataset
dataset=cbind(actNames,all_subjects,extracted_data)
names(dataset)=c( "ActivityName","IDSubject",as.character(extracted_features))
#sorting dataset by Activity (first criteria) and Subject ID (second criteria)
dataset=dataset[order(dataset$ActivityName,dataset$IDSubject), ]



dmelt=melt(dataset,id.vars=c("ActivityName","IDSubject"))
x=dcast(dmelt,ActivityName+IDSubject ~variable,mean)


#change names and include average in each


feat_c=paste("Average",as.character(extracted_features))
names(x)=c( "ActivityName","IDSubject",feat_c)


