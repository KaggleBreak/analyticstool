#### 국가 관련해서... 처리하기 ####
countries = read.csv("countries.csv", stringsAsFactors = FALSE)
head(countries)

#### 01. 위경도 처리 ####
countries  

# 남반구인지 북반구인지 나눌것. (lat)
countries[, "hemisphere"] = "northren"
countries[ countries$lat_destination < 0 , "hemisphere"] = "southern"
head(countries)

# 시차를 대신하는 값을 만들것. (lng)
# lng의 값의 범위는 -180, +180
countries$lng_destination
countries[, "time_zone"] = countries[, "lng_destination"] - countries[ countries$country_destination == "US", "lng_destination"]
countries[ countries$time_zone > 180, "time_zone"] = (-1)*(countries[ countries$time_zone > 180, "time_zone"] - 180)
countries[, "time_zone"] = round(countries[, "time_zone"], -1)
head(countries)


#### 02. 거리 처리 ####
# 그냥 1000km 단위로 처리
# 대강 몇 백 km 차이나는거 별거 아님 ㅇㅇ.
countries[, "distance_km"] = round(countries[, "distance_km"], -3)

#### 03. 면적 처리 ####
# 나라가 얼마나 넓은가?
# 꼭 그렇지는 않지만 얼마나 볼거리가 많은가....
# 와 어느 정도 상관관계가... 있지 않을까...
countries[, "destination_km2"] = round(log10(countries[, "destination_km2"]), 1)
# 단위가 너무 커서 상용로그 썼음..

#### 04. 언어 #####
# 목적지 사용 언어는 영어 또는 영어가 아닌 곳
# "Eng", "notEng" 으로 바꿀 것
countries[ , "destination_language_2"] = "notEng"
countries[ countries$destination_language == "eng", "destination_language_2"] = "Eng"
head(countries)

# language_levenshtein_distance
# 이건 1의 자리에서 반올림 하자.
# 자세한 값은 딱히 무의미
countries[, "language_levenshtein_distance"] = round(countries[, "language_levenshtein_distance"], -1)
countries

#### 변수 추려내기 ####
t(t(colnames(countries)))
countries = countries[, -(2:3)]
head(countries)

# 기타국가 추가하기
countries[ nrow(countries) + 1, "country_destination"] = "etc"
etc_feature = c(mean( countries$distance_km, na.rm = TRUE),
                mean( countries$destination_km2, na.rm = TRUE),
                "eng",
                mean( countries$language_levenshtein_distance, na.rm = TRUE),
                "northren",
                mean( countries$time_zone, na.rm = TRUE),
                "notEng")
countries[ countries$country_destination == "etc", 2:ncol(countries)] = etc_feature
tail(countries, 3)


#### 저장하기 ####
# write.csv(countries, "countries_2.csv", row.names = FALSE)
