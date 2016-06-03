#### 경로설정 ####
setwd("C:/Users/Encaion/Documents/kaggle_AirBnB")
getwd()

#### packages ####
library("lubridate")

#### rcheck ####
rcheck = function(x, n = 2){
  print(paste0("First ", n, " rows"))
  print(head(x, n))
  print(paste0("Last ", n, " rows"))
  print(tail(x, n))
  print( paste0("Object Dimension: ", dim(x)[1], ", ", dim(x)[2]) )
  sapply(x, class)
}

#### Mode ####
Mode = function(x) {
  ux = unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#### packages ####
library("ggplot2")
library("reshape2")
library("dplyr")
library("splitstackshape")
library("randomForest")
library("moments")

#### 파일 읽어오기 ####
list.files(pattern = "csv")

# 국가 개요?
countries  = read.csv("countries_2.csv", stringsAsFactors = FALSE)
# head(countries)

# 국가별 인구통계 등
age_gender = read.csv("age_gender_bkts_2.csv", stringsAsFactors = FALSE)
# head(age_gender)

# 국가 합치기!
countries_join = left_join(age_gender, countries, by = c("country" = "country_destination"))
# head(countries_join)

# write.csv(countries_join, "countries_join.csv", row.names = FALSE)
countries = read.csv("countries_join.csv", stringsAsFactors = FALSE)
head(countries)

# 마케팅 채널 관련
affiliate = read.csv("affiliate_2.csv", stringsAsFactors = FALSE)
head(affiliate)

# 세션 데이터
sessions = fread("session_final.csv", stringsAsFactors = FALSE,
                  data.table = FALSE)
head(sessions)

train = read.csv("train_users_2.csv", stringsAsFactors = FALSE)
head(train)

test = read.csv("test_users.csv", stringsAsFactors = FALSE)
test[, "country_destination"] = "test"
head(test)

total = rbind(train, test)
rcheck(total)

print(total[1, "timestamp_first_active"], digit = 20)
head(total)

# 시간 결측 확인
time_data = total[, 1:4]
head(time_data,3)
print(time_data[1, 3], digits = 20)
summary(time_data)

sum( time_data$date_account_created == "") # 0
sum( time_data$timestamp_first_active == "") # 0
sum( time_data$date_first_booking == "") # NA <-- ??

time_first = as.Date(time_data[ time_data$date_first_booking != "", "date_first_booking"])
time_first = time_first[order(time_first, decreasing = TRUE)]
head(time_first) # 2010-01-02 가 가장 빠르다.

#####################


# 이건 보류
total[ total$date_first_booking == "", "date_first_booking"] = "2010-01-01"
total[, "date_first_booking"    ] = as.Date(total[, "date_first_booking"])
head(total)


total[, "date_account_created"  ] = as.POSIXct(total[, "date_account_created"])
total[, "timestamp_first_active"] = as.POSIXct(strptime(total[, "timestamp_first_active"],
                                                        format = "%Y%m%d%H%M%S"))

total[, "active_month"] = as.character(month(total$timestamp_first_active))
total[, "active_week" ] = as.character( week(total$timestamp_first_active)) 
total[, "created_month"]= as.character(month(total$date_account_created))
head(total)

# 종속변수: 어떤 나라가 있고, 비율이 얼마나 되나?
length(t(table(train$country_destination)))
round(t(t(prop.table((table(train$country_destination))))) * 100, 1)

train_1_out = train[ !(train$country_destination %in% "NDF"), ]
round(t(t(prop.table((table(train_1_out$country_destination))))) * 100, 1)

train_2_out = train[ !(train$country_destination %in% c("NDF", "US")), ]
round(t(t(prop.table((table(train_2_out$country_destination))))) * 100, 1)

#### 파일 전체 합치기 ####
# 01. countries
# 02. sessions
# 03. affiliate
# 04. total
countries = countries[ c(3:5, 7:11), ]
rownames(countries) = NULL
head(countries)
unique(countries$destination_language)
countries[8, "destination_language"] = "etc"
countries[, "destination_language"] = substr(countries[, "destination_language"], 1, 2)
countries[ countries$destination_language == "po", "destination_language"] = "pt"

# total_backup = total

total[ !(total$language %in% unique(countries$destination_language)), "language"] = "etc"

#
unique(total$language)
total = left_join(total, countries, by = c("language" = "destination_language"))
head(total)
tail(total)

#
head(sessions)
total = left_join(total, sessions, by = c("id" = "user_id"))
head(total)

#
head(affiliate)
total = dplyr::left_join(total, affiliate, by = c("affiliate_channel"  = "affiliate_channel" ,
                                                  "affiliate_provider" = "affiliate_provider",
                                                  "first_affiliate_tracked" =  "first_affiliate_tracked"))
head(total)
#### 결측처리 해야됨 ####
total_backup = total
summary(total)

# age
head(total[, 1:5])
total[, "year"] = year(total$date_account_created)
total[ is.na(total$age), "age"] = -1
total[ total$age > 1000, "age"] = -1
total[ total$age == -1,  "age"] = round(mean(total[ total$age > 0, "age"]), 0)

total = total[, -46]

# male_kurt / skew
total[ is.na(total$male_kurt), "male_kurt"] = mean(total$male_kurt, na.rm = TRUE)
total[ is.na(total$male_skew), "male_skew"] = mean(total$male_skew, na.rm = TRUE)

# female_kurt / skew
total[ is.na(total$female_kurt), "female_kurt"] = mean(total$female_kurt, na.rm = TRUE)
total[ is.na(total$female_skew), "female_skew"] = mean(total$female_skew, na.rm = TRUE)


# total_kurt / skew
total[ is.na(total$total_kurt), "total_kurt"] = mean(total$total_kurt, na.rm = TRUE)
total[ is.na(total$total_skew), "total_skew"] = mean(total$total_skew, na.rm = TRUE)

# distance_km
total[ is.na(total$distance_km), "distance_km"] = mean(total$distance_km, na.rm = TRUE)

# destination_km2
total[ is.na(total$destination_km2), "destination_km2"] = mean(total$destination_km2, na.rm = TRUE)

# language_leven ~ 
total[ is.na(total$language_levenshtein_distance), "language_levenshtein_distance"] = mean(total$language_levenshtein_distance,
                                                                                           na.rm = TRUE)
# time_zone
total[ is.na(total$time_zone), "time_zone"] = mean(total$time_zone, na.rm = TRUE)

# total_backup = total

# session_no
total[ is.na(total$session_no), "session_no"] = mean(total$session_no, na.rm = TRUE)

# secs_total
total[ is.na(total$secs_total), "secs_total"] = mean(total$secs_total, na.rm = TRUE)

# secs_avg
total[ is.na(total$secs_avg), "secs_avg"] = mean(total$secs_avg, na.rm = TRUE)

# device_no
total[ is.na(total$device_no), "device_no"] = mean(total$device_no, na.rm = TRUE)

# OS_no
total[ is.na(total$OS_no), "OS_no"] = mean(total$OS_no, na.rm = TRUE)

# action_no
total[ is.na(total$action_no), "action_no"] = mean(total$action_no, na.rm = TRUE)

# date_first_booking
# "2015-06-29"
total[ is.na(total$date_first_booking), "date_first_booking"] = "2015-06-29"
total[ total$date_first_booking == "", "date_first_booking"] = "2015-06-29"
total[, "date_first_booking"] = as.POSIXct(total[, "date_first_booking"])
head(total[, 1:10])

head(total)
summary(total)

# 응??? 무한대 값이 있다.
# secs_avg
sum(is.infinite(total$secs_avg)) # 16만;;;
total[ is.infinite(total$secs_avg), "secs_avg"] = mean(total[ is.infinite(total$secs_avg) == 0, "secs_avg"])

# Mode 사용 변수
# device_main
Mode(total$device_main)
table(total$device_main)
total[ is.na(total$device_main), "device_main"] = "Mac Desktop"

# OS_main
total[ is.na(total$OS_main), "OS_main"] = Mode(total[ is.na(total$OS_main) == 0,"OS_main"])

# action_main
total[ is.na(total$action_main), "action_main"] = Mode(total[ is.na(total$action_main) == 0,"action_main"])

# booking
total[ is.na(total$booking), "booking"] = Mode(total[ is.na(total$booking) == 0,"booking"])
 
# total_backup = total

#### 파생 변수 ####
head(total)
# total[, "days_after_ID_create"] = as.numeric(total$date_first_booking - total$date_account_created)


head(total[, c("secs_total", "days_after_ID_create")])
# total[, "new_index_1"] = round(total$secs_total / total$days_after_ID_create, 1)
total[, "new_index_2"] = "YES"
total[ (total$age == 0) | (total$gender == "-unknown-"), "new_index_2"] = "NO"
head(total)

t(t(colnames(total)))
total = total[, -46]
head(total)

# write.csv(total, "total_160514.csv", row.names = FALSE)
total = fread("total_160514.csv", stringsAsFactors = FALSE, data.table = FALSE)
head(total[ , 1:10])
t(t(colnames(total)))

total = total[, -c(1:4)]
head(total[ , 1:10])
head(total[ , 10:20])
head(total[ , 20:30])
head(total[ , 30:40])
head(total[ , 40:ncol(total)])

# YDF / NDF 만들기
total[, "YDF_NDF"] = "YDF"
table(total$country_destination)
total[ total$country_destination == "NDF", "YDF_NDF"] = "NDF"
total[, "YDF_NDF"] = factor(total[, "YDF_NDF"])

#### 모델 돌리기 ####
library("randomForest")
rf_model_1 = randomForest( YDF_NDF ~ . -country_destination, 
                           data = total[ total$country_destination != "test", ],
                           importance = TRUE,
                           ntree = 10)

#### 참고사항 ####
# random forest를 사용할 경우 데이터에 결측이 없어야 한다.
