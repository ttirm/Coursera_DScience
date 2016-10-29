getwd()
setwd("C:/Users/tiago_000/Documents/GitHub/MachineLearning_4")
getwd()

library(caret)

download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv","./data/pml-training.csv", mode="wb")
training <- read.csv("./data/pml-training.csv")
download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv","./data/pml-testing.csv", mode="wb")
testing <- read.csv("./data/pml-testing.csv")


training1 <- as.data.frame(lapply(training[,8:159], as.numeric))

hist(training1$gyros_belt_y)


preObj <- preProcess(training1, method = c("knnImpute", "center", "scale"))
training1 <- predict(preObj, training1)
testing1 <- predict(preObj, testing[,8:159])
trainingC <- data.frame(training[1:7],training1, class = training[,160])

inTrain <- createDataPartition(y = trainingC$class, p = 0.6, list = FALSE )

train <- trainingC[inTrain,]
test <- trainingC[-inTrain,]

sum(complete.cases(trainingC) == FALSE)
testingC <- data.frame(testing[1:7],testing1, classe = testing[,160])

# ensure the results are repeatable
set.seed(7)
# load the library
library(mlbench)

# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
results <- rfe(trainingC[,8:159], trainingC[,160], sizes=c(1:151), rfeControl=control)
# summarize the results
print(results)
# list the chosen features
predictors(results)
# plot the results
plot(results, type=c("g", "o"))

# ensure the results are repeatable
set.seed(7)

# calculate correlation matrix
correlationMatrix <- cor(trainingC[,7:159])
# summarize the correlation matrix
print(correlationMatrix)
# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.5)
# print indexes of highly correlated attributes
print(highlyCorrelated)
trainingC1 <- trainingC[,7:159]
tc2 <- trainingC1[,-highlyCorrelated]
dim(tc2)
tc3 <- data.frame(tc2, classe = trainingC[,160])
tc3
model <- train(classe~., method = "rf", data = tc3)
res <- predict(model, testingC)
confusionMatrix(res,testingC$classe)
