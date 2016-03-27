#파일 로드
RegularDetailedResults <- read.csv("RegularSeasonDetailedResults.csv",header=T)

#attach(RegularDetailedResults)
names(RegularDetailedResults)

#승리/패배 팀별 칼럼 인덱스 분류
idx.common<-c(1,2,7,8)
idx.w<-c(3,4,9,10,11,12,13,14,15,16,17,18,19,20,21)
idx.l<-c(5,6,22,23,24,25,26,27,28,29,30,31,32,33,34)
#RegularDetailedResults$Numot<-as.factor(RegularDetailedResults$Numot)

win<-RegularDetailedResults[,c(idx.common,idx.w)]
lose<-RegularDetailedResults[,c(idx.common,idx.l)]

#승리한 경기는 1, 패배한 경기는 1로 기록
win$Result<-rep(1,nrow(win))
lose$Result<-rep(0,nrow(lose))

#win, lose 테이블 rbind 이후 컬럼 이름 재정의
names(win)<-rep(NA,ncol(win))
names(lose)<-rep(NA,ncol(lose))
by.team<-rbind(win,lose)
names(by.team)<-c("Season","Daynum","Wloc","Numot","Team","Score","Fgm","Fga",
                   "Fgm3","Fga3","Ftm","Fta","Or","Dr","Ast","To","Stl","Blk","Pf",
                   "Result")

#시즌 평균 값 계산 시 연장전이 이루어진 경기는 제외
by.team<-by.team[by.team$Numot==0,]

#2점 슛 시도, 성공 숫자 계산(필드골-3점슛)
by.team$Fga2<-by.team$Fga-by.team$Fga3
by.team$Fgm2<-by.team$Fgm-by.team$Fgm3

by.team<-tbl_df(by.team)

#summarise(group_by(by.team,Team,Season),count=n())

#팀별, 시즌별로 평균 기록 aggregate
agg<-aggregate(cbind(Score,Fgm2,Fga2,Fgm3,Fga3,Ftm,Fta,Or,Dr,Ast,To,Stl,Blk,Pf,Result)~Season+Team,
               by.team,FUN=mean)

#2003-2011시즌까지를 train, 2012-2015시즌까지를 test로 분류
train<-agg[agg$Season %in% seq(2003,2011),]
test<-agg[agg$Season %in% seq(2012,2015),]


#세부적인 평균 기록을 바탕으로 승률에 대한 회귀분석
summary(lm(Result~Fgm2+Fga2+Fgm3+Fga3+Ftm+Fta+Or+Dr+Ast+To+Stl+Blk+Pf,train))
step(lm(Result~1,data=train),
     scope=list(lower=~1,upper=~Fgm2+Fga2+Fgm3+Fga3+Ftm+Fta+Or+Dr+Ast+To+Stl+Blk+Pf)
                                      ,direction='both')
#Call:
#lm(formula = Result ~ To + Ftm + Dr + Stl + Fga2 + Fgm2 + Fga3 + 
#     Or + Fgm3 + Fta + Blk, data = train)

#Coefficients:
#  (Intercept)           To          Ftm           Dr          Stl         Fga2         Fgm2         Fga3  
#0.509176    -0.045055     0.023165     0.039483     0.052300    -0.047079     0.051920    -0.049893  
#Or         Fgm3          Fta          Blk  
#0.044290     0.082790    -0.013048     0.003421  

#회귀분석에서 예측된 모델을 바탕으로 2012-2015시즌 승률 예측
test$Pred<-predict(lm(Result~To+Ftm+Dr+Stl+Fga2+Fgm2+Fga3+Or+Fgm3+Fta+Blk,train),newdata=test)

#실제 승률과의 오차 계산
test$Error<-test$Pred-test$Result

#head(test[,c("Result","Pred","Error")],30)

#오차에 대한 평균과 표준편차
c(mean(test$Error),sd(test$Error))

#############################################################################################################
TourneyDetailedResults <- read.csv("TourneyDetailedResults.csv",header=T)
TourneyTeamList<-unique(c(TourneyDetailedResults$Wteam, TourneyDetailedResults$Lteam))

#2003-2015시즌동안 토너먼트에 진출한 팀들의 자료만을 기준으로 예측 (agg1)
agg1<-agg[agg$Team %in% TourneyTeamList,]

train<-agg1[agg1$Season %in% seq(2003,2011),]
test<-agg1[agg1$Season %in% seq(2012,2015),]

summary(lm(Result~Fgm2+Fga2+Fgm3+Fga3+Ftm+Fta+Or+Dr+Ast+To+Stl+Blk+Pf,train))
step(lm(Result~1,data=train),
     scope=list(lower=~1,upper=~Fgm2+Fga2+Fgm3+Fga3+Ftm+Fta+Or+Dr+Ast+To+Stl+Blk+Pf)
     ,direction='both')

#step에서 채택된 변수들만으로 회귀모델 구성
test$Pred<-predict(lm(Result~Ast+To+Ftm+Dr+Stl+Fga2+Fgm2+Fga3+Or+Fgm3+Fta,train),newdata=test)

#실제 승률과의 오차 계산
test$Error<-test$Pred-test$Result

c(mean(test$Error),sd(test$Error))

