# DataCleaning
Coursera data cleaning

This project performes several modifications in a data set, returning as output a tidy data set.

Data Source:

site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


The dataset includes the following files:
=========================================

- 'README.txt'

- 'tidydata.txt': Tidy data set, with the average measurements per subject and label name.

- 'CodeBook.md': Description of the executed steps.

- 'run_analysis': R script to perform the analysis.


Steps
------------

The present document describes the arranjements performed in the data set

1. Both test and train data files (feactures, subject, 	activity_labels, x, y) were stored in variables.

2. Test and train variables were merged with rbind() to join all the observations for each feacture.

3. Test and train features were merged with cbind() to join all 	the feactures in one table.

4. Were extracted measurements on the mean and standard deviation for each measurement.

5. The activity labels

- 1 WALKING
- 2 WALKING_UPSTAIRS
- 3 WALKING_DOWNSTAIRS
- 4 SITTING
- 5 STANDING
- 6 LAYING 

 were merged with the data table.

6. The features names were changed, eliminating spaces and pontuation.

7. Were extracted a grouped data per label name and subject and returned an average of each variable. 


