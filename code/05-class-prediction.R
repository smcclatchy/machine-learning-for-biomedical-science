library(rafalib)
library(RColorBrewer)
hmcol <- colorRampPalette(rev(brewer.pal(11,  "Spectral")))(100)
mycols=c(hmcol[1], hmcol[100])

set.seed(1)
## create covariates and outcomes
## outcomes are always 50 0s and 50 1s
s2=0.15

## pick means to create a non linear conditional expectation
library(MASS)
M0 <- mvrnorm(10, c(1,0), s2*diag(2)) ## generate 10 means
M1 <- rbind(mvrnorm(3, c(1,1), s2*diag(2)),
            mvrnorm(3, c(0,1), s2*diag(2)),
            mvrnorm(4, c(0,0),s2*diag(2)))

### function to generate random pairs
s <- sqrt(1/5)
N=200
makeX <- function(M, n=N, sigma=s*diag(2)){
  z <- sample(1:10, n, replace=TRUE) ## pick n at random from above 10
  m <- M[z,] ## these are the n vectors (2 components)
  return(t(apply(m, 1, function(mu) mvrnorm(1, mu, sigma)))) ## the final values
}

### create the training set and the test set
x0 <- makeX(M0) ##the final values for y=0 (green)
testx0 <- makeX(M0)
x1 <- makeX(M1)
testx1 <- makeX(M1)
x <- rbind(x0, x1) ## one matrix with everything
test <- rbind(testx0, testx1)
y <- c(rep(0, N), rep(1, N)) # the outcomes
ytest <- c(rep(0, N), rep(1, N))
cols <- mycols[c(rep(1, N), rep(2, N))]
colstest <- cols

## Create a grid so we can predict all of X,Y
GS <- 150 ## grid size is GS x GS
XLIM <- c(min(c(x[,1], test[,1])), max(c(x[,1], test[,1])))
tmpx <- seq(XLIM[1], XLIM[2], len=GS)
YLIM <- c(min(c(x[,2], test[,2])), max(c(x[,2], test[,2])))
tmpy <- seq(YLIM[1], YLIM[2], len=GS)
newx <- expand.grid(tmpx, tmpy) #grid used to show color contour of predictions

### Bayes rule: best possible answer
p <- function(x){ ##probability of Y given X
  p0 <- mean(dnorm(x[1], M0[,1], s) * dnorm(x[2], M0[,2], s))
  p1 <- mean(dnorm(x[1], M1[,1], s) * dnorm(x[2], M1[,2], s))
  p1/(p0+p1)
}

### Create the bayesrule prediction
bayesrule <- apply(newx, 1, p)
colshat <- bayesrule

colshat <- hmcol[floor(bayesrule * 100) + 1]

mypar()
plot(x, type="n", xlab="X1", ylab="X2", xlim=XLIM, ylim=YLIM)
points(newx, col=colshat, pch=16, cex=0.35)


# train and test datasets
dim(x)
View(x)

dim(test)
View(test)

mypar(1, 2)
plot(x, pch=21, bg=cols, xlab="X1", ylab="X2", xlim=XLIM, ylim = YLIM)
plot(x, pch=21, bg=colstest, xlab="X1", ylab="X2", xlim=XLIM, ylim = YLIM)

X1 <- x[,1]
X2 <- x[,2]

fit1 <- lm(y ~ X1 + X2)
summary(fit1)

yhat <- predict(fit1)
yhat <- as.numeric(yhat > 0.5)

# prediction error
1 - mean(yhat ==y)
cat("Linear regression prediction error in train:", 1-mean(yhat==y), "\n")

yhat <- predict(fit1, newdata = data.frame(X1=newx[,1], X2=newx[,2]))
yhat

colshat <- yhat
colshat[yhat >= 0.5] <- mycols[2]
colshat[yhat < 0.5] <- mycols[1]

m <- fit1$coefficients[2]/fit1$coefficients[3]
b <- (0.5 -fit1$coefficients[1])/fit1$coefficients[3]

yhat <- predict(fit1, newdata = data.frame(X1=test[,1], X2=test[,2]))
yhat <- as.numeric(yhat > 0.5)
cat("linear regression prediction error in test:", 1-mean(yhat==ytest), "\n")
plot(test, type="n", xlab="X1", ylab="X2", xlim = XLIM, ylim = YLIM)
abline(b,m)
points(newx, col=colshat, pch = 16, cex=0.35)
points(test,bg=cols,pch=21)

library(class)
mypar(2,2)

for(k in c(1, 100)) {
  yhat <- knn(train = x, 
              test = x,
              y, 
              k = k)
 cat("KNN prediction error in train:",
     1 - mean((as.numeric(yhat) - 1) == y),
     "\n")  
 yhat <- knn(train = x, 
             test = test, 
             y, 
             k == k)
 cat("KNN prediction error in test:",
     1 - mean((as.numeric(yhat) - 1) == ytest), 
     "\n")
}
 
 
 
 