# Kaggle
# AirBnB

#### rcheck ####
rcheck = function(x, n = 2){
  print(paste0("First ", n, " rows"))
  print(head(x, n))
  print(paste0("Last ", n, " rows"))
  print(tail(x, n))
  print( paste0("Object Dimension: ", dim(x)[1], ", ", dim(x)[2]) )
  sapply(x, class)
}

#### 경로 설정 ####
getwd()

list.files()

# [1] "age_gender_bkts.csv"       "countries.csv"             "sample_submission_NDF.csv"
# [4] "sessions.csv"              "test_users.csv"            "train_users_2.csv"        

#### age_gender_bkts.csv ####
age_gender_bkts = read.csv("age_gender_bkts.csv", stringsAsFactors = FALSE)

#### countries.csv ####
countries = read.csv("countries.csv", stringsAsFactors = FALSE)

#### sessions.csv ####
library("data.table")
sessions = fread("sessions.csv", stringsAsFactors = FALSE,
                 data.table = FALSE) # 600Mb
head(sessions)

sessions_2 = read.csv("sessions_2.csv", stringsAsFactors = FALSE)
head(sessions_2)

library("dplyr")

sessions_join = left_join(sessions, sessions_2, by = c("action" = "action", 
                                                      "action_detail" = "action_detail",
                                                      "action_type" = "action_type"))
head(sessions_join)
rm(sessions)
rm(sessions_2)

sessions_join = sessions_join[, -(2:4)]
head(sessions_join)

unique(sessions_join$device_type)

sessions_join[, "OS_type"] = "etc"
# Windows
sessions_join[ sessions_join$device_type == "Windows Desktop", "OS_type"] = "windows"
sessions_join[ sessions_join$device_type == "Windows Phone"  , "OS_type"] = "windows"
# iOS
sessions_join[ sessions_join$device_type == "Mac Desktop", "OS_type"] = "iOS"
sessions_join[ sessions_join$device_type == "iPhone"     , "OS_type"] = "iOS"
sessions_join[ sessions_join$device_type == "iPad Tablet", "OS_type"] = "iOS"
sessions_join[ sessions_join$device_type == "iPodtouch"  , "OS_type"] = "iOS"
# Android
sessions_join[ sessions_join$device_type == "Android Phone"                     , "OS_type"] = "Android"
sessions_join[ sessions_join$device_type == "Android App Unknown Phone/Tablet"  , "OS_type"] = "Android"

# PC yes or no
sessions_join[, "PC"] = "no"
sessions_join[ sessions_join$device_type == "Windows Desktop", "PC"] = "yes"
sessions_join[ sessions_join$device_type == "Mac Desktop"    , "PC"] = "yes"
sessions_join[ sessions_join$device_type == "Linux Desktop"  , "PC"] = "yes"

head(sessions_join)
sessions_join = sessions_join[, -2]
head(sessions_join)

#write.csv(sessions_join, "sessions_join.csv", row.names = FALSE)
sessions_join = read.csv("sessions_join.csv", stringsAsFactors = FALSE)

# 세션시간 결측치 처리
sessions_join[ is.na(sessions_join$secs_elapsed), "secs_elapsed"] = 0

# 세션별 최대 시간 제한 : 1200초(20분)
session_time_limit = 1200
sessions_join[ sessions_join$secs_elapsed > session_time_limit, "secs_elapsed"] <- session_time_limit

head(sessions_join)


library("reshape2")
colnames(sessions_join)

# session_action
session_action = aggregate( data = sessions_join, secs_elapsed ~ user_id + action_1, FUN = "sum")
head(session_action)

session_action_cast = dcast(data = session_action,
                            user_id ~ action_1,
                            FUN = "sum",
                            value.var = "secs_elapsed")
head(session_action_cast)

#user_id가 비어있는 것을 처리 
session_action_cast = session_action_cast[ -1, ]
head(session_action_cast)

#NA인 값을 전부 0으로 대체
for(n in 2:ncol(session_action_cast))
{
  session_action_cast[ is.na(session_action_cast[, n]), n] = 0 
}
head(session_action_cast) 

session_action_cast[, "action_sec_sum"] = apply(session_action_cast[, 2:8],
                                                MARGIN = 1,
                                                FUN = "sum",na.rm = TRUE)
head(session_action_cast)

for(n in 2:8)
{
  # n = 8
  session_action_cast[, n] = round( session_action_cast[, n]/session_action_cast$action_sec_sum, 2)
}
head(session_action_cast)

#write.csv(session_action_cast, "session_action_cast.csv", row.names = FALSE)


# session_booking
session_booking = aggregate( data = sessions_join, secs_elapsed ~ user_id + booking, FUN = "sum")
head(sessions_booking)

session_booking_cast = dcast(data = session_booking,
                               user_id ~ booking,
                               FUN = "sum", 
                               value.var = "secs_elapsed")
head(session_booking_cast)

session_booking_cast = session_booking_cast[ -1, ]

summary(session_booking_cast)
session_booking_cast[ is.na(session_booking_cast$no ), "no" ] = -1
session_booking_cast[ is.na(session_booking_cast$yes), "yes"] =  0

session_booking_cast[, "booking_time_ratio"] = 0
session_booking_cast[, "booking_time_ratio"] = (session_booking_cast$yes)/(session_booking_cast$no + session_booking_cast$yes)
session_booking_cast[ session_booking_cast$no == -1, "booking_time_ratio"] = -0.001
session_booking_cast[session_booking_cast$no == 0 & session_booking_cast$yes == 0,"booking_time_ratio"] = 0

head(session_booking_cast)

library("ggplot2")
#예약 시간 비율이 압도적으로 적다.
ggplot() + 
  geom_histogram(data = session_booking_cast, aes(x = booking_time_ratio), binwidth = 0.05)

session_booking_cast[, "booking_session_check"] = "no"
session_booking_cast[ session_booking_cast$booking_time_ratio > 0      , "booking_session_check"] = "yes"
session_booking_cast[ session_booking_cast$booking_time_ratio == -0.001, "booking_session_check"] = "unknown"
table(session_booking_cast$booking_session_check)

session_booking_cast = session_booking_cast[, c("user_id", "booking_session_check")]
head(session_booking_cast)
# write.csv(session_booking_cast, "session_booking_cast.csv", row.names = FALSE)


# session OS_type
session_OS = aggregate( data = sessions_join, secs_elapsed ~ user_id + OS_type, FUN = "sum")
head(session_OS)

session_OS_cast = dcast(data = session_OS,
                        user_id ~ OS_type,
                        FUN = "sum", 
                        value.var = "secs_elapsed")
head(session_OS_cast)

session_OS_cast = session_OS_cast[-1, ]
head(session_OS_cast)

for(n in 2:5)
{
  # n = 2
  session_OS_cast[ is.na(session_OS_cast[, n]), n] = 0
  session_OS_cast[ session_OS_cast[, n] > 0, n] = 1
}
head(session_OS_cast)

session_OS_cast[, "num_OS"] = apply(session_OS_cast[, 2:5],
                                    MARGIN = 1,
                                    FUN = "sum")
head(session_OS_cast)
# write.csv(session_OS_cast, "session_OS_cast.csv", row.names = FALSE)


# session PC
session_PC = aggregate( data = sessions_join, secs_elapsed ~ user_id + PC, FUN = "sum")
head(session_PC)

session_PC = session_PC[ -1, ]
head(session_PC)

session_PC_cast = dcast(data = session_PC,
                        user_id ~ PC,
                        FUN = "sum", 
                        value.var = "secs_elapsed")
head(session_PC_cast)

session_PC_cast[ is.na(session_PC_cast[, 2]), 2] = 0
session_PC_cast[ is.na(session_PC_cast[, 3]), 3] = 0
head(session_PC_cast)

session_PC_cast = session_PC_cast[-1, ]
head(session_PC_cast)

colnames(session_PC_cast)[2:3] = c("not_PC", "PC")
head(session_PC_cast)

session_PC_cast[, "sec_total"] = apply( session_PC_cast[, 2:3],
                                        MARGIN = 1,
                                        FUN = "sum")
head(session_PC_cast)

round(0.293 / 2, 1)*2
##결측
session_PC_cast[, 2] = round(session_PC_cast[, 2]/session_PC_cast$sec_total /2, 1) * 2
session_PC_cast[, 3] = round(session_PC_cast[, 3]/session_PC_cast$sec_total /2, 1) * 2
head(session_PC_cast)

round(session_PC_cast[, 2]/session_PC_cast$sec_total,1)
# write.csv(session_PC_cast, "session_PC_cast.csv", row.names = FALSE)

#### session 처리된거 ####
session_action_cast  = read.csv("session_action_cast.csv" , stringsAsFactors = FALSE)
session_booking_cast = read.csv("session_booking_cast.csv", stringsAsFactors = FALSE)
session_OS_cast      = read.csv("session_OS_cast.csv"     , stringsAsFactors = FALSE)
session_PC_cast      = read.csv("session_PC_cast.csv"     , stringsAsFactors = FALSE)

session_bind = cbind(session_action_cast,
                     session_booking_cast,
                     session_OS_cast,
                     session_PC_cast)
head(session_bind, 2)
#22 * 1 
t(t(colnames(session_bind)))

session_bind = session_bind[, c(1:8, 13, 15:18, 20:22)]
head(session_bind, 2)
t(t(colnames(session_bind)))

colnames(session_bind)[3 ] = "action_etc"
colnames(session_bind)[11] = "OS_etc"

# write.csv(session_bind, "session_bind.csv", row.names = FALSE)

#### affiliate ####
affiliate_2 = read.csv("affiliate_2.csv", stringsAsFactors = FALSE)
head(affiliate_2)

#### train_users_2.csv ####
train = read.csv("train_users_2.csv", stringsAsFactors = FALSE)
head(train)

train[, "NDF_YDF"] = "NDF"
train[ train$country_destination != "NDF", "NDF_YDF"] = "YDF"

train_join = left_join(train, session_bind, by = c("id" = "user_id")) 
head(train_join)

sum(is.na(train_join$sec_total))/nrow(train_join) # session 결측비율

train_join = train_join[ is.na(train_join$sec_total) == 0, ]
head(train_join)

#### test_users.csv ####
test = read.csv("test_users.csv", stringsAsFactors = FALSE)
head(test)

test[, "country_destination"] = "test"
test[, "NDF_YDF"] = "test"

library("dplyr")
test_join = left_join(test, session_bind, by = c("id" = "user_id")) 
head(test_join)

sum(is.na(test_join$sec_total))/nrow(test_join) # 0.689% -> 428개 
sum(is.na(test_join$sec_total))
#### train + test ####

total = rbind(train_join, test_join)
head(total, 2)

sum(is.na(total$sec_total))/nrow(total)

rm(train)
rm(test)
rm(train_join)
rm(test_join)
rm(session_bind)

# write.csv(total, "total_160324.csv", row.names = FALSE)
total = read.csv("total_160324.csv", stringsAsFactors = FALSE)
# 나중에 affiliate_2랑 join 해줘야함.

# age 처리
total[ is.na(total$age) , "age"] = 0
total[ total$age > 90, "age"] = 90
total[, "age"] = round(total[, "age"], -1)
table(total$age)

# sec_total 을 접속 시간 정도로 바꿔버리자.
# round 소숫점 기준으로 digits 자리 까지 반올림
total[, "sec_total"] = round(total[, "sec_total"] / 3600, 0)
head(total, 2)

# 첫 행동시각 처리 <-- 실패
# total[, "timestamp_first_active"] = substr(total$timestamp_first_active, 1, 8)
# total[, "timestamp_first_active"] = paste(substr(total$timestamp_first_active, 1, 4),
#                                           substr(total$timestamp_first_active, 5, 6),
#                                           substr(total$timestamp_first_active, 7, 8),
#                                           sep = "-")
# head(total, 2)
# 
# # time1 = as.POSIXct("2011-01-04")
# # time2 = as.POSIXct("2011-01-06")
# # difftime( time1, time2, units = "day")
# # Time difference of -2 days
# 
# total[, "id_create_lag"] = as.numeric(difftime(as.POSIXct(total$date_account_created),
#                                                as.POSIXct(total$timestamp_first_active),
#                                                units = "day"))
# head(total, 2)
# 
# table(total$id_create_lag) <-- 전부 0임 안됨.

# first_active 제거
total = total[, -3]
head(total, 2)

# 예약일자 확인
booking_date = total$date_first_booking

booking_date_df = as.data.frame(table(booking_date),
                                stringsAsFactors = FALSE)
tail(booking_date_df) # <-- 2015년 6월 29일이 마지막
# 즉, 예약일자 없는 것들은 "2015-06-30"으로 만들어버리자.

head(total, 2)
total[ is.na(total$date_first_booking), "date_first_booking"] = "2015-06-30"
total[ total$date_first_booking == "" , "date_first_booking"] = "2015-06-30"

total[, "days_after_ID_create"] = as.numeric(difftime(as.POSIXct(total$date_first_booking),
                                                      as.POSIXct(total$date_account_created),
                                                      units = "day"))
total = total[, -(2:3)]
head(total, 2)

# write.csv(total, "total_160324_2.csv", row.names = FALSE)
total = read.csv("total_160324_2.csv", stringsAsFactors = FALSE)
head(total, 2)

# 아이디를 만든지 며칠만에 예약을 했는지 보자.
total_sub = total[ total$NDF_YDF == "YDF", c("id", "days_after_ID_create")]
head(total_sub)
     
max(total_sub$days_after_ID_create)

days_after_ID_create_df = as.data.frame(table(total_sub$days_after_ID_create),
                                        stringsAsFactors = FALSE)
head(days_after_ID_create_df)
days_after_ID_create_df[, "Var1"] = as.numeric(days_after_ID_create_df[, "Var1"])

library("ggplot2")
ggplot() + 
  geom_bar(data = days_after_ID_create_df, aes( x = Var1, y = round(log10(Freq+1), 0)),
           stat = "identity") + 
  geom_vline(xintercept = 70, colour = "#FF0000", size = 1.5, alpha = 0.2) +
  geom_vline(xintercept =  8, colour = "#FF0000", size = 1.5, alpha = 0.2) +
  geom_vline(xintercept =  1, colour = "#FF0000", size = 1.5, alpha = 0.2) +
  geom_vline(xintercept =  0, colour = "#FF0000", size = 1.5, alpha = 0.2)

days_after_ID_create_df[, "log"] = round( log10(days_after_ID_create_df$Freq), 0)
head(days_after_ID_create_df)

# ID 생성일.
# 70 / 8 / 1/ 0 <-- 당일

summary(total) # contact 부터 결측이 있음 ㅇㅇ
t(t(colnames(total)))

# 결측을 죄다 0으로...
for(n in 15:31)
{
  # n = 15
  total[ is.na(total[, n]) == 1 , n] = 0 
}
summary(total) # 처리됨

head(total, 2)

# signup_method
table(total$signup_method)
# 이건 걍 통과

# signup_flow
table(total$signup_flow)
# 몰라도 고!

# language
table(total$language)
# 대륙 권역으로 나눌까?...(영어제외)
# 일단 ydf 구분하는거니까... 영어 빼고 다 변환.
total[ total$language != "en", "language"] = "etc"
table(total$language)

# signup_app
table(total$signup_app)
# 이건 다른거랑 좀 중복되어서 빼도 될듯

head(total, 2)

# 일단 affiliate 관련 join 하고 필요없어 보이는거 다 빼야 할 듯

# affiliate 관련
head(affiliate_2)

total = dplyr::left_join(total, affiliate_2, by = c("affiliate_channel"  = "affiliate_channel" ,
                                                    "affiliate_provider" = "affiliate_provider",
                                                    "first_affiliate_tracked" =  "first_affiliate_tracked"))
head(total, 2)

# write.csv(total, "total_160325_1.csv", row.names = FALSE)
total = read.csv("total_160325_1.csv", stringsAsFactors = FALSE)

# 필요한것만 들고가자.
t(t(colnames(total)))
total_2 = total[, c(1:6, 13:29, 31, 32)]
head(total_2)

for(n in 2:ncol(total_2))
{
  # n = 2
  if(class(total_2[, n]) == "character")
  {
    total_2[, n] = factor(total_2[, n])
  }
}
sapply(total_2, class)
head(total_2, 3)

train = total_2[ total$country_destination != "test", ]
sapply(train, class)
head(train)

# 왔더.
# > train$NDF_YDF[1:2]
# [1] YDF NDF
# Levels: NDF test YDF

train[, "NDF_YDF"] = factor(train$NDF_YDF, levels = c("YDF", "NDF"))
library("randomForest")
time = Sys.time()
rf_model_1 = randomForest ( NDF_YDF ~. -id -country_destination, 
                            data = train,
                            importance = TRUE, ntree=20)
Sys.time() - time # 연산시간 20초도 안걸림

summary(rf_model_1)
importance(rf_model_1)
varImpPlot(rf_model_1)
# test 데이터
test = total_2[ total$country_destination == "test", ]
sapply(test, class)

prediction = predict(rf_model_1, newdata = test)
unique(prediction)

submission_1 = data.frame( id = test$id,
                           country = as.character(prediction),
                           stringsAsFactors = FALSE)
head(submission_1)
sapply(submission_1, class)

submission_1[ is.na(submission_1$country), ] # 뭐지??? 왜 결측이 생김????
submission_1[ is.na(submission_1$country), 2] = "NDF"
submission_1[ submission_1$country == "YDF", 2] = "US"
table(submission_1$country)

write.csv(submission_1, "submission_160325_1.csv", row.names = FALSE)
##################################3
