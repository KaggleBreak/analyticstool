# age_gender_bucket 처리
age_gender = read.csv("age_gender_bkts.csv", stringsAsFactors = FALSE)
head(age_gender)

# 나라별 인구통계.
# 특정 나라에 대해서 대표적인 값을 만들어야 한다.

head(age_gender, 40)

# 왜도/첨도를 구하자.
# 남자의 인구 분포.
# 여자의 인구 분포.
# 국가 전체의 인구 분포.

table(age_gender$country_destination)
length(table(age_gender$country_destination)) # 10개 국가.

# 이 10개 국가에 들지 않는 국가들은 어떻게 처리를 할까?
# 전부 평균값을 주어야 하겠다. <-- RandomForest는 결측을 허용하지 않는다.
head(age_gender)
unique_country = unique(age_gender$country_destination)
age_gender_2 = data.frame( country = c(unique_country, "etc"),
                           male_kurt = 0,
                           male_skew = 0,
                           female_kurt = 0,
                           female_skew = 0,
                           total_kurt = 0,
                           total_skew = 0,
                           stringsAsFactors = FALSE)
# 일단 남자 여자 분포 특성은 거의 같을 수 있지만 일단 본다.

for(n in 1:length(unique_country)) # 국가 10개
{
  # n = 1
  sub = age_gender[ age_gender$country_destination == unique_country[n], ]
  sub[, "age_bucket"] = gsub(pattern = "\\+", replacement = "", sub$age_bucket)
  # + 기호가 온전하게 동작하려면 앞에 역슬래시를 두개 쓴다.
  sub = as.data.frame(cSplit(sub, splitCols = "age_bucket", sep = "-"))
  sub = sub[, c(1,2,3,5)] # year와 age_bucket_2 제거
  sub = dcast(sub, country_destination + age_bucket_1 ~ gender, value.var = "population_in_thousands")
  sub[, "total"] = sub$female + sub$male

  age_gender_2[ age_gender_2$country == unique_country[n], 2:7] = c(kurtosis(sub$male),
                                                                    skewness(sub$male),
                                                                    kurtosis(sub$female),
                                                                    skewness(sub$female),
                                                                    kurtosis(sub$total),
                                                                    skewness(sub$total))
}
age_gender_2[ age_gender_2$country == "etc", 2:7] = apply(age_gender_2[, 2:7], 2, FUN = "mean")
age_gender_2

# 남자와 여자의 값들이 조금 다르다.
# 숫자가 너무 자세하면 계산을 오래하니... 
# 소수점 셋 째 자리에서 반올림 해주자.

for(n in 2:7)
{
  # n = 2
  age_gender_2[, n] = round(age_gender_2[, n], 2)
}
age_gender_2

# write.csv(age_gender_2, "age_gender_bkts_2.csv", row.names = FALSE)

# 오우야.... 대박....
age_gender_2[   age_gender_2$country %in% c("AU", "CA") , ]
age_gender_2[ !(age_gender_2$country %in% c("AU", "CA")), ]
?`%in%`
example(`%%`)
  