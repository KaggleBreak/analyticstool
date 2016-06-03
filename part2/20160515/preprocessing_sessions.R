#### sessions.csv ####
sessions = fread("sessions.csv", stringsAsFactors = FALSE,
                 data.table = FALSE) # 600Mb
head(sessions)

sessions_2 = read.csv("sessions_2.csv", stringsAsFactors = FALSE)
head(sessions_2)

sessions_join = left_join(sessions, sessions_2, by = c("action" = "action", 
                                                       "action_detail" = "action_detail",
                                                       "action_type" = "action_type"))
head(sessions_join)
# rm(sessions)
# rm(sessions_2)

sessions_join = sessions_join[, -(2:4)]
head(sessions_join)

unique(sessions_join$device_type)
table(sessions_join$device_type)

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

sessions_join[, "PC"] = "no"
sessions_join[ sessions_join$device_type == "Windows Desktop", "PC"] = "yes"
sessions_join[ sessions_join$device_type == "Mac Desktop"    , "PC"] = "yes"
sessions_join[ sessions_join$device_type == "Linux Desktop"  , "PC"] = "yes"

head(sessions_join)

# write.csv(sessions_join, "sessions_join.csv", row.names = FALSE)
sessions_join = fread("sessions_join.csv", stringsAsFactors = FALSE,
                      data.table = FALSE)
head(sessions_join)
summary(sessions_join)
sum(is.na(sessions_join$secs_elapsed))/nrow(sessions_join) # 약 1.29% 결측

# sec_elapsed 결측 제거
sessions_join[ is.na(sessions_join$secs_elapsed), "secs_elapsed"] = 0 # 결측처리는 0으로

# sec_elapsed 추가 처리
sessions_join[, "secs_2"] = sessions_join$secs_elapsed
sessions_join[ sessions_join$secs_2 > 1200, "secs_2"] = 1200
sessions_join[ sessions_join$secs_2 < 10,   "secs_2"] = 0
sessions_join[ , "secs_2"] = round(sessions_join[ , "secs_2"], -1)
head(sessions_join)

# user_id 별로 통계를 만들자.
unique_user = unique(sessions_join$user_id) # 135484개 id
head(unique_user)

session_user = data.frame( user_id = unique_user,
                           session_no  = 0,
                           secs_total  = 0,
                           secs_avg    = 0,
                           device_main = "desktop",
                           device_no   = 0,
                           OS_main     = "windows",
                           OS_no       = 0,
                           action_main = "etc",
                           action_no   = 0,
                           booking     = "no",
                           stringsAsFactors = FALSE)

time = Sys.time()
for(n in 1:length(unique_user))
{
  sub = sessions_join[ sessions_join$user_id == unique_user[n], ]
  
  session_user[n, "session_no" ] =   nrow(sub)
  session_user[n, "secs_total" ] =    sum(sub$secs_elapsed)
  session_user[n, "device_main"] =   Mode(sub$device_type)
  session_user[n, "device_no"  ] = length(unique(sub$device_type))
  session_user[n, "OS_main"    ] =   Mode(sub$OS_type)
  session_user[n, "OS_no"      ] = length(unique(sub$OS_type))
  session_user[n, "action_main"] =   Mode(sub$action_1)
  session_user[n, "action_no"  ] = length(unique(sub$action_1))
  session_user[n, "booking"    ] = if(sum(sub$booking == "yes") > 0){"yes"} else {"no"}

  if((n %% 1000) == 0){
    print(paste0("==== ", n, " ===="))
    print(Sys.time() - time)
  } else {

  }
}
head(session_user)

# write.csv(session_user, "session_2_4.csv", row.names = FALSE)
session_user_1 = fread("session_2_3.csv", stringsAsFactors = FALSE, data.table = FALSE)
session_user_2 = fread("session_2_4.csv", stringsAsFactors = FALSE, data.table = FALSE)
session_user_3 = fread("session_2_5.csv", stringsAsFactors = FALSE, data.table = FALSE)
rcheck(session_user_2[1:110000,])
rcheck(session_user_3[110000:nrow(session_user_3),])

session_user_2[1:98000, ] = session_user_1 
session_user_2[110000:nrow(session_user_2), ] = session_user_3[110000:nrow(session_user_3),]
summary(session_user_2)

session_user_2[, "secs_avg"] = round(session_user_2$secs_total / session_user$session_no, 0)
head(session_user_2)

# write.csv(session_user_2, "session_final.csv", row.names = FALSE)
