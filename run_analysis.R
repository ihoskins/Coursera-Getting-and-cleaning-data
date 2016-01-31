# run_analysis.R script for tidying and summarizing Samsung Galaxy S2 cell activity monitor datasets
# assumes working directory is UCI HAR Dataset/

### Install dependencies if needed, attach dplyr
if("dplyr" %in% rownames(installed.packages()) == FALSE){
  install.packages("dplyr")
}
library(dplyr)

### Get file names
# Store names of pertinent files from test and train sets
test_files<-list.files(pattern="test.txt$",path="./test",full.names=TRUE)
train_files<-list.files(pattern="train.txt$",path="./train",full.names=TRUE)
test_files_short<- sapply(strsplit(test_files,split="/"),"[",3)
train_files_short<- sapply(strsplit(train_files,split="/"),"[",3)

### Read in files
# Read in the three files per test and train set, store as list of data frames
test_df_list<- lapply(test_files,read.table,colClasses="numeric",nrows=2947,comment.char="")
train_df_list<- lapply(train_files,read.table,colClasses="numeric",nrows=7352,comment.char="")
names(test_df_list)<- sapply(strsplit(test_files_short,split=".",fixed=TRUE),"[",1)
names(train_df_list)<- sapply(strsplit(train_files_short,split=".",fixed=TRUE),"[",1)
# Read in activity labels
activity_labels<- read.table(file="activity_labels.txt")[[2]]
# Read in feature/variable names and format
feature_names<- sapply(strsplit(readLines("features.txt"),split=" "),"[",2)
feature_names_format1<- gsub(pattern="[()]",replacement="",x=feature_names)
feature_names_format2<- gsub(pattern="-",replacement=".",x=feature_names_format1)
feature_names_format3<- gsub(pattern=",",replacement="_",x=feature_names_format2)
varnames<- c("Subject","Activity.number",feature_names_format3)

### Parse data frames
# Concatenate list dfs into one test and train df
test_df<- cbind(test_df_list$subject_test,test_df_list$y_test,test_df_list$X_test)
train_df<- cbind(train_df_list$subject_train,train_df_list$y_train,train_df_list$X_train)
# Generate test+train dataset
all_df<- rbind(test_df,train_df)
# Assign formatted variable names
names(all_df)<- varnames
# Generate logical of mean and std variables
mean_std_logical<- c(TRUE,TRUE,grepl(pattern="mean",x=varnames[-(1:2)])|grepl(pattern="std",x=varnames[-(1:2)]))
# Subset down to mean and std variables
all_subset_df<- all_df[,mean_std_logical]

### Summarize results
# Assign activity labels, coerce grouping variables to factors
all_subset_df$Activity.label<- activity_labels[all_subset_df$Activity.number]
all_subset_df$Subject<- as.factor(all_subset_df$Subject)
# Generate summary
summary_df<- group_by(all_subset_df,Activity.label,Subject) %>% summarize_each(funs="mean")
write.table(x=summary_df,file="HAR_summary.txt",sep="\t",row.names=FALSE,col.names=TRUE,quote=FALSE)
