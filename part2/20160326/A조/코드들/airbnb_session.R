install.packages("sqldf")
install.packages("plyr")
install.packages("dplyr")
install.packages("tcltk")
library(sqldf)
library(plyr)
library(dplyr)
library(tcltk)

dataS<-fread('sessions.csv',stringsAsFactors = FALSE,data.table = FALSE) # 600Mb
train<-read.csv('train_users_2.csv',stringsAsFactors = FALSE)
test<-read.csv('test_users.csv',stringsAsFactors = FALSE)

#34496개의 ''빈id들이 존재
sum(dataS$user_id == '')

#session을 분석하는데 ''빈아이디는 의미가 없다.
filter(dataS,user_id!='')->dataS


d_user <- sqldf("SELECT DISTINCT user_id FROM dataS")

#10533241개의 row가 있지만 실제로 unique한 id의 갯수는 135483개이다.
dataS <- cbind(1:10533241,dataS)
head(dataS,3)

dataS[,8]<-0
head(dataS,3)

#key값
names(dataS)[1]<-'id'
#마지막 각 유저 id의 마지막 row인지 아닌지를 나타내는 지표
names(dataS)[8]<-'lastrow_or_not'

#ID가 바뀌는 곳에서 FALSE(0)값 체크.=> 각 id의 마지막 row를 찾기 위해서
dataS[1:10533240,8]=(dataS[1:10533240,2]==dataS[2:10533241,2])
head(dataS,3)
tail(dataS,3)

#유저의 마지막 행동이 무엇인지 알아보기 위해서 
data_temp <- sqldf("SELECT user_id,action FROM dataS WHERE lastrow_or_not=0")
head(data_temp,3)

names(data_temp)[2]='last_action'

#135483 session에서 초가 na인 row숫자
sum(is.na(dataS$secs_elapsed))
#빈칸은 0개
sum(temp2$secs_elapsed == '')

temp2 <- filter(dataS,secs_elapsed!='NA')
temp2 <- filter(temp2,secs_elapsed!='')
temp2 <- filter(temp2,secs_elapsed>0)

#temp2에서 user별로  user_id와 secs_elapsed의 총합을 뽑아온다.
data_temp3<-sqldf("SELECT user_id,SUM(secs_elapsed) FROM temp2 GROUP BY user_id")
head(data_temp3,3)
head(data_temp,3)

#user_id를 기준으로 last_action과 총 결과시간을 모은다.
data_temp<- join(data_temp,data_temp3,"user_id","left")
head(data_temp,3)

#data_temp에서 secs_elapsed가 >0이 아닌 항을 0으로 만든다.ex)NA
data_temp[-which(data_temp[,3]>0),3]=0

quantile(data_temp[,3])
# > quantile(data_temp[,3])
# 0%      25%      50%      75%     100% 
# 0   260598   850271  2000422 38221363 
head(data_temp)
names(data_temp)[4] <-"quantile"
data_temp[,4]=1
data_temp[which(data_temp[,3]>260598),4]=2
data_temp[which(data_temp[,3]>850271),4]=3
data_temp[which(data_temp[,3]>2000422),4]=4
head(data_temp)

#ask_qeustion인 사람만 뽑고 ask_question이 아닌 사람은 0으로 채워 넣는다.
#left outer join 왼쪽 df의 모든 행에서 key값을 기준으로 오른쪽 df에 존재하는 값들을 
#채워넣고 없는 값들은 빈(NA)값을 넣어 준다.
temp3 <- filter(dataS,action=='ask_question')
head(temp3,3)
temp3<-sqldf("SELECT DISTINCT user_id FROM temp3")
head(temp3,3)
temp3<-data.frame(temp3,1)
head(temp3,3)
head(data_temp,3)

#data_temp에 left조인을 시킴으로써 이사람의 ask_question여부를 알 수 있게 된다.
data_temp<-join(data_temp,temp3,"user_id","left")
names(data_temp)[5]<-'ask_question'
data_temp[-which(data_temp[,5]==1),5]<-0
head(data_temp,3)

temp3 <- filter(dataS,action=='pending')
temp3<-sqldf("SELECT DISTINCT user_id FROM temp3")
temp3<-data.frame(temp3,1)
data_temp<-join(data_temp,temp3,"user_id","left")
names(data_temp)[6]<-'pending'
data_temp[-which(data_temp[,6]==1),6]<-0

filter(dataS,action=='at_checkpoint')->temp3
temp3=sqldf("SELECT DISTINCT user_id FROM temp3")
temp3=data.frame(temp3,1)
data_temp=join(data_temp,temp3,"user_id","left")
names(data_temp)[7]='at_checkpoint'
data_temp[-which(data_temp[,7]==1),7]=0

filter(dataS,action_type=='submit')->temp3
temp3=sqldf("SELECT DISTINCT user_id FROM temp3")
temp3=data.frame(temp3,1)
data_temp=join(data_temp,temp3,"user_id","left")
names(data_temp)[8]='submit'
data_temp[-which(data_temp[,8]==1),8]=0

filter(dataS,action_type=='booking_request')->temp3
temp3=sqldf("SELECT DISTINCT user_id FROM temp3")
temp3=data.frame(temp3,1)
data_temp=join(data_temp,temp3,"user_id","left")
names(data_temp)[9]='booking_request'
data_temp[-which(data_temp[,9]==1),9]=0

filter(dataS,action_type=='message_post')->temp3
temp3=sqldf("SELECT DISTINCT user_id FROM temp3")
temp3=data.frame(temp3,1)
data_temp=join(data_temp,temp3,"user_id","left")
names(data_temp)[10]='message_post'
data_temp[-which(data_temp[,10]==1),10]=0

filter(dataS,action=='similar_listings')->temp3
temp3=sqldf("SELECT DISTINCT user_id FROM temp3")
temp3=data.frame(temp3,1)
data_temp=join(data_temp,temp3,"user_id","left")
names(data_temp)[11]='similar_listings'
data_temp[-which(data_temp[,11]==1),11]=0


filter(dataS,action=='confirm_email')->temp3
temp3=sqldf("SELECT DISTINCT user_id FROM temp3")
temp3=data.frame(temp3,1)
data_temp=join(data_temp,temp3,"user_id","left")
names(data_temp)[12]='confirm_email'
data_temp[-which(data_temp[,12]==1),12]=0

filter(dataS,action=='requested')->temp3
temp3=sqldf("SELECT DISTINCT user_id FROM temp3")
temp3=data.frame(temp3,1)
data_temp=join(data_temp,temp3,"user_id","left")
names(data_temp)[13]='requested'
data_temp[-which(data_temp[,13]==1),13]=0

test$country <- "US"

#1번 가설
ex1 <- data_temp[((data_temp$pending == 1)|(data_temp$booking_request == 1) | (data_temp$at_checkpoint == 1)),]
ex2 <- sqldf("select user_id from ex1")
ex2 <- data.frame(ex2,"US")
names(ex2)[1] <- "id"
test <- join(test,ex2,"id","left")
dim(test)
test$country <- test$X.US.
test$country <- as.character(test$country)
test$country[which(is.na(test$country))] = "NDF"

submission <- select(test, id,country)
write.csv(submission,"airbnb_sub.csv",row.names = FALSE)

#3번 가설
ex1 <- data_temp[(data_temp$quantile == 3 | data_temp$quantile==4), ]
ex2 <- sqldf("select user_id from ex1")
ex2 <- data.frame(ex2,"Very long")
names(ex2)[1] <- "id"
test$country[ex2$id %in% test$id] <- "NDF"

table(data_temp$quantile)

submission <- select(test, id,country)
write.csv(submission,"airbnb_sub.csv",row.names = FALSE)