install.packages("randomForest")
library(randomForest)
summary(iris)

result <- randomForest(Species~., data = iris)
result

result2 <- randomForest(iris[ , -5], iris[ , 5])
result2                      

setwd("~/Documents/OneDrive/Kaggler")
StartTM <- proc.time()
mydata <- read.table("train.csv", header = TRUE,  sep = ",")
mytest <- read.table("test.csv", header = TRUE, sep = ",")
proc.time() - StartTM

result <- randomForest(Species~.,importance=TRUE, data=iris)
result

result2 <- randomForest(x=iris[,-5], y=iris[,5])
result2

importance(result)

startTM <- proc.time()
RT <- randomForest(x=mydata[,-371], y=mydata[,371])
startTM - proc.time()


#sampling 
mydata <- kaggle
rm(kaggle)
sampleMD <- mydata[sample(1:nrow(mydata), nrow(mydata) * 0.01 , replace=FALSE), ]

rfrt <- randomForest(x = sampleMD[,-371], y = as.factor(sampleMD[,371]))
rfrt

startTM <- proc.time()
fit <- randomForest(as.factor(TARGET)~., importance = TRUE, data = sampleMD)
proc.time() - startTM
fit
varImpPlot(fit)

Prediction <- predict(fit, mytest, type = "prob")
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

#Ensembles tree
data(iris)
rf1 <- randomForest(Species ~ ., iris, ntree=50, norm.votes=FALSE)
rf2 <- randomForest(Species ~ ., iris, ntree=50, norm.votes=FALSE)
rf3 <- randomForest(Species ~ ., iris, ntree=50, norm.votes=FALSE)
rf.all <- combine(rf1, rf2, rf3)
print(rf.all)