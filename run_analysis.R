setwd("./test")
test <- read.table("X_test.txt", sep = "", header = FALSE)
subjTest <- read.table("subject_test.txt")
tested_class <- read.table("y_test.txt")
setwd("..")
features <- read.table("features.txt", sep="", header = FALSE)
features <- features$V2
features <- as.character(features)
names(test) <- features
test$Type <- "Test"
setwd("./train")
train <- read.table("X_train.txt", sep = "", header = FALSE)
subjTrain <- read.table("subject_train.txt")
names(train) <- features
train$Type <- "Train"
merged <- rbind(test,train)
merged <- merged[,grepl("std|mean",x = names(merged))]
trained_class <- read.table("y_train.txt")
all_classes <- rbind(tested_class, trained_class)
all_classes <- rename(all_classes, ActivityType = V1)
fulldata <- cbind(merged, all_classes)
subjects <- rbind(subjTest, subjTrain)
subjects <- rename(subjects, SubjectsID = V1)
fulldata<- cbind(fulldata, subjects)
grouped <- group_by(fulldata, ActivityType, SubjectsID)
final <- summarise_each(grouped, funs(mean))
final$ActivityType[final$ActivityType == 1 ] <- "Walking"
final$ActivityType[final$ActivityType == 2 ] <- "Walking_upstairs"
final$ActivityType[final$ActivityType == 3 ] <- "Walking_downstairs"
final$ActivityType[final$ActivityType == 4 ] <- "Sitting"
final$ActivityType[final$ActivityType == 5 ] <- "Standing"
final$ActivityType[final$ActivityType == 6 ] <- "Laying"
setwd("..")
write.table(final, file = "course_project.txt", row.names = FALSE)

