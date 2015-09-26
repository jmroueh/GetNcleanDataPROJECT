# GetNcleanDataPROJECT
# Getting and Cleaning Data Project Assignment
Script to read in Activity Recognition data and merge for analysis
Jawad Mroueh 26Sep15

The run_analysis.R script is created in order to read in test and training datasets, merge the datasets, and perform basic averaging calculations on the
mean and standard deviations variables. The output consists of a table grouping by subject and by activity type.

* Original test data is read in using read.table(), variable names and subject id's are also read into R and combined into one test dataframe

* A similar operation is completed on the training datasets which matches the format of the test dataset.

* The two dataframes are merged together, and since there is no overlap in the subjects, cbind() command is used to merge the combined dataframe "merged"

* The grep() function is used to find column names containing "mean" and "std", and a new dataframe is extracted for those specific columns "extracted_df"

* Activity labels are read in using the provided "activity_labels.txt" file and a new column is added for the activity description

* The "dplyr" package is used to group the dataframe by subject and activity and summarize the data using the mean() function

* write.table() function is used to output the final table to a "txt" file.
