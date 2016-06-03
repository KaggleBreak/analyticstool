#1. PCA
setwd("/Users/syleeie/downloads")
de <- read.csv("destinations.csv", header=T)
head(de)
dim(de)
ir.pca <- prcomp(de, center = TRUE, scale. = TRUE)
de2 <- predict(ir.pca, newdate=de)
dim(de2)
head(de2)
head(de)
summary(ir.pca)
write.csv(de2, "E:/kaggle/expedia/destinations2.csv", row.names=F)

#2.데이터 로딩
install.packages("h2o")
library(h2o)
setwd("/Users/syleeie/downloads")
library(data.table)

expedia_train <- fread("train_re.csv")
expedia_test <- fread("test_re.csv")

head(expedia_train)
head(expedia_test)
tail(expedia_test)
head(sb)
tail(sb)
colnames(expedia_train)[1] <- c("id")
colnames(expedia_test)[1] <- c("id")

str(expedia_train)
expedia_train$hotel_cluster <- as.factor(expedia_train$hotel_cluster)

expedia_train <- expedia_train[, !c("id", "dateset"), with=FALSE]
expedia_test <- expedia_test[, !c("id", "dateset"), with=FALSE]

head(expedia_train)
head(expedia_test)
dim(expedia)
dim(train)
dim(test)

set.seed(2310)
n = nrow(expedia_train)
idx = sample(1:n, size=floor(6*n/10), replace=FALSE)

train_train <- expedia_train[idx,]
train_vaild <- expedia_train[!idx,]
unique(train_train$hotel_cluster)
unique(train_vaild$hotel_cluster)
unique(test$hotel_cluster)

#3. 모델링
library(h2o)
h2o.shutdown(prompt = TRUE)
?h2o.init
localh2o <- h2o.init(ip="localhost",port=54321,startH2O=T,max_mem_size='8g',nthreads = -1)
train.h2o <- as.h2o(train_train)
vaild.h2o <- as.h2o(train_vaild)
test.h2o <- as.h2o(expedia_test)

NN_model <- h2o.deeplearning(x = 1:26, y = 27,
                             training_frame = train.h2o,
                             validation_frame = vaild.h2o,
                             hidden = c(100, 100, 100),
                             epochs = 100,
                             balance_classes = F,
                             fast_mode = T,
                             seed = 2310, 
                             input_dropout_ratio = 0.2,
                             hidden_dropout_ratio=c(.2,.3,.2),
                             activation = 'RectifierWithDropout'
)
summary(NN_model)
predictions <- h2o.predict(NN_model, test.h2o, type="prob")


rm(train_train, train_vaild, expedia_test, expedia_train)

head(sb)
head(predictions)
pred2 <-as.data.table(predictions[1:100000,-1])
pred2 <-rbindlist(list(pred2, as.data.table(predictions[100001:200000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[200001:300000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[300001:400000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[400001:500000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[500001:600000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[600001:700000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[700001:800000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[800001:900000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[900001:1000000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1000001:1100000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1100001:1200000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1200001:1300000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1300001:1400000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1400001:1500000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1500001:1600000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1600001:1700000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1700001:1800000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1800001:1900000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[1900001:2000000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[2000001:2100000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[2100001:2200000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[2200001:2300000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[2300001:2400000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[2400001:2500000,-1])),use.names=T, fill=T)
pred2 <-rbindlist(list(pred2, as.data.table(predictions[2500001:2528243,-1])),use.names=T, fill=T)

dim(pred2)
colnames(pred2) <- c('0',
                     '1','10','11','12','13','14','15','16','17','18','19',
                     '2','20','21','22','23','24','25','26','27','28','29',
                     '3','30','31','32','33','34','35','36','37','38','39',
                     '4','40','41','42','43','44','45','46','47','48','49',
                     '5','50','51','52','53','54','55','56','57','58','59',
                     '6','60','61','62','63','64','65','66','67','68','69',
                     '7','70','71','72','73','74','75','76','77','78','79',
                     '8','80','81','82','83','84','85','86','87','88','89',
                     '9','90','91','92','93','94','95','96','97','98','99')

head(pred2)
#write.csv(pred2, "pred2.csv", row.names = F)
#testpred <- apply(pred2, 1, function (x) paste(order(-x)[1:5]-1, collapse = " "))
#sb$hotel_cluster <- testpred
#write.csv(sb, "test2_submission.csv", row.names = F)

head(pred2)
rm(rank_df)
rank_df = as.data.table(t(apply(-pred2[1:100000], MARGIN = 1, rank, ties.method = "first")))
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[100001:200000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[200001:300000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[300001:400000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[400001:500000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[500001:600000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[600001:700000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[700001:800000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[800001:900000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[900001:1000000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1000001:1100000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1100001:1200000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1200001:1300000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1300001:1400000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1400001:1500000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1500001:1600000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1600001:1700000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1700001:1800000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1800001:1900000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[1900001:2000000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[2000001:2100000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[2100001:2200000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[2200001:2300000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[2300001:2400000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[2400001:2500000], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)
rank_df = rbindlist(list(rank_df,as.data.table(t(apply(-pred2[2500001:2528243], MARGIN = 1, rank, ties.method = "first")))),use.names=T, fill=T)

rm(rank_df_names)
rank_df_names = colnames(rank_df)
extract_colname = function(x, rank = ncol(x)){
  rank_df_names[which(x == rank)]
}

rm(testpred)
testpred <- apply(rank_df, 1, function (x) paste(extract_colname(x,1),extract_colname(x,2),extract_colname(x,3),extract_colname(x,4),extract_colname(x,5),collapse=" "))
rm(sb)
sb <- read.csv("sample_submission.csv", header=T, stringsAsFactors=F)
sb$hotel_cluster <- testpred
write.csv(sb, "testall_submission.csv", row.names = F)