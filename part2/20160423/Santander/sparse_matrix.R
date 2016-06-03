# https://www.r-project.org/conferences/useR-2010/slides/Maechler+Bates.pdf

install.packages("Matrix")
library(Matrix)

# simple example — Triplet form
# The most obvious way to store a sparse matrix is the so called
# “Triplet” form; (virtual class TsparseMatrix in Matrix):

A <- spMatrix(10, 20, i = c(1,3:8), j = c(2,9,6:10), x = 7 * (1:7))
?spMatrix
A
str(A) 


# What to expect from a comparison on a sparse matrix?
A[2:7, 12:20] <- rep(c(0,0,0,(3:1)*30,0), length = 6*9)
A >= 20
1*(A >= 20)

# New model matrix classes, generalizing R’s standard
# model.matrix():
dd <- data.frame(a = gl(3,4), b = gl(4,1,12))
str(dd)
model.matrix(~ 0+ a + b, dd)
model.matrix(~ 0+ a * b, dd)

dd <- data.frame(a = gl(3,4), b = gl(4,1,12))# balanced 2-way
options("contrasts") # the default:  "contr.treatment"
sparse.model.matrix(~ a + b, dd)
sparse.model.matrix(~ -1+ a + b, dd)# no intercept --> even sparser
sparse.model.matrix(~ a + b, dd, contrasts = list(a="contr.sum"))
sparse.model.matrix(~ a + b, dd, contrasts = list(b="contr.SAS"))