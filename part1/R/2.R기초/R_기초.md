
# 2015-11-07 토요일 R기초 이상열  
## R맛보기 및 코드설명

### 1) R맛보기


```R
x <- 2*3
```


```R
x
```




6




```R
myvector <- c(8,6,9,10,5)
```


```R
myvector
```




<ol class=list-inline>
	<li>8</li>
	<li>6</li>
	<li>9</li>
	<li>10</li>
	<li>5</li>
</ol>





```R
myvector[4]
```




10




```R
mylist <- list(name="Fred", wife="Mary", myvector)
```


```R
mylist
```




<dl>
	<dt>$name</dt>
		<dd>"Fred"</dd>
	<dt>$wife</dt>
		<dd>"Mary"</dd>
	<dt>[[3]]</dt>
		<dd><ol class=list-inline>
	<li>8</li>
	<li>6</li>
	<li>9</li>
	<li>10</li>
	<li>5</li>
</ol>
</dd>
</dl>





```R
mynames <- c("mary", "john", "ahn", "sinead", "joe", "mary", "jim", "john", "simon")
```


```R
table(mynames)
```




    mynames
       ahn    jim    joe   john   mary  simon sinead 
         1      1      1      2      2      1      1 




```R
mytable <- table(mynames)
```


```R
mytable[[4]]
```




2




```R
log10(100)
```




2




```R
mean(myvector)
```




7.6




```R
myfunction <- function(x) {
    return(20 + (x*x))
}
```


```R
myfunction(10)
```




120




```R
myfunction(25)
```




645




```R
myFamilyNames <- c("Dad", "Mom", "Sis", "Bro", "Dog")
```


```R
myFamilyNames
```




<ol class=list-inline>
	<li>"Dad"</li>
	<li>"Mom"</li>
	<li>"Sis"</li>
	<li>"Bro"</li>
	<li>"Dog"</li>
</ol>





```R
myFamilyAges <- c(43,42,12,8,5)
```


```R
myFamilyAges
```




<ol class=list-inline>
	<li>43</li>
	<li>42</li>
	<li>12</li>
	<li>8</li>
	<li>5</li>
</ol>





```R
myFamilyGenders <- c("Male", "Female", "Female", "Male", "Female")
```


```R
myFamilyWeights <- c(188,136,83,61,44)
```


```R
myFamily <- data.frame(myFamilyNames, myFamilyAges, myFamilyGenders, myFamilyWeights)
```


```R
myFamily
```




<table>
<thead><tr><th></th><th scope=col>myFamilyNames</th><th scope=col>myFamilyAges</th><th scope=col>myFamilyGenders</th><th scope=col>myFamilyWeights</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>Dad</td><td>43</td><td>Male</td><td>188</td></tr>
	<tr><th scope=row>2</th><td>Mom</td><td>42</td><td>Female</td><td>136</td></tr>
	<tr><th scope=row>3</th><td>Sis</td><td>12</td><td>Female</td><td>83</td></tr>
	<tr><th scope=row>4</th><td>Bro</td><td>8</td><td>Male</td><td>61</td></tr>
	<tr><th scope=row>5</th><td>Dog</td><td>5</td><td>Female</td><td>44</td></tr>
</tbody>
</table>





```R
str(myFamily)
```

    'data.frame':	5 obs. of  4 variables:
     $ myFamilyNames  : Factor w/ 5 levels "Bro","Dad","Dog",..: 2 4 5 1 3
     $ myFamilyAges   : num  43 42 12 8 5
     $ myFamilyGenders: Factor w/ 2 levels "Female","Male": 2 1 1 2 1
     $ myFamilyWeights: num  188 136 83 61 44
    


```R
class(myFamilyGenders)
```




"character"




```R
myFamilyStr <- data.frame(myFamilyNames, myFamilyAges, myFamilyGenders, myFamilyWeights, stringsAsFactors=FALSE)
```


```R
str(myFamilyStr)
```

    'data.frame':	5 obs. of  4 variables:
     $ myFamilyNames  : chr  "Dad" "Mom" "Sis" "Bro" ...
     $ myFamilyAges   : num  43 42 12 8 5
     $ myFamilyGenders: chr  "Male" "Female" "Female" "Male" ...
     $ myFamilyWeights: num  188 136 83 61 44
    


```R
summary(myFamily)
```




     myFamilyNames  myFamilyAges myFamilyGenders myFamilyWeights
     Bro:1         Min.   : 5    Female:3        Min.   : 44.0  
     Dad:1         1st Qu.: 8    Male  :2        1st Qu.: 61.0  
     Dog:1         Median :12                    Median : 83.0  
     Mom:1         Mean   :22                    Mean   :102.4  
     Sis:1         3rd Qu.:42                    3rd Qu.:136.0  
                   Max.   :43                    Max.   :188.0  




```R
myFamily$myFamilyAges
```




<ol class=list-inline>
	<li>43</li>
	<li>42</li>
	<li>12</li>
	<li>8</li>
	<li>5</li>
</ol>





```R
myFamily[2,]
```




<table>
<thead><tr><th></th><th scope=col>myFamilyNames</th><th scope=col>myFamilyAges</th><th scope=col>myFamilyGenders</th><th scope=col>myFamilyWeights</th></tr></thead>
<tbody>
	<tr><th scope=row>2</th><td>Mom</td><td>42</td><td>Female</td><td>136</td></tr>
</tbody>
</table>





```R
myFamilyAges <- c(myFamilyAges, 11)
```


```R
myFamilyAges
```




<ol class=list-inline>
	<li>43</li>
	<li>42</li>
	<li>12</li>
	<li>8</li>
	<li>5</li>
	<li>11</li>
</ol>





```R
myFamily$myFamilyAges
```




<ol class=list-inline>
	<li>43</li>
	<li>42</li>
	<li>12</li>
	<li>8</li>
	<li>5</li>
</ol>





```R
head(iris)
```




<table>
<thead><tr><th></th><th scope=col>Sepal.Length</th><th scope=col>Sepal.Width</th><th scope=col>Petal.Length</th><th scope=col>Petal.Width</th><th scope=col>Species</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>5.1</td><td>3.5</td><td>1.4</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>2</th><td>4.9</td><td>3</td><td>1.4</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>3</th><td>4.7</td><td>3.2</td><td>1.3</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>4</th><td>4.6</td><td>3.1</td><td>1.5</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>5</th><td>5</td><td>3.6</td><td>1.4</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>6</th><td>5.4</td><td>3.9</td><td>1.7</td><td>0.4</td><td>setosa</td></tr>
</tbody>
</table>





```R
str(iris)
```

    'data.frame':	150 obs. of  5 variables:
     $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
     $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
     $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
     $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
     $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
    


```R
apply(iris[,1:4], 2, sum)
```




<dl class=dl-horizontal>
	<dt>Sepal.Length</dt>
		<dd>876.5</dd>
	<dt>Sepal.Width</dt>
		<dd>458.6</dd>
	<dt>Petal.Length</dt>
		<dd>563.7</dd>
	<dt>Petal.Width</dt>
		<dd>179.9</dd>
</dl>





```R
lapply(iris[,1:4], mean)
```




<dl>
	<dt>$Sepal.Length</dt>
		<dd>5.84333333333333</dd>
	<dt>$Sepal.Width</dt>
		<dd>3.05733333333333</dd>
	<dt>$Petal.Length</dt>
		<dd>3.758</dd>
	<dt>$Petal.Width</dt>
		<dd>1.19933333333333</dd>
</dl>





```R
sapply(iris[,1:4], mean) #vector or matrix
```




<dl class=dl-horizontal>
	<dt>Sepal.Length</dt>
		<dd>5.84333333333333</dd>
	<dt>Sepal.Width</dt>
		<dd>3.05733333333333</dd>
	<dt>Petal.Length</dt>
		<dd>3.758</dd>
	<dt>Petal.Width</dt>
		<dd>1.19933333333333</dd>
</dl>





```R
levels(iris$Species)
```




<ol class=list-inline>
	<li>"setosa"</li>
	<li>"versicolor"</li>
	<li>"virginica"</li>
</ol>





```R
tapply(iris$Sepal.Length, iris$Species, mean)
```




<dl class=dl-horizontal>
	<dt>setosa</dt>
		<dd>5.006</dd>
	<dt>versicolor</dt>
		<dd>5.936</dd>
	<dt>virginica</dt>
		<dd>6.588</dd>
</dl>





```R
byspecies <- split(iris, iris$Species)
```


```R
str(byspecies)
```

    List of 3
     $ setosa    :'data.frame':	50 obs. of  5 variables:
      ..$ Sepal.Length: num [1:50] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
      ..$ Sepal.Width : num [1:50] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
      ..$ Petal.Length: num [1:50] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
      ..$ Petal.Width : num [1:50] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
      ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
     $ versicolor:'data.frame':	50 obs. of  5 variables:
      ..$ Sepal.Length: num [1:50] 7 6.4 6.9 5.5 6.5 5.7 6.3 4.9 6.6 5.2 ...
      ..$ Sepal.Width : num [1:50] 3.2 3.2 3.1 2.3 2.8 2.8 3.3 2.4 2.9 2.7 ...
      ..$ Petal.Length: num [1:50] 4.7 4.5 4.9 4 4.6 4.5 4.7 3.3 4.6 3.9 ...
      ..$ Petal.Width : num [1:50] 1.4 1.5 1.5 1.3 1.5 1.3 1.6 1 1.3 1.4 ...
      ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 2 2 2 2 2 2 2 2 2 2 ...
     $ virginica :'data.frame':	50 obs. of  5 variables:
      ..$ Sepal.Length: num [1:50] 6.3 5.8 7.1 6.3 6.5 7.6 4.9 7.3 6.7 7.2 ...
      ..$ Sepal.Width : num [1:50] 3.3 2.7 3 2.9 3 3 2.5 2.9 2.5 3.6 ...
      ..$ Petal.Length: num [1:50] 6 5.1 5.9 5.6 5.8 6.6 4.5 6.3 5.8 6.1 ...
      ..$ Petal.Width : num [1:50] 2.5 1.9 2.1 1.8 2.2 2.1 1.7 1.8 1.8 2.5 ...
      ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 3 3 3 3 3 3 3 3 3 3 ...
    


```R
setosa <- subset(iris, Species="setosa")
```


```R
head(setosa)
```




<table>
<thead><tr><th></th><th scope=col>Sepal.Length</th><th scope=col>Sepal.Width</th><th scope=col>Petal.Length</th><th scope=col>Petal.Width</th><th scope=col>Species</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>5.1</td><td>3.5</td><td>1.4</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>2</th><td>4.9</td><td>3</td><td>1.4</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>3</th><td>4.7</td><td>3.2</td><td>1.3</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>4</th><td>4.6</td><td>3.1</td><td>1.5</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>5</th><td>5</td><td>3.6</td><td>1.4</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>6</th><td>5.4</td><td>3.9</td><td>1.7</td><td>0.4</td><td>setosa</td></tr>
</tbody>
</table>





```R
colsel <- subset(iris, select=c(Sepal.Length, Species))
```


```R
head(colsel)
```




<table>
<thead><tr><th></th><th scope=col>Sepal.Length</th><th scope=col>Species</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>5.1</td><td>setosa</td></tr>
	<tr><th scope=row>2</th><td>4.9</td><td>setosa</td></tr>
	<tr><th scope=row>3</th><td>4.7</td><td>setosa</td></tr>
	<tr><th scope=row>4</th><td>4.6</td><td>setosa</td></tr>
	<tr><th scope=row>5</th><td>5</td><td>setosa</td></tr>
	<tr><th scope=row>6</th><td>5.4</td><td>setosa</td></tr>
</tbody>
</table>





```R
colsel <- subset(iris, select=-c(Sepal.Length, Species))
```


```R
head(colsel)
```




<table>
<thead><tr><th></th><th scope=col>Sepal.Width</th><th scope=col>Petal.Length</th><th scope=col>Petal.Width</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>3.5</td><td>1.4</td><td>0.2</td></tr>
	<tr><th scope=row>2</th><td>3</td><td>1.4</td><td>0.2</td></tr>
	<tr><th scope=row>3</th><td>3.2</td><td>1.3</td><td>0.2</td></tr>
	<tr><th scope=row>4</th><td>3.1</td><td>1.5</td><td>0.2</td></tr>
	<tr><th scope=row>5</th><td>3.6</td><td>1.4</td><td>0.2</td></tr>
	<tr><th scope=row>6</th><td>3.9</td><td>1.7</td><td>0.4</td></tr>
</tbody>
</table>





```R
x <- c(20,11,33,50,47)
```


```R
sort(x)
```




<ol class=list-inline>
	<li>11</li>
	<li>20</li>
	<li>33</li>
	<li>47</li>
	<li>50</li>
</ol>





```R
order(x)
```




<ol class=list-inline>
	<li>2</li>
	<li>1</li>
	<li>3</li>
	<li>5</li>
	<li>4</li>
</ol>





```R
x[order(x)]
```




<ol class=list-inline>
	<li>11</li>
	<li>20</li>
	<li>33</li>
	<li>47</li>
	<li>50</li>
</ol>





```R
iris.ordered <- iris[order(iris$Sepal.Length), ]
```


```R
head(iris.ordered)
```




<table>
<thead><tr><th></th><th scope=col>Sepal.Length</th><th scope=col>Sepal.Width</th><th scope=col>Petal.Length</th><th scope=col>Petal.Width</th><th scope=col>Species</th></tr></thead>
<tbody>
	<tr><th scope=row>14</th><td>4.3</td><td>3</td><td>1.1</td><td>0.1</td><td>setosa</td></tr>
	<tr><th scope=row>9</th><td>4.4</td><td>2.9</td><td>1.4</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>39</th><td>4.4</td><td>3</td><td>1.3</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>43</th><td>4.4</td><td>3.2</td><td>1.3</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>42</th><td>4.5</td><td>2.3</td><td>1.3</td><td>0.3</td><td>setosa</td></tr>
	<tr><th scope=row>4</th><td>4.6</td><td>3.1</td><td>1.5</td><td>0.2</td><td>setosa</td></tr>
</tbody>
</table>





```R
head(iris[order(iris$Sepal.Length, iris$Petal.Length),])
```




<table>
<thead><tr><th></th><th scope=col>Sepal.Length</th><th scope=col>Sepal.Width</th><th scope=col>Petal.Length</th><th scope=col>Petal.Width</th><th scope=col>Species</th></tr></thead>
<tbody>
	<tr><th scope=row>14</th><td>4.3</td><td>3</td><td>1.1</td><td>0.1</td><td>setosa</td></tr>
	<tr><th scope=row>39</th><td>4.4</td><td>3</td><td>1.3</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>43</th><td>4.4</td><td>3.2</td><td>1.3</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>9</th><td>4.4</td><td>2.9</td><td>1.4</td><td>0.2</td><td>setosa</td></tr>
	<tr><th scope=row>42</th><td>4.5</td><td>2.3</td><td>1.3</td><td>0.3</td><td>setosa</td></tr>
	<tr><th scope=row>23</th><td>4.6</td><td>3.6</td><td>1</td><td>0.2</td><td>setosa</td></tr>
</tbody>
</table>





```R
sample(1:10,5)
```




<ol class=list-inline>
	<li>9</li>
	<li>4</li>
	<li>8</li>
	<li>5</li>
	<li>6</li>
</ol>





```R
sample(1:10, 5, replace=T)
```




<ol class=list-inline>
	<li>10</li>
	<li>10</li>
	<li>9</li>
	<li>1</li>
	<li>5</li>
</ol>





```R
aggregate(Sepal.Width~ Species, iris, mean)
```




<table>
<thead><tr><th></th><th scope=col>Species</th><th scope=col>Sepal.Width</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>setosa</td><td>3.428</td></tr>
	<tr><th scope=row>2</th><td>versicolor</td><td>2.77</td></tr>
	<tr><th scope=row>3</th><td>virginica</td><td>2.974</td></tr>
</tbody>
</table>




### 2) Bellman Equation 코드


```R
x <- 1:4
y <- 1:3
```


```R
rewards <- matrix(rep(0, 12), nrow=3)
```


```R
rewards
```




<table>
<tbody>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
</tbody>
</table>





```R
rewards[2, 2] <- NA
rewards[1, 4] <- 1
rewards[2, 4] <- -1
rewards
```




<table>
<tbody>
	<tr><td>0</td><td>0</td><td>0</td><td>1</td></tr>
	<tr><td> 0</td><td>NA</td><td> 0</td><td>-1</td></tr>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
</tbody>
</table>





```R
values <- rewards # initial values
```


```R
values
states <- expand.grid(x=x, y=y)
states
```




<table>
<tbody>
	<tr><td>0</td><td>0</td><td>0</td><td>1</td></tr>
	<tr><td> 0</td><td>NA</td><td> 0</td><td>-1</td></tr>
	<tr><td>0</td><td>0</td><td>0</td><td>0</td></tr>
</tbody>
</table>







<table>
<thead><tr><th></th><th scope=col>x</th><th scope=col>y</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>1</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>1</td></tr>
	<tr><th scope=row>3</th><td>3</td><td>1</td></tr>
	<tr><th scope=row>4</th><td>4</td><td>1</td></tr>
	<tr><th scope=row>5</th><td>1</td><td>2</td></tr>
	<tr><th scope=row>6</th><td>2</td><td>2</td></tr>
	<tr><th scope=row>7</th><td>3</td><td>2</td></tr>
	<tr><th scope=row>8</th><td>4</td><td>2</td></tr>
	<tr><th scope=row>9</th><td>1</td><td>3</td></tr>
	<tr><th scope=row>10</th><td>2</td><td>3</td></tr>
	<tr><th scope=row>11</th><td>3</td><td>3</td></tr>
	<tr><th scope=row>12</th><td>4</td><td>3</td></tr>
</tbody>
</table>





```R
# Transition probability
transition <- list("N" = c("N" = 0.8, "S" = 0, "E" = 0.1, "W" = 0.1), 
                   "S"= c("S" = 0.8, "N" = 0, "E" = 0.1, "W" = 0.1),
                   "E"= c("E" = 0.8, "W" = 0, "S" = 0.1, "N" = 0.1),
                   "W"= c("W" = 0.8, "E" = 0, "S" = 0.1, "N" = 0.1))
```


```R
transition
```




<dl>
	<dt>$N</dt>
		<dd><dl class=dl-horizontal>
	<dt>N</dt>
		<dd>0.8</dd>
	<dt>S</dt>
		<dd>0</dd>
	<dt>E</dt>
		<dd>0.1</dd>
	<dt>W</dt>
		<dd>0.1</dd>
</dl>
</dd>
	<dt>$S</dt>
		<dd><dl class=dl-horizontal>
	<dt>S</dt>
		<dd>0.8</dd>
	<dt>N</dt>
		<dd>0</dd>
	<dt>E</dt>
		<dd>0.1</dd>
	<dt>W</dt>
		<dd>0.1</dd>
</dl>
</dd>
	<dt>$E</dt>
		<dd><dl class=dl-horizontal>
	<dt>E</dt>
		<dd>0.8</dd>
	<dt>W</dt>
		<dd>0</dd>
	<dt>S</dt>
		<dd>0.1</dd>
	<dt>N</dt>
		<dd>0.1</dd>
</dl>
</dd>
	<dt>$W</dt>
		<dd><dl class=dl-horizontal>
	<dt>W</dt>
		<dd>0.8</dd>
	<dt>E</dt>
		<dd>0</dd>
	<dt>S</dt>
		<dd>0.1</dd>
	<dt>N</dt>
		<dd>0.1</dd>
</dl>
</dd>
</dl>





```R
# The value of an action (e.g. move north means y + 1)
action.values <- list("N" = c("x" = 0, "y" = 1), 
                      "S" = c("x" = 0, "y" = -1),
                      "E" = c("x" = -1, "y" = 0),
                      "W" = c("x" = 1, "y" = 0))
```


```R
action.values
```




<dl>
	<dt>$N</dt>
		<dd><dl class=dl-horizontal>
	<dt>x</dt>
		<dd>0</dd>
	<dt>y</dt>
		<dd>1</dd>
</dl>
</dd>
	<dt>$S</dt>
		<dd><dl class=dl-horizontal>
	<dt>x</dt>
		<dd>0</dd>
	<dt>y</dt>
		<dd>-1</dd>
</dl>
</dd>
	<dt>$E</dt>
		<dd><dl class=dl-horizontal>
	<dt>x</dt>
		<dd>-1</dd>
	<dt>y</dt>
		<dd>0</dd>
</dl>
</dd>
	<dt>$W</dt>
		<dd><dl class=dl-horizontal>
	<dt>x</dt>
		<dd>1</dd>
	<dt>y</dt>
		<dd>0</dd>
</dl>
</dd>
</dl>





```R
# act() function serves to move the robot through states based on an action
act <- function(action, state) {
  action.value <- action.values[[action]]
  new.state <- state
  #
  if(state["x"] == 4 && state["y"] == 1 || (state["x"] == 4 && state["y"] == 2))
    return(state)
  #
  new.x = state["x"] + action.value["x"]
  new.y = state["y"] + action.value["y"]
  # Constrained by edge of grid
  new.state["x"] <- min(x[length(x)], max(x[1], new.x))
  new.state["y"] <- min(y[length(y)], max(y[1], new.y))
  #
  if(is.na(rewards[new.state["y"], new.state["x"]]))
    new.state <- state
  #
  return(new.state)
}
```


```R
bellman.update <- function(action, state, values, gamma=1) {
  state.transition.prob <- transition[[action]]
  q <- rep(0, length(state.transition.prob))
  for(i in 1:length(state.transition.prob)) {        
    new.state <- act(names(state.transition.prob)[i], state) 
    q[i] <- (state.transition.prob[i] * (rewards[state["y"], state["x"]] + (gamma * values[new.state["y"], new.state["x"]])))
  }
  sum(q)
}
```


```R
value.iteration <- function(states, actions, rewards, values, gamma, niter) {
  for (j in 1:niter) {
    for (i in 1:nrow(states)) {
      state <- unlist(states[i,])
      if(i %in% c(4, 8)) next # terminal states
      q.values <- as.numeric(lapply(actions, bellman.update, state=state, values=values, gamma=gamma))
      values[state["y"], state["x"]] <- max(q.values)
    }
  }
  return(values)
}
```


```R
final.values <- value.iteration(states=states, actions=actions, rewards=rewards, values=values, gamma=0.99, niter=100)
```


```R
final.values
```




<table>
<tbody>
	<tr><td>0.9516605</td><td>0.9651596</td><td>0.9773460</td><td>1.0000000</td></tr>
	<tr><td> 0.9397944</td><td>        NA</td><td> 0.8948359</td><td>-1.0000000</td></tr>
	<tr><td>0.9266500</td><td>0.9150957</td><td>0.9027132</td><td>0.8198900</td></tr>
</tbody>
</table>



