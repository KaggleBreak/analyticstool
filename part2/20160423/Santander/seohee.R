setwd("~/Documents/OneDrive/Kaggler")
rdata<-read.csv("train.csv",header=T) #row data
test<-read.csv("test.csv",header = T)
summary(rdata)
dim(rdata) # 76020 371
data<-rdata[,-c(1,371)] # removing ID, TARGET col
data[!complete.cases(data),] # no NA row

library(caret)
nearZeroVar(data) # near 0 Var col searching
length(nearZeroVar(data)) # remove col, remain 54 var good 
data1<-data[,-nearZeroVar(data)] # new data after removing near 0 variance col
summary(data1)
colnames(data1)

cdata1<-cor(data1)
findCorrelation(cdata1,cutoff=0.8) 
data2<-data1[,-findCorrelation(cdata1,cutoff=0.8)] # remove high cor variable
colnames(data2)
dim(data2) # remain 26 col

fdata <- cbind(data2,rdata[,371]) # finally I get 27 variables
colnames(fdata)
fix(fdata)
summary(fdata[,27])

# SMOTE #
library(DMwR)
sdata<-SMOTE(TARGET~.,data=fdata,perc.over=400,perc.under=100) #TARGET class 불균형
table(sdata$TARGET)
table(rdata$TARGET)

# glm #
fdata$TARGET<-as.factor(fdata$TARGET)
str(fdata)
gm <- glm(TARGET~., data=sdata, family="binomial");gm # smote
gm1 <- glm(TARGET~., data=fdata, family="binomial");gm1 # no smote
result<-predict(gm, newdata=test,type="response")
result1<-predict(gm1, newdata=test,type="response")
result2<-matrix(result,75818,1)
result3<-matrix(result1,75818,1)
hist(result2)
hist(result3,xlim=c(0,0.3))
write.csv(result1,"result2.csv")