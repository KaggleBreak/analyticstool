# 1. Clarify the following list of odd function calls:
x <- sample(replace = TRUE, 20, x = c(1:10, NA))
y <- runif(min = 0, max = 1, 20)
cor(m = "k", y = y, u = "p", x = x) # use argument option: all.obs, complete.obs, pairwise.complete.obs
cor(m = "k", y = y, u = "a", x = x)
cor(m = "k", y = y, u = "c", x = x)


# 2. What does this function return? Why? Which principle does it illustrate?
f1 <- function(x = {y <- 1; 2}, y = 0) {
  x + y
}
f1()

# 3. What does this function return? Why? Which principle does it illustrate?
f2 <- function(x = z) {
  z <- 100
  x
}
f2()