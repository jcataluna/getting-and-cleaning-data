require(pylr)
#
# 1. Download and extraction of zip file

zipFileName <- "data/Dataset.zip"
if(!file.exists("./data")) {
    dir.create("./data")
}

if (!file.exists(zipFileName)) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = zipFileName, method = "curl")
    dateDownloaded <- date()
    file <- file("data/date_downloaded.txt")
    writeLines(paste("File ", zipFileName, " downloaded on ", dateDownloaded), file)
    close(file)    
    unzip(zipfile=zipFileName ,exdir="./data")
}

# Get the file list
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

# load factors
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./data/UCI HAR Dataset/features.txt")[,2]

# load data
training_X_Set         <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
training_y_Labels      <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
trainingSubjects    <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

test_X_Set             <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_y_Labels          <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
testSubjects        <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Merge data
all_X_Set      <- rbind(training_X_Set, test_X_Set)
all_y_Labels   <- rbind(training_y_Labels, test_y_Labels)
allSubjects <- rbind(trainingSubjects, testSubjects)

# Change column names and types
names(all_X_Set) <- features
names(all_y_Labels) <- "Activity"
names(allSubjects) <- "Subject"

###################################################################
# Question 2: Extract just mean and standard deviation
###################################################################
mean_std_features <- grepl("mean|std", features, ignore.case = TRUE)
all_X_Set <- all_X_Set[, mean_std_features]

###################################################################
# Question 1: Merge all data together
###################################################################
dataSet <- cbind(all_y_Labels, allSubjects, all_X_Set )

###################################################################
#  Question 3: Make use of factors for clarity changin column to factor
#              with labels from activity_labels
###################################################################
dataSet[,1] <- factor(dataSet[,1], labels = activity_labels)

###################################################################
# Question 4. Better names
###################################################################
names(dataSet) <- gsub('std\\(\\)', 'StandardDeviation', names(dataSet)) 
names(dataSet) <- gsub('Acc',"Acceleration",names(dataSet))
names(dataSet) <- gsub('GyroJerk',"AngularAcceleration",names(dataSet))
names(dataSet) <- gsub('Gyro',"AngularSpeed",names(dataSet))
names(dataSet) <- gsub('Mag',"Magnitude",names(dataSet))
names(dataSet) <- gsub('^t',"Time",names(dataSet))
names(dataSet) <- gsub('^f',"FrequencyDomain",names(dataSet))
names(dataSet) <- gsub('\\.mean\\(\\)',".Mean",names(dataSet))
names(dataSet) <- gsub('Freq\\(\\)',"Frequency.",names(dataSet))
names(dataSet) <- gsub('Freq$',"Frequency",names(dataSet))

###################################################################
# Question 5. Average by subject and activity
###################################################################
average_by_subject_and_activity <- ddply(dataSet, c("Subject","Activity"), numcolwise(mean))
write.csv(average_by_subject_and_activity, file = "average_by_subject_and_activity.csv" )

