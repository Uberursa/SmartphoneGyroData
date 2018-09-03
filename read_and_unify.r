library(dplyr)

# read in the names
stat_names <- read.table("features.txt")
relevant_names <- stat_names[grepl("mean|std", stat_names$V2, ignore.case = TRUE),]

# read in and combine all the Data
test_subjects <- read.table("test/subject_test.txt")
test_activity <- read.table("test/y_test.txt")
test_summary <- read.table("test/X_test.txt")

test_data <- cbind(test_subjects, test_activity, test_summary[as.numeric(relevant_names$V1)])

train_subjects <- read.table("train/subject_train.txt")
train_activity <- read.table("train/y_train.txt")
train_summary <- read.table("train/X_train.txt")

train_data <- cbind(train_subjects, train_activity, train_summary[as.numeric(relevant_names$V1)])

# keeps the oder in tact for naming accuracy
gyro_data <- as.data.frame.matrix(rbind(test_data, train_data))
colnames(gyro_data) <- c("subject", "activity", as.character(relevant_names$V2))

# group on subject and activity
avg_data <- gyro_data %>% 
  group_by(subject, activity) %>%
  summarise_all("mean")

# write to csv
write.csv(gyro_data, file="tidy_data.csv")
write.csv(avg_data, file="tidy_mean_data.csv")