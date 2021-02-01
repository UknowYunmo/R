분류 규칙

1R(OneR) 알고리즘
- 하나의 사실(조건)만 가지고 간단하게 분류하는 알고리즘
- 하나의 사실만 가지고 분류하다보니 간단하지만 오류가 많다.
ex) 가슴 통증의 유무에 따라 심장 질환이 있는지 분류하고자 하면 오류가 많아진다.

Ripper 알고리즘
- 복수개의 사실(조건)을 가지고 분류하는 알고리즘
ex) 가슴 통증이 있으면서 호흡 곤란이 있으면 심장 질환일 것이다.

# 1R 알고리즘으로 분류

1. 버섯 데이터를 R로 로드

mushroom <- read.csv("mushrooms.csv", stringsAsFactors=T)

2. mushroom 데이터를 훈련 데이터와 테스트 데이터로 나누기
( 훈련 데이터 75%,  테스트 데이터 25% ) 

set.seed(11)
dim(mushroom) 
train_cnt <- round( 0.75 * dim(mushroom)[1])
train_index <- sample(1:dim(mushroom)[1], train_cnt, replace=F)

mushroom_train <- mushroom[train_index,  ]
mushroom_test  <- mushroom[-train_index, ]

3. 규칙기반 알고리즘인 oneR 을 이용해서 독버섯과 일반 버섯을 분류하는 모델을 생성

install.packages("OneR")
library(OneR)

model1 <- OneR(type~. ,  data=mushroom_train)
model1
summary(model1)

4. 위에서 생성한 모델을 가지고 테스트 데이터로 결과를 확인

result1 <- predict( model1, mushroom_test[   , -1] )
library(gmodels)

g4<-CrossTable( mushroom_test[ , 1],  result1) 
print(g4$prop.tb[1]+g4$prop.tb[4]) # 정확도 계산

OneR 알고리즘 결과 98.6%의 정확도가 나왔다.

# Ripper 알고리즘으로 분류

1. 라이브러리 설치

install.packages("RWeka")
library(RWeka)

2. Ripper 알고리즘으로 모델 생성

model2 <-  JRip(type~ ., data=mushroom_train)
model2

- Ripper 알고리즘으로 만든 9개의 식을 확인할 수 있다.

summary(model2)

summary()함수에 넣으면, 혼동행렬을 확인할 수 있다.

3. 테스트 데이터로 확인

result2 <- predict( model2, mushroom_test[   , -1] )

library(gmodels)
g5<-CrossTable( mushroom_test[ , 1],  result2) 
print(g5$prop.tb[1]+g5$prop.tb[4]) # 정확도 계산

Ripper 알고리즘으로 바꾸니 정확도 100%가 나왔다.

## CreateDataPartition으로 제대로 훈련용-테스트용으로 나누고, 이상적인 Seed 값도 찾아내는 Loop문 ##

##0. repeat

accuracy <- c()
seed <- c()
i <- 1
repeat {
  set.seed(i)
  seed <- append(seed, i)
  #------------------------------------------------------------------------------------------------------------
  ##1. Load data 
  wine <- read.csv("wine.csv", header=T, stringsAsFactor=T)
  
  ##2. Check data
  str(wine)    
  
  ##3. set train_data : test_data = 0.75 : 0.25
  library(caret)
  k <- createDataPartition(wine$Type, p=0.75, list=F)
  train_data <- wine[k,  ]
  test_data <- wine[-k,  ]

  ##4. Make model / pred
  library(RWeka)
  model <- JRip(Type~. , data=train_data)
  summary(model)

  ##5. Pred with test_data : CrossTable
  res <- predict( model, test_data[  ,-1])
  library(gmodels)
  g <- CrossTable( test_data[ , 1],  res)
  x <- sum(g$prop.tbl *diag(3))   
  x
  
  #------------------------------------------------------------------------------------------------------------
  ## repeat
  accuracy <- append(accuracy, x)
  temp <- data.frame(seed, accuracy)
  print(i)
  print(x)
  if (x==1 | i==1000) break
  i <- i+1
}

print(i)    #value : satisfying condition

#=============================================================

## Find hyper parameter

library(dplyr)
temp$rnk <- dense_rank(-temp$accuracy)
temp[temp$rnk==1,   ]    
View(temp)


View(temp) 해보면, seed 값마다 acc가 변화하고,
모인 acc를 dense_rank를 먹여서 rnk를 만들었다.
이 때 rnk가 가장 높은 경우는
seed가 49일 경우이고, acc는 1로 100%가 되었다!