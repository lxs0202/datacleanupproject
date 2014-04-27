#function to get "mean and std" variables by checking if the variable names contain
# "std()" or "mean()"

checkminandstd <-function(x) {
  grepl("mean()",x,ignore.case = TRUE,fixed = TRUE) | grepl("std()",x,ignore.case = TRUE,fixed = TRUE)| grepl("meanFreq()",x,ignore.case = TRUE,fixed = TRUE)
}

#function to replace numeric activities with activity names

nameactivity <- function(x) {
  if(x==1) {"WALKING"}
  else {
    if(x==2) { "WALKING_UPSTAIRS"}
    else {if(x==3) {"WALKING_DOWNSTAIRS"}
          else {if(x==4) {"SITTING"}
                
                else {if(x==5) {"STANDING"}
                      else {if(x==6) {"LAYING"}
                      }
                }
          }
    }
  }
  
}  




#read test data
test <- read.csv(file = "X_test.txt", sep = "" , header = FALSE)

train <- read.csv(file = "X_train.txt", sep = "" , header = FALSE)

#read test activity
test_act <-  read.csv(file = "y_test.txt", sep = "" , header = FALSE)

train_act <-  read.csv(file = "y_train.txt", sep = "" , header = FALSE)


# read subject for test file.
subject_test <- read.csv(file = "subject_test.txt", sep = "" , header = FALSE)

subject_train <- read.csv(file = "subject_train.txt", sep = "" , header = FALSE)


# read feature file and get the feature as a vector
feature <- read.csv(file = "features.txt", sep = "" , header = FALSE)

featuretext <- feature[,2]

#add feature name as header the test and train data

colnames(test)<-featuretext

colnames(train)<-featuretext 

#abstract the mean and std variables from test data and train data

test1 <- sapply(featuretext, checkminandstd )

test2 <- test[,test1]

train2 <- train[,test1]

# add subject column to test and train data
test2$subject <- subject_test[,1]

train2$subject <- subject_train[,1]


#transform the test activity to replace numeric data with names and add them into the test and traindata


test2$activity <- sapply(test_act[,1], nameactivity )

train2$activity <- sapply(train_act[,1], nameactivity )
#merge test and train data into one

test2<-rbind(test2, train2)


#using reshape package to get the average value for each subject and activity

library(reshape)



mdata <- melt(test2, id=c("subject","activity"))

testmean <- cast(mdata, subject + activity~variable, mean)

# write output to a file
output <- as.data.frame(testmean)

write.table(output, file= "tidydata.txt", sep=",")

