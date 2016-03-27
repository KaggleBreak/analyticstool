RegularSeasonDetailedResults <- read.csv("data/RegularSeasonDetailedResults.csv", header = T)


library(sqldf)


# ½Â¸®ÆÀ ±âÁØ
wtdf <- sqldf("select Season, Wteam team, Wscore score, Wfgm fgm, Wfga fga, Wfgm3 fgm3, Wfga3 fga3,
              Wftm ftm, Wfta fta, Wor [or], Wdr dr, Wast ast, Wto [to], Wstl stl, Wblk blk, Wpf pf,
              Lscore Oscore, Lfgm Ofgm, Lfga Ofga, Lfgm3 Ofgm3, Lfga3 Ofga3,
              Lftm Oftm, Lfta Ofta, Lor Oor, Ldr Odr, Last Oast, Lto Oto, Lstl Ostl, Lblk Oblk, Lpf Opf
              from RegularSeasonDetailedResults
              ")

# ÆÐ¹èÆÀ ±âÁØ              
ltdf <- sqldf("select Season, Lteam team, Lscore score, Lfgm fgm, Lfga fga, Lfgm3 fgm3, Lfga3 ga3,
              Lftm ftm, Lfta fta, Lor [or], Ldr dr, Last ast, Lto [to], Lstl stl, Lblk blk, Lpf pf,
              Wscore Oscore, Wfgm Ofgm, Wfga Ofga, Wfgm3 Ofgm3, Wfga3 Ofga3,
              Wftm Oftm, Wfta Ofta, Wor Oor, Wdr Odr, Wast Oast, Wto Oto, Wstl Ostl, Wblk Oblk, Wpf Opf
              from RegularSeasonDetailedResults
              ")


#½Â¸®ÆÀ°ú ÆÐ¹èÆÀÀ» °áÇÕ
Steam <- sqldf("select Season, team, sum(score) score, sum(fgm) fgm, sum(fga) fga, sum(fgm3) fgm3, sum(fga3) fga3,
                sum(ftm) ftm, sum(fta) fta, sum([or]) [or], sum(dr) dr, sum(ast) ast, sum([to]) [to], sum(stl) stl, sum(blk) blk, sum(pf) pf,
                sum(Oscore) Oscore, sum(Ofgm) Ofgm, sum(Ofga) Ofga, sum(Ofgm3) Ofgm3, sum(Ofga3) Ofga3,
                sum(Oftm) Oftm, sum(Ofta) Ofta, sum(Oor) Oor, sum(Odr) Odr, sum(Oast) Oast, sum(Oto) Oto, sum(Ostl) Ostl, sum(Oblk) Oblk, sum(Opf) Opf
                from (select * from wtdf
                      union all
                      select * from ltdf
                      )
                group by Season, team
                ")


attach(Steam)

# TS% - True Shooting Percentage - what a team's shooting percentage would be if we accounted for free throws and 3-pointers
# True Shooting Percentage = points / (2 * (FGA + (FTA x 0.44))
ts <- round(score / (2 * (fga + (0.44 * fta))),3)


# eFG% - 3Á¡¿¡ °¡ÁßÄ¡¸¦ ºÎ¿©ÇÑ ½´ÆÃÈ¿À² 
eFG <- round((fgm + (0.5 * fgm3)) / fga, 3)


# oer, Offensive Efficiency Rating - 100Æ÷Á¦¼ÇÀ¸·Î È¯»êÇÏ¿´À» ¶§ Æò±Õ µæÁ¡
# Points x (100/(Field Goals Attempted - Off Rebounds + Turnovers + (Free Throws Attempted * 0.44))))
oer <- round(score * (100/(fga - or + to + (0.44 * fta))), 3)
der <- round(Oscore * (100/(Ofga - Oor + Oto + (0.44 * Ofta))), 3)

# at - Assist / Turnover Ratio
at <- round(ast / to, 3)

# ast.ratio , assist ratio - the percentage of a team's possessions that ends in an assist
# Assist Ratio = (Assists x 100) / ((FGA + (FTA x 0.44) + Assists + Turnovers)
ast.ratio <- round(ast * 100 / (fga + (fga * 0.44) + ast + to), 3)

# to.ratio , turnover ratio - the percentage of a team's possessions that end in a turnover
# Turnover Ratio = (Turnover x 100) / ((FGA + (FTA x 0.44) + Assists + Turnovers)
to.ratio <- round(to * 100 / (fga + (fga * 0.44) + ast + to), 3) 





team <- data.frame(season = Steam$Season, team = Steam$team, ts, eFG, oer, der, at, ast.ratio, to.ratio)



# Rank
Rts <- NULL
for( i in 2003:2015){
  Rts <- append(Rts, as.character(cut(team[Season==i,]$ts, breaks=4, labels=c("D","C","B","A"))))
}

ReFG <- NULL
for( i in 2003:2015){
  ReFG <- append(ReFG, as.character(cut(team[Season==i,]$eFG, breaks=4, labels=c("D","C","B","A"))))
}

Roer <- NULL
for( i in 2003:2015){
  Roer <- append(Roer, as.character(cut(team[Season==i,]$oer, breaks=4, labels=c("D","C","B","A"))))
}

Rder <- NULL
for( i in 2003:2015){
  Rder <- append(Rder, as.character(cut(team[Season==i,]$der, breaks=4, labels=c("A","B","C","D"))))
}

Rat <- NULL
for( i in 2003:2015){
  Rat <- append(Rat, as.character(cut(team[Season==i,]$at, breaks=4, labels=c("D","C","B","A"))))
}

Rast.ratio <- NULL
for( i in 2003:2015){
  Rast.ratio <- append(Rast.ratio, as.character(cut(team[Season==i,]$ast.ratio, breaks=4, labels=c("D","C","B","A"))))
}

Rto.ratio <- NULL
for( i in 2003:2015){
  Rto.ratio <- append(Rto.ratio, as.character(cut(team[Season==i,]$to.ratio, breaks=4, labels=c("A","B","C","D"))))
}



detach(Steam)



# 2Â÷ ½ºÅÝÀ» È°¿ëÇÑ °¢ ½ÃÁðº°, ÆÀÀÇ ·©Å©
Rteam <- data.frame(season = Steam$Season, team = Steam$team, Rts, ReFG, Roer, Rder, Rat, Rast.ratio, Rto.ratio)








