# https://www.kaggle.com/zfturbo/santander-customer-satisfaction/xgb-lalala

install.packages("xgboost","Matrix")
library(xgboost)
library(Matrix)

set.seed(4321)
train <- read.csv("./train.csv")
test  <- read.csv("./test.csv")
 
# train <- read.csv("../input/train.csv")
# test  <- read.csv("../input/test.csv")

##### log10 train$var38
train$var38 <- log10(train$var38)

##### Removing IDs
train$ID <- NULL
test.id <- test$ID
test$ID <- NULL

##### Extracting TARGET
train.y <- train$TARGET
train$TARGET <- NULL

##### 0 count per line
count0 <- function(x) {
  return( sum(x == 0) )
}
train$n0 <- apply(train, 1, FUN=count0) # for a matrix 1 indicates rows, 2 indicates columns
test$n0 <- apply(test, 1, FUN=count0)

##### Removing constant features

# length(unique(train[[1]]))
cat("\n## Removing the constants features.\n")
for (f in names(train)) {
  if (length(unique(train[[f]])) == 1) {
    cat(f, "\n")
    train[[f]] <- NULL
    test[[f]] <- NULL
  }
}

##### Removing identical features

# combn(letters[1:4], 2)
features_pair <- combn(names(train), 2, simplify = F)
toRemove <- c()
for(pair in features_pair) {
  f1 <- pair[1]
  f2 <- pair[2]
  
  if (!(f1 %in% toRemove) & !(f2 %in% toRemove)) {
    if (all(train[[f1]] == train[[f2]])) {
      cat(f2, "\n")
      toRemove <- c(toRemove, f2)
    }
  }
}

# (x <- c(sort(sample(1:20, 9)), NA))
# (y <- c(sort(sample(3:23, 7)), NA))
# union(x, y)
# intersect(x, y)
# setdiff(x, y)
# setdiff(y, x)
# setequal(x, y)
feature.names <- setdiff(names(train), toRemove)

train <- train[, feature.names]
test <- test[, feature.names]

train$TARGET <- train.y


#Construct a sparse model or “design” matrix, form a formula and data frame 
train <- sparse.model.matrix(TARGET ~ ., data = train)

# Contruct xgb.DMatrix object from dense matrix, sparse matrix or local file.
dtrain <- xgb.DMatrix(data=train, label=train.y)
watchlist <- list(train=dtrain)

param <- list(  objective           = "binary:logistic", 
                booster             = "gbtree",
                eval_metric         = "auc",
                eta                 = 0.02,
                max_depth           = 7,
                subsample           = 0.68,
                colsample_bytree    = 0.7
)

clf <- xgb.train(   params              = param, 
                    data                = dtrain, 
                    nrounds             = 571, 
                    verbose             = 2,
                    watchlist           = watchlist,
                    maximize            = FALSE
)


test$TARGET <- -1
test <- sparse.model.matrix(TARGET ~ ., data = test)

preds <- predict(clf, test)
submission <- data.frame(ID=test.id, TARGET=preds)
cat("saving the submission file\n")
write.csv(submission, "submission.csv", row.names = F)
