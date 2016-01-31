#README for run_analysis.R

**Dataset**

This script uses multiple files from the Human Activity Recognition Using Smartphones
dataset, which utilizes Samsung Galaxy S II accelerometer technology.

UCI Machine Learning Repository dataset information:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data download:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

**Dependencies**

dplyr package

**Script summarization**

Pre-processed, normalized data from the dataset is combined and subsetted for mean and 
standard deviation measurements. Variable names are reformatted to be tidy. Then average 
monitoring measurements for each unique activity and test subject are generated in a table. 
Activities are walking, walking upstairs, walking downstairs, sitting, standing and laying.
Output is a simple table named HAR_summary.txt
