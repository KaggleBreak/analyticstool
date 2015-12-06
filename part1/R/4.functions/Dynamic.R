# 1.
c <- 10 # variable name
c(c = c) # 'combine', named-vector's key:value pair

# 2.
# 1) Name masking   2) Functions vs Variables    3) A fresh start     4) Dynamic lookup

# 3.
f <- function(x) {
  f <- function(x) {
    f <- function(x) {
      x^2
    }
    f(x) + 1
  }
  f(x) * 2
}

f(10)