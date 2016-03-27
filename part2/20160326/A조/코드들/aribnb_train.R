install.packages("dplyr")
install.packages("ggplot2")
install.packages("data.table")
library(dplyr)
library(ggplot2)
library(data.table)

train <- read.csv("train_users_2.csv",stringsAsFactors = FALSE)
test <- read.csv("test_users.csv",stringsAsFactors = FALSE)
sessions = fread("sessions.csv", stringsAsFactors = FALSE,
                 data.table = FALSE)

str(train)
#구조에 맞게 형태를 바꾸어 준다.
train$timestamp_first_active <- as.character(train$timestamp_first_active)
train$date_account_created <- as.Date(train$date_account_created)


#예약여부를 열로 따로 만들어 둔다.
sum(train$date_first_booking == "")
table(train$country_destination)

train[, "booking_check"] = "Yes"
train$booking_check[train$date_first_booking == ""] = "No"
#예약을 안한 사람은 전부 걸러낸다. 
train1 <- train[train$booking_check == "Yes", ]

#date_first_booking열을 Date형으로 변경한다.
train1$date_first_booking <- as.Date(train1$date_first_booking)

str(train1)


#구글은 12번 페이지를 통해서만 들어왔다 , facebook에서도 12번 페이지가 제일 빈도수가 높다.
#12번 페이지에 뭔가가 있지 않을까?
#basic은 3, 25, 2, 24, 12 순 ... 0 은 당연한 거고
table(train1$signup_method,train1$signup_flow)

#나이에 100살 이상이 있다. 2,4,5살이 있다.
sort(unique(train1$age))


#105살 841, 2014살 342, 18살부터 확 많아 지고 2014은 2014년도 를 말하는 거 같고
# 105살의 의미가 뭘까?
table(train1$age)

#나이의 na값을 없에는 것이 좋을 것인가?
#age <= 100 그리고 NA값이 없는 것만을 선택한다.
train2 <- train1 %>%
    filter(!is.na(age),age <= 100 , age >= 15)
head(train2)
#20~40세 사이가 가장 많다.
hist(train2$age , breaks = 500, ylim = c(0,4000))

#언어와 목적지 사이에는 관계가 없다. 
train3 <- train2 %>%
    group_by(language,country_destination) %>%
    summarise(n = n()) %>%
    arrange(desc(n))
#영어를 쓰지않는데 US를 목적지로 선택한 사람들의 도표
train3 <- filter(train3,language != "en" , country_destination == "US")
ggplot(train3, aes(x = country_destination, y= n,fill = language)) + geom_bar(stat = "identity",position = "dodge")

#영어를 쓰지 않는 사람들이 Other 를 목적지로 선택한 도표
train3 <- filter(train3,language != "en" , country_destination == "other")
ggplot(train3, aes(x = country_destination, y= n,fill = language)) + geom_bar(stat = "identity",position = "dodge")

#airbnb를 사용하는 사람중에서의 언어의 비율 en,zh,fr,es,de,ko...
train2 %>%
  group_by(language) %>%
  summarise(n = n()) %>%
  arrange(desc(n))

#airbnb를 사용하는 사람 중에서 목적지 내림차순 US,other, FR, IT, GB, ES, CA
train4 <- train2 %>%
  group_by(country_destination) %>%
  summarise(n = n()) %>%
  arrange(desc(n))


#그래프들..
barplot(sort(table(train$country_destination)),ylim = c(0,150000),col = rainbow(12),las = 3)
barplot(sort(table(train2$country_destination)),ylim = c(0,50000),col = rainbow(12),las = 3)

#성별별 목적지별 빈도수 그래프
ex1 <- as.data.frame(table(train2$country_destination,train2$gender))     
ex1
ggplot(ex1,aes(x = Var1 , y = Freq , fill = Var2)) +geom_bar(position = "dodge",stat = "identity")








