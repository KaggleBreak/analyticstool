# Exercise 1.
objs <- mget(ls('package:base'), inherits = TRUE)
funs <- Filter(is.function, objs)

# (a) Which base function has the most argumets?
max_num <- max(sapply(funs, function(x) length(formals(x))))

Filter(function(x) length(formals(x)) == max_num, funs)

# (b) How many base functions have no arguments? What's special about those functions?
funs_no_arg <- Filter(function(x) length(formals(x)) == 0, funs)
# funs_no_arg <- Filter(is.primitive, funs)
length(funs_no_arg) # 225 functions
head(funs_no_arg, 20) # infix functions