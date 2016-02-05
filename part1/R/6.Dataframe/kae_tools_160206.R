# ■ 데이터 프레임 생성

# 1
df_1 = data.frame( aa = c("a", "b", "c"),
                   bb = 1:3)
df_1

str(df_1) # aa column이 factor형으로 되어있는 것을 알 수 있음

# 2
df_2 = data.frame( aa = c("a", "b", "c"),
                   bb = 1:3,
                   stringsAsFactors = FALSE)
df_2
str(df_2) # aa column이 character형으로 되어있는 것을 알 수 있음

# 3
df_3 = data.frame( aaa = 2:20,
                   bbb = (2:20)*2,
                   ccc = "what")
df_3
str(df_3)

# 4
df_4 = data.frame( aaa = 2:20,
                   bbb = (2:20)*2,
                   ccc = "what",
                   stringsAsFactors = FALSE)
df_4
str(df_4)


# ■ 데이터 프레임 접근하기

# 1 - head() & tail()
df_4 = data.frame( aaa = 2:20,
                   bbb = (2:20)*2,
                   ccc = "what",
                   stringsAsFactors = FALSE)
head(df_4)
tail(df_4)

# 2 - $연산
df_4$aaa

# 3 - 벡터연산(추출)
df_4[ , 1]

df_4[1,  ]

df_4[ , 1:3]
df_4[ , c(1,3)]

df_4[2:5, ]
df_4[c(2,5,9), ]

df_4[2, 2]
df_4[4:10, 3]
df_4[3:6 , c(1,3)]
df_4[c(4,5,10), c(2,3)]

df_4[, "aaa"]
df_4[, c("aaa", "ccc")]
df_4[13:17, c("aaa", "ccc")]

# 4 - 벡터연산(삽입)
df_4[13:17, c("aaa", "ccc")] = "insert"
df_4

df_4[c(11, 16),] = NA
df_4

# 5 - rownames() & colnames()
df_4
rownames(df_4)
colnames(df_4)

colnames(df_4)[2:3]

t(colnames(df_4))
t(t(colnames(df_4)))

# ■ 결측치
# 1 - 결측치 확인
df_4
df_4[ is.na(df_4$aaa), ]

df_4[ is.na(df_4$aaa) == 0, ]
df_4[ is.na(df_4$aaa) == 1, ]

df_4[ is.na(df_4$aaa) == FALSE, ]
df_4[ is.na(df_4$aaa) == TRUE , ]

# 2 - 결측치 기타
df_4
mean(df_4$bbb) # ?!?!

mean(df_4$bbb, na.rm = TRUE) # !!!!

# ■ 데이터 프레임 다루기
# 1 - rbind() & cbind()
df_4

rbind(df_4, df_4)

cbind(df_4, df_4, df_4)


# ■ apply 함수 사용하기
df_apply = data.frame( aa = 1:20,
                       bb = seq(50, 100, length = 20),
                       cc = rnorm(20, 0, 1),
                       stringsAsFactors = FALSE)
df_apply

apply(X = df_apply, MARGIN = 1, FUN = "mean")
apply(X = df_apply, MARGIN = 2, FUN = "mean")

df_apply[, "mean_value"] = apply(X = df_apply, MARGIN = 1, FUN = "mean")
df_apply

# ■ 연산자를 활용한 데이터 추출
df_apply

df_apply[ df_apply$cc < 0, ]
df_apply[ (df_apply$cc < 0) & (df_apply$aa >= 10), ]

# ■ join 연산
# install.packages("dplyr")
library("dplyr")

data_a = data.frame( ID_a  = c("jack", "hyun", "kim", "park", "paul", "park", "hyun", "park"),
                     score = c(100, 80, 90, 45, 99, 45, 66, 80),
                     stringsAsFactors = FALSE)
data_a

data_b = data.frame( ID_b  = c("hyun", "kim", "park"),
                     class = c("A", "C", "D"),
                     stringsAsFactors = FALSE)
data_b

data_join = left_join(data_a, data_b, by = c("ID_a" = "ID_b"))
data_join


# ■ table
# 1 - table 1
df_4
summary(df_4)
table(df_4$aaa)
table(df_4$aaa, exclude = NULL)

table_df_4 = table(df_4$aaa, exclude = NULL)
df_table_1 = as.data.frame(table_df_4)
df_table_1

str(df_table_1)


df_table_2 = as.data.frame(table_df_4, stringsAsFactors = FALSE)
df_table_2

str(df_table_2)


# 2 - table 2
sample = data.frame( ID    = c("jack", "hyun", "kim", "park", "paul", "park", "hyun", "park"),
                     score = c(100, 80, 90, 45, 99, 45, 66, 80),
                     class = c("A", "A", "A", "B", "B", "C", "C","D"),
                     stringsAsFactors = FALSE)
sample

table(sample$class)
table(sample$class, sample$ID)


# ■ aggregate()
sample

sample_2 = rbind(sample, sample)
sample_2

aggregate( score ~ class, data = sample_2, FUN = "sum")
aggregate( score ~ class + ID, data = sample_2, FUN = "sum")

# ■ sapply()
sapply(sample, class)
