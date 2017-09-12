

#Step 0: download packages and read the database
#------------------------------------------------

#Install packages required for the assigment

install.packages("dplyr")
library(dplyr)

#download the data located in URL and unzip file



url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

destination<-"C:/Users/s_alvalizarraga/Documents/R/UCI HAR Dataset.zip"

file<-"C:/Users/s_alvalizarraga/Documents/R/UCI HAR Dataset"

download.file(url,destination,mode="wb")

setwd("C:/Users/s_alvalizarraga/Documents/R")

unzip(destination, exdir = ".")


#read the data files located in directory


setwd(file)

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")


x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

#Step 1: combine data sets as requested in assigment
#---------------------------------------------------

#append training sets: train and test

x_append <- rbind(x_train, x_test)

#append training labels: train and test

y_append <- rbind(y_train, y_test)

#append subject data: train and test

subject_append <- rbind(subject_train, subject_test)


# Step 2: Extract only the mean and standard deviation for each variable
#------------------------------------------------------------------------

features_file <- read.table("features.txt")


# get column number for mean and standard deviation
mean_sd_col <- grep("-(mean|std)\\(\\)", features_file[, 2])


#obtain only the desired mean and standard deviation columns
x_subset <- x_append[, mean_sd_col]


# add names to columns in x_data subset
names(x_subset) <- features_file[mean_sd_col, 2]


# Step 3: use activity labels file to name the activities
#-----------------------------------------------------------------------------

activities_file <- read.table("activity_labels.txt")


# update values with correct activity names
y_append[, 1] <- activities_file[y_append[, 1], 2]


# change the column name in the y subset
names(y_append) <- "activities"


# Step 4: label the data set with descriptive variable names
#--------------------------------------------------------------

# correct column name
names(subject_append) <- "subjects"

#Step 5.0: combine the descriptive variable, the activity labels and the data sets
#-------------------------------------------------------------------------------

datasetfinal <- cbind(x_subset, y_append, subject_append)

#remove unwanted files

rm(activities_file,features_file,subject_append, subject_merge, subject_test, subject_train, x_append, x_merge, x_subset,x_test, x_train, y_append, y_merge, y_test, y_train)  
  

#label the final data set

names(datasetfinal) <- make.names(names(datasetfinal))
names(datasetfinal) <- gsub('Acc',"Acceleration",names(datasetfinal))
names(datasetfinal) <- gsub('GyroJerk',"AngularAcceleration",names(datasetfinal))
names(datasetfinal) <- gsub('Gyro',"AngularSpeed",names(datasetfinal))
names(datasetfinal) <- gsub('Mag',"Magnitude",names(datasetfinal))
names(datasetfinal) <- gsub('^t',"TimeDomain.",names(datasetfinal))
names(datasetfinal) <- gsub('^f',"FrequencyDomain.",names(datasetfinal))
names(datasetfinal) <- gsub('\\.mean',".Mean",names(datasetfinal))
names(datasetfinal) <- gsub('\\.std',".StandardDeviation",names(datasetfinal))
names(datasetfinal) <- gsub('Freq\\.',"Frequency.",names(datasetfinal))
names(datasetfinal) <- gsub('Freq$',"Frequency",names(datasetfinal))




#Step 5.1: create another data set with the average of each variable, for each activity and each subject
#----------------------------------------------------------------------------------------------------

meandata <-aggregate(datasetfinal, by=list(subject=datasetfinal$subjects, activity=datasetfinal$activities), 
                    FUN=mean, na.rm=TRUE)

meandata<-subset(meandata,select=-c(subjects, activities))

write.table(meandata, file = "tidydata.txt",row.name=FALSE)


