
# 캐글뽀개기 분석툴(주말) R 2015-10-24(토) Advanced R by Hadley Wickham
## Introduction
- It’s free, open source, and available on every major platform. As a result, if you do your analysis in R, anyone can easily replicate it.
- A massive set of packages for statistical modelling, machine learning, visualisation, and importing and manipulating data. Whatever model or graphic you’re trying to do, chances are that someone has already tried to do it. At a minimum, you can learn from their efforts.
- Cutting edge tools. Researchers in statistics and machine learning will often publish an R package to accompany their articles. This means immediate access to the very latest statistical techniques and implementations.
- Deep-seated language support for data analysis. This includes features likes missing values, data frames, and subsetting.
- A fantastic community. It is easy to get help from experts on the R-help mailing list, stackoverflow, or subject-specific mailing lists like R-SIG-mixed-models or ggplot2. You can also connect with other R learners via twitter, linkedin, and through many local user groups.
- Powerful tools for communicating your results. R packages make it easy to produce html or pdf reports, or create interactive websites.
- A strong foundation in functional programming. The ideas of functional programming are well suited to solving many of the challenges of data analysis. R provides a powerful and flexible toolkit which allows you to write concise yet descriptive code.
- An IDE tailored to the needs of interactive data analysis and statistical programming.
- Powerful metaprogramming facilities. R is not just a programming language, it is also an environment for interactive data analysis. Its metaprogramming capabilities allow you to write magically succinct and concise functions and provide an excellent environment for designing domain-specific languages.
- Designed to connect to high-performance programming languages like C, Fortran, and C++.
- Much of the R code you’ll see in the wild is written in haste to solve a pressing problem. As a result, code is not very elegant, fast, or easy to understand. Most users do not revise their code to address these shortcomings.
- Compared to other programming languages, the R community tends to be more focussed on results instead of processes. Knowledge of software engineering best practices is patchy: for instance, not enough R programmers use source code control or automated testing.
- Metaprogramming is a double-edged sword. Too many R functions use tricks to reduce the amount of typing at the cost of making code that is hard to understand and that can fail in unexpected ways.
- Inconsistency is rife across contributed packages, even within base R. You are confronted with over 20 years of evolution every time you use R. Learning R can be tough because there are many special cases to remember.
- R is not a particularly fast programming language, and poorly written R code can be terribly slow. R is also a profligate user of memory.

## Who should read this book
- Intermediate R programmers who want to dive deeper into R and learn new strategies for solving diverse problems.
- Programmers from other languages who are learning R and want to understand why R works the way it does.


## Data structures
- This chapter summarises the most important data structures in base R. You’ve probably used many (if not all) of them before, but you may not have thought deeply about how they are interrelated. In this brief overview, I won’t discuss individual types in depth. Instead, I’ll show you how they fit together as a whole. If you need more details, you can find them in R’s documentation.

- R’s base data structures can be organised by their dimensionality (1d, 2d, or nd) and whether theyre 동질성(homogeneous) (all contents must be of the same type) or 이질성(heterogeneous) (the contents can be of different types). This gives rise to the five data types most often used in data analysis:

| dim | Homogeneous | Heterogeneous |
|:-----------|------------:|:------------:|
| 1d      |Atomic vector |     List     
| 2d     |Matrix	Data | Data frame    
| nd       |       array |     will     

- Almost all other objects are built upon these foundations. In the OO field guide you’ll see how more complicated objects are built of these simple pieces. Note that R has no 0-dimensional, or scalar types. Individual numbers or strings, which you might think would be scalars, are actually vectors of length one.

## Vectors
- The basic data structure in R is the vector. Vectors come in two flavours: atomic vectors and lists. They have three common properties:

- Type, typeof(), what it is.
- Length, length(), how many elements it contains.
- Attributes, attributes(), additional arbitrary metadata.
- They differ in the types of their elements: all elements of an atomic vector must be the same type(원자벡터는 같은 타입), whereas the elements of a list can have different types(리스트는 다른 타입)
- NB: is.vector() does not test if an object is a vector. Instead it returns TRUE only if the object is a vector with no attributes apart from names. Use is.atomic(x) || is.list(x) to test if an object is actually a vector.


```R
typeof(2)
```




"double"




```R
mode(2)
```




"numeric"




```R
is.atomic(2)
```




TRUE




```R
is.vector(2)
```




TRUE



## Atomic vectors
- There are four common types of atomic vectors that Ill discuss in detail: logical, integer, double (often called numeric), and character. There are two rare types that I will not discuss further: complex and raw.
- Atomic vectors are usually created with c(), short for combine:


```R
dbl_var <- c(1, 2.5, 4.5)
# With the L suffix, you get an integer rather than a double
int_var <- c(1L, 6L, 10L)
# Use TRUE and FALSE (or T and F) to create logical vectors
log_var <- c(TRUE, FALSE, T, F)
chr_var <- c("these are", "some strings")
```


```R
typeof(dbl_var)
```




"double"




```R
typeof(int_var)
```




"integer"




```R
typeof(log_var)
```




"logical"




```R
typeof(chr_var)
```




"character"




```R
c(1, c(2, c(3, 4)))
#> [1] 1 2 3 4
# the same as
c(1, 2, 3, 4)
#> [1] 1 2 3 4
```




<ol class=list-inline>
	<li>1</li>
	<li>2</li>
	<li>3</li>
	<li>4</li>
</ol>







<ol class=list-inline>
	<li>1</li>
	<li>2</li>
	<li>3</li>
	<li>4</li>
</ol>




- Missing values are specified with NA, which is a logical vector of length 1. NA will always be coerced to the correct type if used inside c(), or you can create NAs of a specific type with NA_real_ (a double vector), NA_integer_ and NA_character_.

## Types and tests
- Given a vector, you can determine its type with typeof(), or check if it’s a specific type with an “is” function: is.character(), is.double(), is.integer(), is.logical(), or, more generally, is.atomic().


```R
int_var <- c(1L, 6L, 10L)
typeof(int_var)
#> [1] "integer"
is.integer(int_var)
#> [1] TRUE
is.atomic(int_var)
#> [1] TRUE

dbl_var <- c(1, 2.5, 4.5)
typeof(dbl_var)
#> [1] "double"
is.double(dbl_var)
#> [1] TRUE
is.atomic(dbl_var)
#> [1] TRUE
```




"integer"






TRUE






TRUE






"double"






TRUE






TRUE




```R
is.numeric(int_var) #integer and double vectors 
#> [1] TRUE
is.numeric(dbl_var)
#> [1] TRUE
```




TRUE






TRUE



## Coercion
- All elements of an atomic vector must be the same type, so when you attempt to combine different types they will be coerced to the most flexible type. Types from least to most flexible are: logical, integer, double, and character.
- For example, combining a character and an integer yields a character:


```R
str(c("a", 1))
#>  chr [1:2] "a" "1"
```

     chr [1:2] "a" "1"
    


```R
x <- c(FALSE, FALSE, TRUE)
as.numeric(x)
#> [1] 0 0 1
```




<ol class=list-inline>
	<li>0</li>
	<li>0</li>
	<li>1</li>
</ol>





```R
# Total number of TRUEs
sum(x)
#> [1] 1

```




1




```R
# Proportion that are TRUE
mean(x)
#> [1] 0.3333333
```




0.333333333333333



- Coercion often happens automatically. Most mathematical functions (+, log, abs, etc.) will coerce to a double or integer, and most logical operations (&, |, any, etc) will coerce to a logical. You will usually get a warning message if the coercion might lose information. If confusion is likely, explicitly coerce with as.character(), as.double(), as.integer(), or as.logical().

## Lists
- Lists are different from atomic vectors because their elements can be of any type, including lists. You construct lists by using list() instead of c():


```R
x <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9))
str(x)
#> List of 4
#>  $ : int [1:3] 1 2 3
#>  $ : chr "a"
#>  $ : logi [1:3] TRUE FALSE TRUE
#>  $ : num [1:2] 2.3 5.9
```

    List of 4
     $ : int [1:3] 1 2 3
     $ : chr "a"
     $ : logi [1:3] TRUE FALSE TRUE
     $ : num [1:2] 2.3 5.9
    

- Lists are sometimes called recursive vectors, because a list can contain other lists. This makes them fundamentally different from atomic vectors.


```R
x <- list(list(list(list())))
str(x)
```

    List of 1
     $ :List of 1
      ..$ :List of 1
      .. ..$ : list()
    


```R
is.recursive(x)
```




TRUE




```R
x <- list(list(1, 2), c(3, 4))
y <- c(list(1, 2), c(3, 4))
str(x)
```

    List of 2
     $ :List of 2
      ..$ : num 1
      ..$ : num 2
     $ : num [1:2] 3 4
    


```R
str(y)
```

    List of 4
     $ : num 1
     $ : num 2
     $ : num 3
     $ : num 4
    

- The typeof() a list is list. You can test for a list with is.list() and coerce to a list with as.list(). You can turn a list into an atomic vector with unlist(). If the elements of a list have different types, unlist() uses the same coercion rules as c().

- Lists are used to build up many of the more complicated data structures in R. For example, both data frames (described in data frames) and linear models objects (as produced by lm()) are lists:


```R
is.list(mtcars)
#> [1] TRUE

mod <- lm(mpg ~ wt, data = mtcars)
is.list(mod)
#> [1] TRUE
```




TRUE






TRUE



## Attributes
- All objects can have arbitrary additional attributes, used to store metadata about the object. Attributes can be thought of as a named list (with unique names). Attributes can be accessed individually with attr() or all at once (as a list) with attributes().


```R
y <- 1:10
attr(y, "my_attribute") <- "This is a vector"
attr(y, "my_attribute")
```




"This is a vector"




```R
str(attributes(y))
```

    List of 1
     $ my_attribute: chr "This is a vector"
    


```R
structure(1:10, my_attribute = "This is a vector")
```




<ol class=list-inline>
	<li>1</li>
	<li>2</li>
	<li>3</li>
	<li>4</li>
	<li>5</li>
	<li>6</li>
	<li>7</li>
	<li>8</li>
	<li>9</li>
	<li>10</li>
</ol>





```R
structure(1:6, dim = 2:3)
```




<table>
<tbody>
	<tr><td>1</td><td>3</td><td>5</td></tr>
	<tr><td>2</td><td>4</td><td>6</td></tr>
</tbody>
</table>





```R
attributes(y[1])
```




    NULL




```R
attributes(sum(y))
```




    NULL



- The only attributes not lost are the three most important:
- Names, a character vector giving each element a name, described in names.
- Dimensions, used to turn vectors into matrices and arrays, described in matrices and arrays.
- Class, used to implement the S3 object system, described in S3.
- Each of these attributes has a specific accessor function to get and set values. When working with these attributes, use names(x), dim(x), and class(x), not attr(x, "names"), attr(x, "dim"), and attr(x, "class").

## Names
- You can name a vector in three ways:
- When creating it: x <- c(a = 1, b = 2, c = 3).
- By modifying an existing vector in place: x <- 1:3; names(x) <- c("a", "b", "c").
- By creating a modified copy of a vector: x <- setNames(1:3, c("a", "b", "c")).

- Names don’t have to be unique. However, character subsetting, described in subsetting, is the most important reason to use names and it is most useful when the names are unique.

- Not all elements of a vector need to have a name. If some names are missing, names() will return an empty string for those elements. If all names are missing, names() will return NULL.


```R
y <- c(a = 1, 2, 3)
names(y)
```




<ol class=list-inline>
	<li>"a"</li>
	<li>""</li>
	<li>""</li>
</ol>





```R
z <- c(1, 2, 3)
names(z)
```




    NULL



## Factors
- One important use of attributes is to define factors. A factor is a vector that can contain only predefined values, and is used to store categorical data. Factors are built on top of integer vectors using two attributes: the class(), “factor”, which makes them behave differently from regular integer vectors, and the levels(), which defines the set of allowed values.


```R
x <- factor(c("a", "b", "b", "a"))
x
```




<ol class=list-inline>
	<li>a</li>
	<li>b</li>
	<li>b</li>
	<li>a</li>
</ol>





```R
class(x)
```




"factor"




```R
levels(x)
```




<ol class=list-inline>
	<li>"a"</li>
	<li>"b"</li>
</ol>





```R
x[2] <- "c"
```

    Warning message:
    In `[<-.factor`(`*tmp*`, 2, value = "c"): invalid factor level, NA generated


```R
c(factor("a"), factor("b"))
```




<ol class=list-inline>
	<li>1</li>
	<li>1</li>
</ol>





```R
x
```




<ol class=list-inline>
	<li>a</li>
	<li>NA</li>
	<li>b</li>
	<li>a</li>
</ol>





```R
sex_char <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))
```


```R
table(sex_char)
```




    sex_char
    m 
    3 




```R
table(sex_factor)
```




    sex_factor
    m f 
    3 0 



- Sometimes when a data frame is read directly from a file, a column you’d thought would produce a numeric vector instead produces a factor. 

- This is caused by a non-numeric value in the column, often a missing value encoded in a special way like . or -. To remedy the situation, coerce the vector from a factor to a character vector, and then from a character to a double vector. (Be sure to check for missing values after this process.) 

- Of course, a much better plan is to discover what caused the problem in the first place and fix that; using the na.strings argument to read.csv() is often a good place to start.


```R
z <- read.csv(text = "value\n12\n1\n.\n9")
```


```R
z
```




<table>
<thead><tr><th></th><th scope=col>value</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>12</td></tr>
	<tr><th scope=row>2</th><td>1</td></tr>
	<tr><th scope=row>3</th><td>.</td></tr>
	<tr><th scope=row>4</th><td>9</td></tr>
</tbody>
</table>





```R
typeof(z$value)
```




"integer"




```R
as.double(z$value)
```




<ol class=list-inline>
	<li>3</li>
	<li>2</li>
	<li>1</li>
	<li>4</li>
</ol>





```R
class(z$value)
```




"factor"




```R
as.double(as.character(z$value))
```

    Warning message:
    In eval(expr, envir, enclos): 강제형변환에 의해 생성된 NA 입니다




<ol class=list-inline>
	<li>12</li>
	<li>1</li>
	<li>NA</li>
	<li>9</li>
</ol>





```R
z <- read.csv(text = "value\n12\n1\n.\n9", na.strings=".")
typeof(z$value)
```




"integer"




```R
class(z$value)
```




"integer"




```R
z$value
```




<ol class=list-inline>
	<li>12</li>
	<li>1</li>
	<li>NA</li>
	<li>9</li>
</ol>




- Unfortunately, most data loading functions in R automatically convert character vectors to factors. 

- This is suboptimal, because there’s no way for those functions to know the set of all possible levels or their optimal order. 

- Instead, use the argument stringsAsFactors = FALSE to suppress this behaviour, and then manually convert character vectors to factors using your knowledge of the data. 

- A global option, options(stringsAsFactors = FALSE), is available to control this behaviour, but I don’t recommend using it. Changing a global option may have unexpected consequences when combined with other code (either from packages, or code that you’re source()ing), and global options make code harder to understand because they increase the number of lines you need to read to understand how a single line of code will behave.

- While factors look (and often behave) like character vectors, they are actually integers. Be careful when treating them like strings. Some string methods (like gsub() and grepl()) will coerce factors to strings, while others (like nchar()) will throw an error, and still others (like c()) will use the underlying integer values. For this reason, it’s usually best to explicitly convert factors to character vectors if you need string-like behaviour. In early versions of R, there was a memory advantage to using factors instead of character vectors, but this is no longer the case.

## Matrices and arrays
- Adding a dim() attribute to an atomic vector allows it to behave like a multi-dimensional array. A special case of the array is the matrix, which has two dimensions. Matrices are used commonly as part of the mathematical machinery of statistics. Arrays are much rarer, but worth being aware of.

- Matrices and arrays are created with matrix() and array(), or by using the assignment form of dim():


```R
# Two scalar arguments to specify rows and columns
a <- matrix(1:6, ncol = 3, nrow = 2)
# One vector argument to describe all dimensions
b <- array(1:12, c(2, 3, 2))
```


```R
a
b
```




<table>
<tbody>
	<tr><td>1</td><td>3</td><td>5</td></tr>
	<tr><td>2</td><td>4</td><td>6</td></tr>
</tbody>
</table>







<ol class=list-inline>
	<li>1</li>
	<li>2</li>
	<li>3</li>
	<li>4</li>
	<li>5</li>
	<li>6</li>
	<li>7</li>
	<li>8</li>
	<li>9</li>
	<li>10</li>
	<li>11</li>
	<li>12</li>
</ol>





```R
c <- 1:6
dim(c) <- c(3, 2)
```


```R
c
```




<table>
<tbody>
	<tr><td>1</td><td>4</td></tr>
	<tr><td>2</td><td>5</td></tr>
	<tr><td>3</td><td>6</td></tr>
</tbody>
</table>





```R
dim(c) <- c(2, 3)
```


```R
c
```




<table>
<tbody>
	<tr><td>1</td><td>3</td><td>5</td></tr>
	<tr><td>2</td><td>4</td><td>6</td></tr>
</tbody>
</table>




- length() and names() have high-dimensional generalisations:

- length() generalises to nrow() and ncol() for matrices, and dim() for arrays.

- names() generalises to rownames() and colnames() for matrices, and dimnames(), a list of character vectors, for arrays.


```R
length(a)
#> [1] 6
```




6




```R
nrow(a)
#> [1] 2
```




2




```R
ncol(a)
#> [1] 3
```




3




```R
rownames(a) <- c("A", "B")
colnames(a) <- c("a", "b", "c")
```


```R
a
```




<table>
<thead><tr><th></th><th scope=col>a</th><th scope=col>b</th><th scope=col>c</th></tr></thead>
<tbody>
	<tr><th scope=row>A</th><td>1</td><td>3</td><td>5</td></tr>
	<tr><th scope=row>B</th><td>2</td><td>4</td><td>6</td></tr>
</tbody>
</table>





```R
length(b)
#> [1] 12
dim(b)
#> [1] 2 3 2
```




12






<ol class=list-inline>
	<li>2</li>
	<li>3</li>
	<li>2</li>
</ol>





```R
dimnames(b) <- list(c("one", "two"), c("a", "b", "c"), c("A", "B"))
b
#jupyter... her
```




<ol class=list-inline>
	<li>1</li>
	<li>2</li>
	<li>3</li>
	<li>4</li>
	<li>5</li>
	<li>6</li>
	<li>7</li>
	<li>8</li>
	<li>9</li>
	<li>10</li>
	<li>11</li>
	<li>12</li>
</ol>




- c() generalises to cbind() and rbind() for matrices, and to abind() (provided by the abind package) for arrays. You can transpose a matrix with t(); the generalised equivalent for arrays is aperm().

- You can test if an object is a matrix or array using is.matrix() and is.array(), or by looking at the length of the dim(). as.matrix() and as.array() make it easy to turn an existing vector into a matrix or array.

- Vectors are not the only 1-dimensional data structure. You can have matrices with a single row or single column, or arrays with a single dimension. They may print similarly, but will behave differently. The differences aren’t too important, but it’s useful to know they exist in case you get strange output from a function (tapply() is a frequent offender). As always, use str() to reveal the differences.


```R
?tapply
```





<table width="100%" summary="page for tapply {base}"><tr><td>tapply {base}</td><td align="right">R Documentation</td></tr></table>

<h2>Apply a Function Over a Ragged Array</h2>

<h3>Description</h3>

<p>Apply a function to each cell of a ragged array, that is to each
(non-empty) group of values given by a unique combination of the
levels of certain factors.
</p>


<h3>Usage</h3>

<pre>
tapply(X, INDEX, FUN = NULL, ..., simplify = TRUE)
</pre>


<h3>Arguments</h3>

<table summary="R argblock">
<tr valign="top"><td><code>X</code></td>
<td>
<p>an atomic object, typically a vector.</p>
</td></tr>
<tr valign="top"><td><code>INDEX</code></td>
<td>
<p>list of one or more factors, each of same length as
<code>X</code>.  The elements are coerced to factors by <code>as.factor</code>.</p>
</td></tr>
<tr valign="top"><td><code>FUN</code></td>
<td>
<p>the function to be applied, or <code>NULL</code>.  In the case of
functions like <code>+</code>, <code>%*%</code>, etc., the function name must
be backquoted or quoted.  If <code>FUN</code> is <code>NULL</code>, tapply
returns a vector which can be used to subscript the multi-way array
<code>tapply</code> normally produces.</p>
</td></tr>
<tr valign="top"><td><code>...</code></td>
<td>
<p>optional arguments to <code>FUN</code>: the Note section.</p>
</td></tr>
<tr valign="top"><td><code>simplify</code></td>
<td>
<p>If <code>FALSE</code>, <code>tapply</code> always returns an array
of mode <code>"list"</code>.  If <code>TRUE</code> (the default), then if
<code>FUN</code> always returns a scalar, <code>tapply</code> returns an array
with the mode of the scalar.</p>
</td></tr>
</table>


<h3>Value</h3>

<p>If <code>FUN</code> is not <code>NULL</code>, it is passed to
<code>match.fun</code>, and hence it can be a function or a symbol or
character string naming a function.
</p>
<p>When <code>FUN</code> is present, <code>tapply</code> calls <code>FUN</code> for each
cell that has any data in it.  If <code>FUN</code> returns a single atomic
value for each such cell (e.g., functions <code>mean</code> or <code>var</code>)
and when <code>simplify</code> is <code>TRUE</code>, <code>tapply</code> returns a
multi-way array containing the values, and <code>NA</code> for the
empty cells.  The array has the same number of dimensions as
<code>INDEX</code> has components; the number of levels in a dimension is
the number of levels (<code>nlevels()</code>) in the corresponding component
of <code>INDEX</code>.  Note that if the return value has a class (e.g., an
object of class <code>"Date"</code>) the class is discarded.
</p>
<p>Note that contrary to S, <code>simplify = TRUE</code> always returns an
array, possibly 1-dimensional.
</p>
<p>If <code>FUN</code> does not return a single atomic value, <code>tapply</code>
returns an array of mode <code>list</code> whose components are the
values of the individual calls to <code>FUN</code>, i.e., the result is a
list with a <code>dim</code> attribute.
</p>
<p>When there is an array answer, its <code>dimnames</code> are named by
the names of <code>INDEX</code> and are based on the levels of the grouping
factors (possibly after coercion).
</p>
<p>For a list result, the elements corresponding to empty cells are
<code>NULL</code>.
</p>


<h3>Note</h3>

<p>Optional arguments to <code>FUN</code> supplied by the <code>...</code> argument
are not divided into cells.  It is therefore inappropriate for
<code>FUN</code> to expect additional arguments with the same length as
<code>X</code>.
</p>


<h3>References</h3>

<p>Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988)
<EM>The New S Language</EM>.
Wadsworth &amp; Brooks/Cole.
</p>


<h3>See Also</h3>

<p>the convenience functions <code>by</code> and
<code>aggregate</code> (using <code>tapply</code>);
<code>apply</code>,
<code>lapply</code> with its versions
<code>sapply</code> and <code>mapply</code>.
</p>


<h3>Examples</h3>

<pre>
require(stats)
groups &lt;- as.factor(rbinom(32, n = 5, prob = 0.4))
tapply(groups, groups, length) #- is almost the same as
table(groups)

## contingency table from data.frame : array with named dimnames
tapply(warpbreaks$breaks, warpbreaks[,-1], sum)
tapply(warpbreaks$breaks, warpbreaks[, 3, drop = FALSE], sum)

n &lt;- 17; fac &lt;- factor(rep(1:3, length = n), levels = 1:5)
table(fac)
tapply(1:n, fac, sum)
tapply(1:n, fac, sum, simplify = FALSE)
tapply(1:n, fac, range)
tapply(1:n, fac, quantile)

## example of ... argument: find quarterly means
tapply(presidents, cycle(presidents), mean, na.rm = TRUE)

ind &lt;- list(c(1, 2, 2), c("A", "A", "B"))
table(ind)
tapply(1:3, ind) #-&gt; the split vector
tapply(1:3, ind, sum)
</pre>

<hr><div align="center">[Package <em>base</em> version 3.1.3 ]</div>




```R
str(1:3)                   # 1d vector
#>  int [1:3] 1 2 3
str(matrix(1:3, ncol = 1)) # column vector
#>  int [1:3, 1] 1 2 3
str(matrix(1:3, nrow = 1)) # row vector
#>  int [1, 1:3] 1 2 3
str(array(1:3, 3))         # "array" vector
#>  int [1:3(1d)] 1 2 3
```

     int [1:3] 1 2 3
     int [1:3, 1] 1 2 3
     int [1, 1:3] 1 2 3
     int [1:3(1d)] 1 2 3
    


```R
l <- list(1:3, "a", TRUE, 1.0)
dim(l) <- c(2, 2)
l
```




<table>
<tbody>
	<tr><td>1, 2, 3</td><td>TRUE</td></tr>
	<tr><td>a</td><td>1</td></tr>
</tbody>
</table>





```R
str(l)
```

    List of 4
     $ : int [1:3] 1 2 3
     $ : chr "a"
     $ : logi TRUE
     $ : num 1
     - attr(*, "dim")= int [1:2] 2 2
    

## Data frames
- A data frame is the most common way of storing data in R, and if used systematically makes data analysis easier. Under the hood, a data frame is a list of equal-length vectors. This makes it a 2-dimensional structure, so it shares properties of both the matrix and the list. This means that a data frame has names(), colnames(), and rownames(), although names() and colnames() are the same thing. The length() of a data frame is the length of the underlying list and so is the same as ncol(); nrow() gives the number of rows.

- As described in subsetting, you can subset a data frame like a 1d structure (where it behaves like a list), or a 2d structure (where it behaves like a matrix).



### Creation
- You create a data frame using data.frame(), which takes named vectors as input:


```R
df <- data.frame(x = 1:3, y = c("a", "b", "c"))
str(df)
```

    'data.frame':	3 obs. of  2 variables:
     $ x: int  1 2 3
     $ y: Factor w/ 3 levels "a","b","c": 1 2 3
    


```R
df <- data.frame(
  x = 1:3,
  y = c("a", "b", "c"),
  stringsAsFactors = FALSE)
str(df)
```

    'data.frame':	3 obs. of  2 variables:
     $ x: int  1 2 3
     $ y: chr  "a" "b" "c"
    

### Testing and coercion
- Because a data.frame is an S3 class, its type reflects the underlying vector used to build it: the list. To check if an object is a data frame, use class() or test explicitly with is.data.frame():

- R의 S3 클래스 = R에 영감을 준 S언어 버전 3에서 따왔음. S3 제네릭 함수, S4 클래스는 보안 기능을 추가하기 위해 나중에 개발되었음
- 제네릭 함수 (plot, print, summary처럼 다형성을 가짐. 동일 함수가 서로 다른 클래스에서 다른 연산을 수행)


```R
typeof(df)
#> [1] "list"
class(df)
#> [1] "data.frame"
is.data.frame(df)
```




"list"






"data.frame"






TRUE



- You can coerce an object to a data frame with as.data.frame():
- A vector will create a one-column data frame.
- A list will create one column for each element; it’s an error if they’re not all the same length.
- A matrix will create a data frame with the same number of columns and rows as the matrix.


```R
#Combining data frames
cbind(df, data.frame(z = 3:1))
#>   x y z
#> 1 1 a 3
#> 2 2 b 2
#> 3 3 c 1
```




<table>
<thead><tr><th></th><th scope=col>x</th><th scope=col>y</th><th scope=col>z</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>a</td><td>3</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>b</td><td>2</td></tr>
	<tr><th scope=row>3</th><td>3</td><td>c</td><td>1</td></tr>
</tbody>
</table>





```R
rbind(df, data.frame(x = 10, y = "z"))
```




<table>
<thead><tr><th></th><th scope=col>x</th><th scope=col>y</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>a</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>b</td></tr>
	<tr><th scope=row>3</th><td>3</td><td>c</td></tr>
	<tr><th scope=row>4</th><td>10</td><td>z</td></tr>
</tbody>
</table>




- When combining column-wise, the number of rows must match, but row names are ignored. When combining row-wise, both the number and names of columns must match. Use plyr::rbind.fill() to combine data frames that don’t have the same columns.

- It’s a common mistake to try and create a data frame by cbind()ing vectors together. This doesn’t work because cbind() will create a matrix unless one of the arguments is already a data frame. Instead use data.frame() directly:


```R
bad <- data.frame(cbind(a = 1:2, b = c("a", "b")))
str(bad)
```

    'data.frame':	2 obs. of  2 variables:
     $ a: Factor w/ 2 levels "1","2": 1 2
     $ b: Factor w/ 2 levels "a","b": 1 2
    


```R
good <- data.frame(a = 1:2, b = c("a", "b"),
  stringsAsFactors = FALSE)
str(good)
```

    'data.frame':	2 obs. of  2 variables:
     $ a: int  1 2
     $ b: chr  "a" "b"
    


```R
#Special columns
df <- data.frame(x = 1:3)
df$y <- list(1:2, 1:3, 1:4)
df
```




<table>
<thead><tr><th></th><th scope=col>x</th><th scope=col>y</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>1, 2</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>1, 2, 3</td></tr>
	<tr><th scope=row>3</th><td>3</td><td>1, 2, 3, 4</td></tr>
</tbody>
</table>





```R
data.frame(x = 1:3, y = list(1:2, 1:3, 1:4))
```


    Error in data.frame(1:2, 1:3, 1:4, check.names = FALSE, stringsAsFactors = TRUE): arguments imply differing number of rows: 2, 3, 4
    



```R
str(df)
```

    'data.frame':	3 obs. of  2 variables:
     $ x: int  1 2 3
     $ y:List of 3
      ..$ : int  1 2
      ..$ : int  1 2 3
      ..$ : int  1 2 3 4
    


```R

```
