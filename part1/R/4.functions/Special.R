# 1. Create a list of all the replacement functions found in the base package. Which ones are primitive functions?
if (!require('stringr')) {
  chooseCRANmirror(ind = 62)
  install.packages('stringr')
  library(stringr)
} else {
  library(stringr)
}

base_funs <- ls(pos = 'package:base')
rep_funs <- Filter(function(x) str_sub(x, start = -2) == '<-', base_funs)
prim_rep_funs <- Filter(function(x) is.primitive(match.fun(x)), rep_funs)



# 2. What are valid names for user-created infix functions?


# 3. Create an infix xor() operator.
`%xor%` <- function(x, y) {
  if (is.logical(x) & is.logical(y)) {
    if (x == TRUE & y == TRUE) {
      return(FALSE)
    } else if (x == TRUE & y == FALSE) {
      return(TRUE)
    } else if (x == FALSE & y == TRUE) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}


# 4. Create infix versions of the set functions intersect(), union(), and setdiff().
`%inter%` <- function(x, y) {
  unique(y[match(x, y, 0L)])
}

`%union%` <- function(x, y) {
  unique(c(x, y))
}

`%setdiff%` <- function(x, y) {
  if (length(x) || length(y)) {
    unique(x[match(x, y, 0L) == 0L])
  } else {
    x
  }
}

# 5. Create a replacement function that modifies a random location in a vector.
`randchange<-` <- function(x, value) {
  n <- length(x)
  position <- sample(1:n, 1)
  x[position] <- value
  return(x)
}

