for (i in 1:10) {
  pred <- knn(train=Xsmall[-idx[[i]], ], 
              test = Xsmall[idx[[i]], ], 
              cl=y[-idx[[i]], ], 
              k=5)
  print(paste0(i, 
               " error rate: ", 
               round(mean(y[idx[[i]]] != pred)
                     )
               )
        ) 
}

set.seed(1)
ks <- 1:12
res <- sapply(ks, function(k))

library(genefilter)
idx <- createFolds(y, k=10)
m <- 8

for (i in 1:10) {
  pvals <- rowttests(t(X[-idx[[i]], ]), 
                   y[-idx[[i]]])$p.value
  
  ind <- order(pvals)[1:m]
  
  pred <- knn(train = X[-idx[[i]], ind],
              test = X[idx[[i]], ind],
              cl=y[-idx[[i]]],
              k=5)
  
  print(mean(pred != y[idx[[i]]]))
}
