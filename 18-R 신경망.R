# 활성화 함수의 종류

1. 계단함수  : 입력신호의 총합이 임계치를 넘느냐 안넘느냐를 숫자 1과 0으로 리턴
2. 시그모이드 함수 : 계단함수는 무조건 0 아니면 1을 리턴하지만, 시그모이드는 0~1 사이의 연속적인 실수값을 리턴
3. 렐루 함수 : relu 함수
Rectified Linear unit

시그모이드 함수 때문에 나온 함수
시그모이드 함수의 단점이 전파가 역전파 될 때 기울기 소실로 인해
전파가 앞층까지 안된다는 단점이 있어서 나오게 된 함수

4. leaky relu 함수 : 렐루함수의 음수 부분의 기울기 0이어서 역전파할 때 기울기가 소실되므로 기울기를 0이 아니게 만들어주는 함수
5. tanh 함수

인공신경망의 기초가 된 알고리즘은 인공신경세포 하나를 컴퓨터로 구현한 퍼셉트론.
퍼셉트론에서 사용되는 활성화함수는 위와 같이 5가지 함수이다.

인공신경망의 학습 목표는 학습이 잘된 가중치를 생성하는 것

# 신경망 실습1 (콘크리트 강도를 예측하는 인공신경망)

" 콘크리트의 강도를 예측하는 신경망을 만드는 실습" 

자갈, 모래, 시멘트등을 몇대 몇 비율로 섞었을때 어느정도 강도가 나오는지 예측하는 신경망 

1.  콘크리트 데이터 소개 

* 콘크리트 데이터 

1. mount of cement: 콘크리트의 총량
2. slag  :  시멘트 
3. ash   :  분 (시멘트)
4. water :  물
5. superplasticizer :  고성능 감수재(콘크리트 강도를 높이는 첨가제)
6. coarse aggregate :  굵은 자갈
7. fine  aggregate :  잔 자갈
8. aging time  :  숙성시간 

2.  콘크리트 데이터를 R 로 로드한다.

-  머신러닝 데이터 116번 

concrete <- read.csv("concrete.csv")
str(concrete)
View(concrete)

3.  정규화 함수로 데이터를 정규화 작업

normalize <- function(x) {
  return ( (x-min(x)) / (max(x) - min(x) ) )
}

concrete_norm <- as.data.frame(lapply(concrete,normalize) ) 

4.  0~1사이로 데이터가 잘 변경되었는지 확인 

summary( concrete_norm$strength)

# 본래 데이터의 최소값, 최대값과 비교 

summary( concrete$strength)

5. 결측치 및 이상치 확인

(1) 결측치 확인

colSums(is.na(concrete))

(2) 이상치 확인

library(outliers)

grubbs.flag <- function(x) {
  outliers <- NULL
  test <- x
  grubbs.result <- grubbs.test(test)
  pv <- grubbs.result$p.value
  while(pv < 0.05) {
    outliers <- c(outliers,as.numeric(strsplit(grubbs.result$alternative," ")[[1]][3]))
    test <- x[!x %in% outliers]
    grubbs.result <- grubbs.test(test)
    pv <- grubbs.result$p.value
  }
return(data.frame(X=x,Outlier=(x %in% outliers)))
}

for (i in 1:length(colnames(concrete))){
  a = grubbs.flag(concrete[,colnames(concrete)[i]])
  b = a[a$Outlier==TRUE,"Outlier"]
  print ( paste( colnames(concrete)[i] , '--> ',  length(b) )  )
}

6.  훈련 데이터,테스트 데이터를 나눈다 (8:2)

concrete_train <- concrete_norm[1:773, ]
concrete_test  <- concrete_norm[774:1030, ]

7.  neuralnet 패키지를 설치한다.

install.packages("neuralnet")
library(neuralnet) 

8.  neuralnet 패키지에 콘크리트 훈련 데이터를 넣어서 모델을 생성한다.

concrete_model <- neuralnet(formula=strength ~ cement + slag + ash  +water +superplastic + coarseagg  + fineagg  + age, data =concrete_train) 

# neuralnet은 ~. 으로 한 번에 변수를 지정할 수 없고, 일일히 해줘야한다.  

9. 모델(신경망)을 시각화

plot(concrete_model )

10. 만든 모델로 테스트 데이터를 가지고 테스트 한다

model_results <-  compute(concrete_model, concrete_test[1:8])
predicted_strength <-  model_results$net.result

11.  예측값과 실제값간의 상관관계를 확인 

cor(predicted_strength, concrete_test$strength)

0.8062986

-> 예측 결과가 콘크리트 강도이기 때문에, 이원 교차표로 정확도를 확인해서

신경망 모델의 성능을 확인할 수는 없고, 이렇게 상관 관계를 구해서 성능을 확인해야 한다.

12. 모델의 성능 개선 

concrete_model2 <- neuralnet(formula=strength ~ cement + slag + ash  +
                               water +superplastic + coarseagg  + fineagg  + age, data =concrete_train , hidden=c(5,2) )  

# hidden=  c(5,   2) 
            ↑   ↑
은닉1층 5개  은닉2층 2개

plot(concrete_model2)

13. 위에서 만든 모델로 테스트를 수행한다. 

model_results <-  compute(concrete_model2, concrete_test[1:8])
predicted_strength2 <-  model_results$net.result

14.  예측값과 실제값간의 상관관계를 확인 

cor(predicted_strength2, concrete_test$strength)

0.931925 

-> 약 13% 상승했다.

15. 은닉층을 늘려 더 성능이 좋은 콘크리트 강도를 예측하는 신경망 생성

concrete_model3 <- neuralnet(formula=strength ~ cement + slag + ash  + water +superplastic + coarseagg  + fineagg  + age, data =concrete_train , hidden=c(7,4,4) )
model_results <-  compute(concrete_model3, concrete_test[1:8])
predicted_strength3 <-  model_results$net.result
cor(predicted_strength3, concrete_test$strength)