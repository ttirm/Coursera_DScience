library(caret)
library(rpart)

download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv","./data/pml-training.csv", mode="wb")
download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv","./data/pml-testing.csv", mode="wb")

#Data Loading
training <- read.csv("./data/pml-training.csv", na.strings=c("", "NA", "#DIV/0!"))
testing <- read.csv("./data/pml-testing.csv", na.strings=c("", "NA", "#DIV/0!"))

#Select variables with more than 50% of complete values
training2 <- training
training3 <- as.data.frame(lapply(training2, function(x)sum(is.na(x ))/length(x)))
training2 <- training2[,which(colMeans(training3)<0.5)]
sum(complete.cases(training2)== FALSE)

dim(testing)
str(testing)
testing <- testing[,which(colMeans(training3)<0.5)]

#Pre-processing
preObj <- preProcess(training2, method = c("center", "scale"))
training1 <- predict(preObj, training2)
testing1 <- predict(preObj, testing)
str(training1)

#Create data partition
trainingC <- data.frame(training1)
inTrain <- createDataPartition(y = trainingC$classe, p = 0.6, list = FALSE )
train <- trainingC[inTrain,]
test <- trainingC[-inTrain,]

set.seed(1904)
str(train)
trainingC1 <- train[,-c(1:6,60)]
str(trainingC1)
# calculate correlation matrix
correlationMatrix <- cor(trainingC1)
# summarize the correlation matrix
print(correlationMatrix)
# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.75)
# print indexes of highly correlated attributes
print(highlyCorrelated)

tc2 <- trainingC1[,-highlyCorrelated]
str(tc2)
tc3 <- data.frame(train[,5:6],tc2, classe = train[,60])



cv.ctrl <- trainControl(method = "repeatedcv", number = 10, repeats = 3, 
                        classProbs = TRUE)



model_svm <- train(classe ~ ., method = "svmRadial", trControl = cv.ctrl, data = tc3, verbose = FALSE)
res <- predict(model_svm, test)
confusionMatrix(res,test$classe)


model_rf <- train(classe ~ ., method = "rf", data = tc3)
res <- predict(model_rf, test)
confusionMatrix(res,test$classe)

eval <- predict(model_rf, testing1)
