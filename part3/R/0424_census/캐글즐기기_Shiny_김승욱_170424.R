# 데이터 확인
counties = readRDS("census-app/data/counties.rds")
head(counties)

# 패키지 설치
install.packages(c("maps", "mapproj"))

# 패키지 및 코드 불러오기
library("maps")
library("mapproj")
source("census-app/helpers.R")
counties = readRDS("census-app/data/counties.rds")
percent_map(counties$white, "darkgreen", "% White")
