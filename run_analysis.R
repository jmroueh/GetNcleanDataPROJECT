# Script to read in Activity Recognition data and merge for analysis
# Jawad Mroueh 26Sep15

run_analysis <- function() {
        # Reading in test data and combining into one labeled dataframe "test_df"
        test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")                            # reads test features vectors
        features  <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = F)    # reads features.txt file to get column labels
        names(test) <- features$V2                                                              # assigns column labels to test dataframe
        testSubjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")              # reads in test subjects ids
        test_df <- cbind(testSubjects, test)                                                    # adds columns for test subjects ids
        names(test_df)[1] <- "subject_id"                                                       # labels columns for test ids
        testactivity <- read.table("./data/UCI HAR Dataset/test/y_test.txt")                    # reads in test activity code for each subject
        test_df <- cbind(test_df, testactivity)                                                 # adds activity column at the last column of dataframe
        names(test_df)[ncol(test_df)] <- "activity_code"                                        # labels added column for activity
        test_df$subject_cat <- "test"
        
        # Reading in train data and combining into one labeled dataframe "train_df"
        train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")                         # reads train features vectors
        names(train) <- features$V2                                                             # assigns column labels to train dataframe
        trainSubjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")           # reads in train subjects ids
        train_df <- cbind(trainSubjects, train)                                                 # adds columns for train subjects ids
        names(train_df)[1] <- "subject_id"                                                      # labels columns for train ids
        trainactivity <- read.table("./data/UCI HAR Dataset/train/y_train.txt")                 # reads in train activity code for each subject
        train_df <- cbind(train_df, trainactivity)                                              # adds activity column at the last column of dataframe
        names(train_df)[ncol(train_df)] <- "activity_code"                                      # labels added column for activity
        train_df$subject_cat <- "train"
        
        merged <<- rbind.data.frame(test_df, train_df)                                          # rbinds data frames since there are no repetetion of subjects
        
        # Extract mean and standard deviation summarized variables
        merged_colnames <- names(merged)                                                        # extracts names of the merged dataframe
        mean_indices <- grep("mean", merged_colnames)                                           # finds column indices containing "mean"
        std_indices <- grep("std",merged_colnames)                                              # finds column indices containing "std"
        extracted_df <- merged[,c(1,ncol(merged),ncol(merged)-1,mean_indices,std_indices)]      # extracts subsetted dataframe for meand and std
        
        # Name the activities in the dataset according to codes
        activity_lbl  <- read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F) # reads in activity labels
        activity_vector <- activity_lbl[,2]                                                             # creates an activity character vector
        extracted_df$activity_descr <- activity_vector[extracted_df$activity_code]                      # adds a column for the activity description
        
        # Label the data set with descriptive variable names
        names(extracted_df) <-make.names(names(extracted_df))    # Syntactically valid by removing pretencies and "-" from the variable names

        # Group by subject and activity and then calculates the mean of each
        library(dplyr)
        grouped <- group_by(extracted_df, subject_id, activity_descr)                           # use group_by function of dplyr package
        final_tbl<-summarise_each(grouped,funs(mean),-subject_cat)                              # excluded subject category
        write.table(final_tbl,file = "./data/UCI HAR Dataset/final_tbl.txt", row.names = F)     # writes output to file
        }