#Subsetting
##Data types
###Atomic vectors
x <- c(2.1, 4.2, 3.3, 5.4)
x[c(3, 1)]
x[order(x)]
x[c(1, 1)]
x[c(2.1, 2.9)]
x[-c(3, 1)]
x[c(-1, 2)]
x[c(TRUE, TRUE, FALSE, FALSE)]
x[x>3]
x[c(TRUE, FALSE)]
x[c(TRUE, FALSE, TRUE, FALSE)]
x[]
x[0]

y <- setNames(x, letters[1:4])
y
y[c("d", "c", "a")]

###Matrices and arrays
a <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")
a
a[1:2, ]
a[c(T, F, T), c("B", "A")]
a[0, -2]

vals <- outer(1:5, 1:5, FUN = "paste", sep = ",")
vals
vals[c(4, 15)]

select <- matrix(ncol = 2, byrow = TRUE, c(
  1, 1,
  3, 1,
  2, 4
  ))
vals[select]

###Data frames
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df
df[df$x == 2, ]
df[c(1,3), ]
df[c("x", "z")]
df[,c("x", "z")]
str(df["x"])
str(df[, "x"])

####Exercises
mtcars[mtcars$cyl = 4, ]
mtcars[-1:4, ]
mtcars[mtcars$cyl <= 5]
mtcars[mtcars$cyl == 4 | 6, ]

x <- 1:5
x[NA]
x[NA_real_]

x <- outer(1:5, 1:5, FUN = "*")
x
x[upper.tri(x)]


##Subsetting operators
a <- list(a = 1 , b = 2)
a[[1]]
a[["a"]]

b <- list(a = list(b = list(c = list(d = 1))))
b
b[[c("a", "b", "c", "d")]]
b[["a"]][["b"]][["c"]][["d"]]


###Simplifying vs. preserving subsetting
df <- data.frame(a = 1:2, b = 1:2)
str(df[1])
str(df[[1]])
str(df[, "a", drop = FALSE])
str(df[, "a"])

###$
var <- "cyl"
mtcars$var
mtcars[[var]] ##sameas mtcars$cyl

x <- list(abc = 1)
x$a
x[["a"]]

##Subsetting and assignment
x <- 1:5
x[c(1,2)] <- 2:3
x
x[-1] <- 4:1
x
x[c(1, 1)] <- 2:3
x
x[c(1, NA)] <- c(1,2)
x[c(T, F, NA)] <- 1
x

df <- data.frame(a = c(1, 10, NA))
df$a[df$a < 5] <- 0
df$a

x <- list(a = 1, b = 2)
x[["b"]] <- NULL
str(x)

y <- list(a = 1)
y["b"] <- list(NULL)
str(y)


##Applications
###Lookup tables
x <- c("m", "f", "u", "f", "f", "m", "m")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]
unname(lookup[x])
c(m = "Known", f = "Known", u = "Unknown")[x]

###Matching and merging by hand
grades <- c(1, 2, 2, 3, 1)
info <- data.frame(
  grade = 3:1,
  desc = c("Excellent", "Good", "Poor"),
  fail = c(F, F, T)
  )
grades
id <- match(grades, info$grade)
info[id,]
rownames(info) <- info$grade
info[as.character(grades),]


###Random samples / bootstrap
df <- data.frame(x = rep(1:3, each = 2), y = 6:1, z = letters[1:6])
df
set.seed(10)
df[sample(nrow(df)), ]
df[sample(nrow(df), 3), ]
df[sample(nrow(df), 6, rep = T), ]


###Ordering
x <- c("b", "c", "a")
order(x)
x[order(x)]
sort(x)
sort(x, decreasing = T)

df2 <- df[sample(nrow(df)), 3:1]
df2
df2[order(df2$x), ]
df2[, order(names(df2))]


###Expanding aggregated counts
df <- data.frame(x = c(2, 4, 1), y = c(9, 11, 6), n = c(3, 5, 1))
rep(1:nrow(df), df$n)
df[rep(1:nrow(df), df$n), ]

###Removing columns from data frames
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df$z <- NULL
df[c("x", "y")]
df[setdiff(names(df), "z")]


###Selecting rows based on a condition
mtcars[mtcars$gear == 5, ]
mtcars[mtcars$gear == 5 & mtcars$cyl == 4, ]
mtcars[mtcars$gear == 5 | mtcars$cyl == 4, ]
subset(mtcars, gear == 5)
subset(mtcars, gear == 5 & cyl == 4)
subset(mtcars, gear == 5 | cyl == 4)


###Boolean algebra vs. sets
x <- sample(10) < 4
x
which(x)

unwhich <- function(x, n){
  out <- rep_len(FALSE, n)
  out[x] <- TRUE
  out
}
unwhich(which(x), 10)

(x1 <- 1:10 %% 2 == 0)
(x2 <- which(x1))
(y1 <- 1:10 %% 5 == 0)
(y2 <- which(y1))

x1 & y1
intersect(x2, y2)

x1 | y1
union(x2, y2)

x1 & !y1
setdiff(x2, y2)

xor(x1, y1)
setdiff(union(x2, y2), intersect(x2, y2))
