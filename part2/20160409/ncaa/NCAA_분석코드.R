setwd("E:/kaggle")
teamall <- read.csv("teamall.csv", header=T)

head(teamall)
str(teamall)
colnames(teamall)
teamall$wlevel <- as.factor(teamall$wlevel)
teamall$llevel <- as.factor(teamall$llevel)
teamall$Wwinratio <- as.numeric(teamall$Wwinratio)
teamall$lwinratio <- as.numeric(teamall$lwinratio)

teamall_train <- teamall[teamall$Season <= 2011, ]
teamall_vaild <- teamall[teamall$Season > 2011, ]

dim(teamall_train)
dim(teamall_vaild)

head(teamall_train)

library(dplyr)

#승리팀/패배팀 기준 합침
set1 <- teamall_train %>% select(SeedNumx, SeedNumy, WRts, lRts, WReFG, lReFG, WRoer, lRoer
                                 ,WRder, lRder, WRat, lRat, WRastratio, lRastratio, WRtoratio, lRtoratio,
                                 WRovr, lRovr, Wts, lts, WeFG, leFG , Woer, loer, Wder, lder,
                                 Wat, lat, Wastratio, lastratio, Wtoratio, ltoratio, WMx, WMy, wlevel, llevel, wfinal_last1, lfinal_last1, Wwinratio, lwinratio, Wpan, lpan) %>% mutate(result=1)

set2 <- teamall_train %>% select(SeedNumy, SeedNumx, lRts, WRts, lReFG, WReFG, lRoer, WRoer
                                 ,lRder, WRder, lRat, WRat, lRastratio, WRastratio, lRtoratio, WRtoratio,
                                 lRovr, WRovr, lts, Wts, leFG, WeFG , loer, Woer, lder, Wder,
                                 lat, Wat, lastratio, Wastratio, ltoratio, Wtoratio, WMy, WMx, llevel, wlevel, lfinal_last1, wfinal_last1, lwinratio, Wwinratio, lpan, Wpan) %>% mutate(result=0)

set3 <- teamall_vaild %>% select(SeedNumx, SeedNumy, WRts, lRts, WReFG, lReFG, WRoer, lRoer
                                 ,WRder, lRder, WRat, lRat, WRastratio, lRastratio, WRtoratio, lRtoratio,
                                 WRovr, lRovr, Wts, lts, WeFG, leFG , Woer, loer, Wder, lder,
                                 Wat, lat, Wastratio, lastratio, Wtoratio, ltoratio, WMx, WMy, wlevel, llevel, wfinal_last1, lfinal_last1, Wwinratio, lwinratio, Wpan, lpan) %>% mutate(result=1)


set4 <- teamall_vaild %>% select(SeedNumy, SeedNumx, lRts, WRts, lReFG, WReFG, lRoer, WRoer
                                 ,lRder, WRder, lRat, WRat, lRastratio, WRastratio, lRtoratio, WRtoratio,
                                 lRovr, WRovr, lts, Wts, leFG, WeFG , loer, Woer, lder, Wder,
                                 lat, Wat, lastratio, Wastratio, ltoratio, Wtoratio, WMy, WMx, llevel, wlevel, lfinal_last1, wfinal_last1, lwinratio, Wwinratio, lpan, Wpan) %>% mutate(result=0)

head(set1)
colnames(set1) <- c("team1seed", "team2seed", "team1Rts", "team2Rts", "team1ReFG", "team2ReFG",
                    "team1Roer", "team2Roer", "team1Rder", "team2Rder", "team1Rat", "team2Rat",
                    "team1Rastratio", "team2Rastratio", "team1Rtoratio", "team2Rtoratio",
                    "team1Rovr", "team2Rovr", 
                    "team1ts", "team2ts", "team1eFG", "team2eFG", "team1oer", "team2oer",
                    "team1der", "team2der", "team1at", "team2at", "team1astratio", "team2astratio",
                    "team1toratio", "team2toratio", "team1_seed_wm", "team2_seed_wm", "team1_location", "team2_location",
                    "team1_final" ,"team2_final", "team1_winratio", "team2_winratio", "team1_seasonplaycount", "team2_seasonplaycount", "team1win")

colnames(set2) <- c("team1seed", "team2seed", "team1Rts", "team2Rts", "team1ReFG", "team2ReFG",
                    "team1Roer", "team2Roer", "team1Rder", "team2Rder", "team1Rat", "team2Rat",
                    "team1Rastratio", "team2Rastratio", "team1Rtoratio", "team2Rtoratio", 
                    "team1Rovr", "team2Rovr", 
                    "team1ts", "team2ts", "team1eFG", "team2eFG", "team1oer", "team2oer",
                    "team1der", "team2der", "team1at", "team2at", "team1astratio", "team2astratio",
                    "team1toratio", "team2toratio", "team1_seed_wm", "team2_seed_wm", "team1_location" , "team2_location", 
                    "team1_final" ,"team2_final", "team1_winratio", "team2_winratio", "team1_seasonplaycount", "team2_seasonplaycount", "team1win")

colnames(set3) <- c("team1seed", "team2seed", "team1Rts", "team2Rts", "team1ReFG", "team2ReFG",
                    "team1Roer", "team2Roer", "team1Rder", "team2Rder", "team1Rat", "team2Rat",
                    "team1Rastratio", "team2Rastratio", "team1Rtoratio", "team2Rtoratio",
                    "team1Rovr", "team2Rovr", 
                    "team1ts", "team2ts", "team1eFG", "team2eFG", "team1oer", "team2oer",
                    "team1der", "team2der", "team1at", "team2at", "team1astratio", "team2astratio",
                    "team1toratio", "team2toratio", "team1_seed_wm", "team2_seed_wm", "team1_location" , "team2_location", 
                    "team1_final" ,"team2_final", "team1_winratio", "team2_winratio", "team1_seasonplaycount", "team2_seasonplaycount", "team1win")

colnames(set4) <- c("team1seed", "team2seed", "team1Rts", "team2Rts", "team1ReFG", "team2ReFG",
                    "team1Roer", "team2Roer", "team1Rder", "team2Rder", "team1Rat", "team2Rat",
                    "team1Rastratio", "team2Rastratio", "team1Rtoratio", "team2Rtoratio",
                    "team1Rovr", "team2Rovr", 
                    "team1ts", "team2ts", "team1eFG", "team2eFG", "team1oer", "team2oer",
                    "team1der", "team2der", "team1at", "team2at", "team1astratio", "team2astratio",
                    "team1toratio", "team2toratio", "team1_seed_wm", "team2_seed_wm", "team1_location" , "team2_location",
                    "team1_final" ,"team2_final", "team1_winratio", "team2_winratio", "team1_seasonplaycount", "team2_seasonplaycount", "team1win")

trainset <- rbind(set1, set2)
vaildset <- rbind(set3, set4)
trainset <- trainset %>% mutate(team1seed = as.numeric(team1seed), team2seed = as.numeric(team2seed))
vaildset <- vaildset %>% mutate(team1seed = as.numeric(team1seed), team2seed = as.numeric(team2seed))

str(trainset)
str(vaildset)

dim(trainset)
dim(vaildset)

trainset$team1win <- as.factor(trainset$team1win)
vaildset$team1win <- as.factor(vaildset$team1win)


head(trainset)

#시각화 부분
library(ggplot2)
head(trainset)
mosaicplot(trainset$team1win ~ trainset$team1_location, 
           main="team1win by ?!", shade=FALSE, 
           color=TRUE, xlab="team1_location", ylab="team1win")

mosaicplot(trainset$team1win ~ trainset$team2_location, 
           main="team1win by ?!", shade=FALSE, 
           color=TRUE, xlab="team2_location", ylab="team1win")


ts1 <- table(trainset$team1win,trainset$team1_location)
ts2 <- table(trainset$team1win,trainset$team2_location)

chisq.test(ts1)
chisq.test(ts2)

head(trainset)

ggplot(trainset, aes(x=team1_winratio-team2_winratio)) + geom_density(aes(group=team1win, colour=team1win, fill=team1win), alpha=0.5, adjust=2) + 
  theme_bw() +  theme(axis.text=element_text(size=24),  axis.title=element_text(size=30,face="bold")) + theme(legend.title = element_text(colour="black", size=30, face="bold")) + theme(legend.text = element_text(colour="black", size = 30)) 

ggplot(trainset, aes(x=team1seed-team2seed)) + geom_density(aes(group=team1win, colour=team1win, fill=team1win), alpha=0.5, adjust=2) + 
  theme_bw() +  theme(axis.text=element_text(size=24),  axis.title=element_text(size=30,face="bold")) + theme(legend.title = element_text(colour="black", size=30, face="bold")) + theme(legend.text = element_text(colour="black", size = 30)) 

M <- cor(trainset_matrix)
M

library(corrplot)
corrplot.mixed(M, lower = "number", upper = "ellipse")
corrplot(M, order = "hclust", addrect = 5)

#모델링 부분
library(randomForest)
set.seed(2310)
rftrain <- randomForest(team1win ~., data=trainset, importance=T, ntree=1000)
print(rftrain)
round(importance(rftrain), 2)
plot(rftrain)
varImpPlot(rftrain, n.var=30, scale=FALSE)
dev.off()
dim(vaildset)
dim(trainset)
head(vaildset)
vaildset$pred <- predict(rftrain, vaildset[,-43], type='prob')
vaildset$pred <- vaildset$pred[,2]


#평가함수
LogLoss <- function(pred, res){
  (-1/length(pred)) * sum (res * log(pred) + (1-res)*log(1-pred))
}
dim(trainset)
dim(vaildset)

#library(party)
#cftrain <- cforest(team1win ~.,  data = trainset, controls=cforest_unbiased(ntree=2000, mtry=28))

head(trainset)
dim(trainset)

#평가함수 값
with(vaildset, LogLoss(pred, as.numeric(team1win)))

library(AUC)
auc(sensitivity(vaildset$pred, as.factor(vaildset$team1win)))
auc(specificity(vaildset$pred, as.factor(vaildset$team1win)))
auc(accuracy(vaildset$pred, as.factor(vaildset$team1win)))
plot(roc(vaildset$pred, as.factor(vaildset$team1win)))

head(trainset)
dim(trainset)

#PCA
dim(trainset)
trainset_matrix <- data.matrix(trainset[,-43])
trainset_matrix1<-trainset_matrix[,1:ncol(trainset_matrix )]
head(trainset_matrix1)
m2 <- princomp(trainset_matrix1, cor=TRUE)
print(m2)
loadings(m2)
summary(m2)
?screeplot
screeplot(m2,type="line", npcs=43)
biplot(m2, choices=1:2, col = c("gray", "black"), arrow.len = 0.1, cex=c(1/2, 0.8), scale=T)
biplot(m2, choices=2:3, col = c("gray", "black"), arrow.len = 0.1, cex=c(1/2, 0.8))

library(rgl)
str(trainset)
trainset$team1win
head(trainset)
unique(trainset$team1win)
dim(m2$scores)
plot(m2,type="line")
dev.off()

trainset_matrix1$team1seed
trainset_skmeans$cluster
