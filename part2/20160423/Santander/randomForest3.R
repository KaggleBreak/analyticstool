install.packages("randomForest")
library(randomForest)
summary(iris)

result <- randomForest(Species~., data = iris)
result

result2 <- randomForest(x=iris[,-5], y=iris[,5])
result2

importance(result)
varImpPlot(result)

setwd("~/Documents/OneDrive/Kaggler")
#setwd("C:/Users/CS Graduate Lab/OneDrive/Kaggler") windows

StartTM <- proc.time()
rawtrain <- read.table("train.csv", header = TRUE,  sep = ",")
mytest <- read.table("test.csv", header = TRUE, sep = ",")
proc.time() - StartTM

dim(rawtrain) # 76020 371
mytrain<-rawtrain[,-c(1,371)] # removing ID
dim(mytrain)
mytrain[!complete.cases(mytrain),] # no NA row

######################
#   preprocessing
######################
install.packages("caret")
library(caret)
nearZeroVar(mytrain) # near 0 Var col searching
length(nearZeroVar(mytrain)) # remove col, remain 54 var good 
data1 <- mytrain[,-nearZeroVar(mytrain)] # new data after removing near 0 variance col
summary(data1)
colnames(data1)

cdata1<-cor(data1)
findCorrelation(cdata1,cutoff=0.95) 
data2<-data1[,-findCorrelation(cdata1,cutoff=0.95)] # remove high cor variable
colnames(data2)
dim(data2) # remain 26 col

fdata <- cbind(data2,rawtrain[,371]) # attach TARGET Variable
colnames(fdata)
fix(fdata)
summary(fdata[,43])

# SMOTE #
install.packages("DMwR")
library(DMwR)
sdata<-SMOTE(TARGET~.,data=fdata,perc.over=400,perc.under=100) #TARGET class 불균형
table(sdata$TARGET)
table(rdata$TARGET)

#Modeling Random Forest whith preprocessed dataset
startTM <- proc.time()
rfrt <- randomForest(x = fdata[,-43], y = as.factor(fdata[,43]), importance = TRUE)
proc.time() - startTM 

startTM <- proc.time()
Prediction <- predict(rfrt, mytest)
proc.time() - startTM
submit <- data.frame(Prediction)
write.csv(submit, file = "result.csv", row.names = FALSE)

#sampling 
sampleMD <- mydata[sample(1:nrow(mydata), nrow(mydata) * 0.1 , replace=FALSE), ] #sampling
#sampleMD <- mydata[sample(1:nrow(mydata), nrow(mydata) , replace=FALSE), ] #use whole dataset

#modeling and prediction
startTM <- proc.time()
rfrt <- randomForest(x = sampleMD[,-43], y = as.factor(sampleMD[,43]), importance = TRUE)
startTM - proc.time()
rfrt
importance(rfrt)
varImpPlot(rfrt)

startTM <- proc.time()
Prediction <- predict(rfrt, mytest)
proc.time() - startTM

result <- data.frame(mytest$ID,Prediction)
write.csv(result, file = "result.csv", row.names = FALSE)


#
startTM <- proc.time()
fit <- randomForest(as.factor(TARGET)~., importance = TRUE, data = sampleMD)
proc.time() - startTM
fit
importance(fit)
varImpPlot(fit)

cbind(mytest$ID, rfrt)


startTM <- proc.time()
fit <- randomForest(as.factor(TARGET)~., importance = TRUE, data = mytrain)
proc.time() - startTM
#    user   system  elapsed 
#8577.268   13.709 8625.933 

fit
importance(fit)
varImpPlot(fit)

startTM <- proc.time()
Prediction <- predict(fit, mytest)
proc.time() - startTM
submit <- data.frame(Prediction)
write.csv(submit, file = "result.csv", row.names = FALSE)




rfrt <- randomForest(x = sampleMD[,-371], y = as.factor(sampleMD[,371]), 
                     importance = TRUE, 
                     xtest = mytest[,-371], ytest = as.factor(mytest[,371])
                     )

randomForest(x, y=NULL, xtest=NULL, ytest=NULL, ntree=500,
             mtry=if (!is.null(y) && !is.factor(y))
                     max(floor(ncol(x)/3), 1) else floor(sqrt(ncol(x))),
             replace=TRUE, classwt=NULL, cutoff, strata,
             sampsize = if (replace) nrow(x) else ceiling(.632*nrow(x)),
             nodesize = if (!is.null(y) && !is.factor(y)) 5 else 1,
             maxnodes = NULL,
             importance=FALSE, localImp=FALSE, nPerm=1,
             proximity, oob.prox=proximity,
             norm.votes=TRUE, do.trace=FALSE,
             keep.forest=!is.null(y) && is.null(xtest), corr.bias=FALSE,
             keep.inbag=FALSE, ...)
