# 의사결정트리

데이터들이 가진 속성들로부터 분할 기준 속성을 판별하고,

분할 기준 속성에 따라 트리 형태로 모델링하는 분류 예측 모델

- 의사결정트리와 회귀분석은 현업에서 고객들과 데이터 분석가들이 선호하는 머신러닝 알고리즘이다.

정확도 면에서는 신경망이 훨씬 훌륭하지만 신경망 내부가 블랙박스[보이지 않기]이기 때문에

고객들에게 설명하기 힘든 경우가 많다.

반면, 의사결정트리와 회귀분석은 설명이 잘 되기 때문에 선호되는 분류 모델이다.

# 의사결정트리를 만드는 원리

부모 마디의 순수도에 비해서 자식 마디들의 순수도가 증가하도록 자식 마디를 형성해 나가면서 만든다.

순수도 : 목표 변수의 특정 범주에 개체들이 포함되어 있는 정도

순수도가 높을수록 한 종류끼리 잘 모인 상태이다.

즉, 분류를 딱 시작한 순간의 부모 마디는 순수도가 상대적으로 낮을 수밖에 없고,

분류를 통해 종류별로 모이면서 순수도가 상승한다.

근데 분류를 할 때 가장 중요한 변수[컬럼]으로 나누고 또 그 다음으로 중요한 컬럼으로 나눠야 가장 성공적인 예측이 가능할 것이다.

예를 들어, 취업 성공 여부를 예측할 때

키, 몸무게 같은 변수 같은 덜 중요한 변수로 먼저 분류하고,

경력 같은 중요한 스펙으로 마지막에 분류를 하면, 제대로 예측이 이루어지지 않을 것이다.

이렇게 중요한 변수를 판단하는 기준을 정보획득량이라 하고,

순수도가 많이 상승하면 정보획득량도 높다할 수 있다.

# 화장품 구매 데이터 탐색

skin <- read.csv("skin.csv",  header=T, stringsAsFactors=T)
View(skin)

- 고객 ID, 성별, 나이, 직업, 결혼, 차 변수가 쿠폰 여부에 영향을 주는지 확인해보자.

install.packages("FSelector")
library(FSelector)

wg <- information.gain( cupon_react ~ . , skin,  unit='log2')
- 문법 :  information.gain( 라벨컬럼 ~ 모든컬럼, 데이터 프레임명, unit='log2') 
wg

확인 결과, 결혼 유무가 가장 정보획득량이 높은, 중요한 변수로 확인되었다.

즉, 의사결정트리를 만들 때 결혼 유무로 먼저 분류하는 것이 가장 이상적이다.

# 의사결정트리 실습 - 백화점 화장품 고객 중 구매가 예상되는 고객 예측

C50 패키지는 trials를 이용해서 바로 성능 개선을 할 수 있는게 장점이고
party 패키지는 의사결정트리를 시각화할 수 있는 장점이 있다. 

(1) C50 패키지 활용

1. 의사결정 패키지 C50 설치

install.packages("C50")
library(C50)

※ 의사결정나무 알고리즘 4가지

1. CART  :  나무의 분리기준은 지니지수

2. C4.5 와 C5.0 : 나무의 분리기준이 엔트로피 지수

3. CHAID :  나무의 분리기준이 카이제곱 통계량과 F검정

4. QUEST  : 나무의 분리기준이 카이제곱 통계량과 F검정 


2. 백화점 화장품 고객 데이터를 로드하고 shuffle

skin <- read.csv("skin.csv", header=T ,stringsAsFactors = TRUE)
nrow(skin)

skin_real_test_cust <- skin[30,  ]  # 테스트용으로 따로 분리
skin2 <-  skin[ 1:29, ]  # 29개의 데이터로 학습 시켜서 의사결정나무 생성할 예정
nrow(skin2)  #29
skin_real_test_cust

skin2 <- skin2[ , -1] # 고객번호를 제외시킨다. 

set.seed(20)
skin2_shuffle <- skin2[sample(nrow(skin2)),    ]  # shuffle 시킴 

3. 화장품 고객 데이터를 7대 3로 train 과 test 로 나눈다.

train_num <-  round(0.7 * nrow(skin2_shuffle), 0) 
skin2_train <- skin2_shuffle[1:train_num,  ]  
skin2_test  <- skin2_shuffle[(train_num+1) : nrow(skin2_shuffle), ] 

nrow(skin2_train)  # 20  훈련데이터는 20개이고 
nrow(skin2_test)   #  9   테스트 데이터는 9개이다. 

4. C50 패키지를 이용해서 분류 모델을 생성

library(C50)
skin_model <- C5.0(skin2_train[  , -6],  skin2_train$cupon_react )  
                            ↑                        ↑
                  라벨을 뺀 train 전체 data    train 데이터의 라벨 

skin_model 

Number of samples : 데이터의 수가 20개다. -> 아까 훈련 데이터를 20개로 만들었으니까

Number of predictors : 5개의 질문으로 분류했다

5. 위에서 만든 skin_model 를 이용해서 테스트 데이터의 라벨을 예측하기

skin2_result  <- predict( skin_model , skin2_test[  , -6])
                                          ↑
                            라벨을 뺀 테스트 데이터 전체 


6. 이원 교차표로 결과 확인

library(gmodels)
CrossTable( skin2_test[  , 6],  skin2_result ) 

- 문법 :  CrossTable( x=실제값, y= 예측값)

g4<-CrossTable( mushrooms_test[  ,1], result1) 

print(g4$prop.tb[1]+g4$prop.tb[4]) # 정확도 계산

7. 의사결정트리의 성능 높이기

knn 일때의 하이퍼 파라미터 - k 값 , seed값

naivebayes 일때 하이퍼 파라미터 - laplace 값, seed값

decision  tree 일때 하이퍼 파라미터 - trials 값 , seed값 

trials 파라미터로 나무의 개수를 정한다.

여러 개의 나무를 만들어서 그 나무들 중 가장 분류를 잘하는 나무를 선택한다. 

library(C50)
skin_model2 <- C5.0(skin2_train[  , -6],  skin2_train$cupon_react , trials=10)  # trials 추가
skin_result2  <- predict( skin_model2 , skin2_test[  , -6])

library(gmodels)
CrossTable( skin2_test[  , 6],  skin_result2 ) 
g5<-CrossTable( skin2_test[  , 6],  skin_result2 ) 
print(g5$prop.tb[1]+g5$prop.tb[4]) # 정확도 계산

정확도가 67%에서 78%로 상승했다!
  
(2) party 패키지 활용 - 아이리스 데이터를 통한 예측

1. party 패키지 로드

install.packages("party") # 의사결정트리 알고리즘이 구현된 패키지 
library(party) 

2. 아이리스 데이터 로드

data(iris)

3. 데이터 확인

nrow(iris) # 전체 행수 확인
summary(iris) # 데이터 통계정보 확인
table(iris$Species) # 데이터 라벨 컬럼의 종류와 건수 확인

4. sample 함수를 사용해서 shuffle 도 하면서 데이터를 7대 3으로 나누기

set.seed(11)
ind <- sample( 2 ,nrow(iris)   ,replace=T,  prob=c(0.7,0.3) )
숫자 2는 2개로 데이터를 나누겠다는 것
nrow(iris)는 데이터의 전체 행수
replace=T 로 복원추출
prob=c(0.7, 0.3) 으로 7대 3으로 나누겠다고 지정

ind==1과 ind==2 이렇게 두 가지로 나눴는데, 살펴보면 각각 TRUE와 FALSE가 반대이다.

5. 위에서 만든 ind==1 과 ind==2 를 이용해서 훈련 데이터와 테스트 데이터를 구성

traindata <- iris[ind==1, ]   # 70%에 해당하는 데이터를 traindata로 구성
testdata <- iris[ind==2,  ]   # 30%에 해당하는 데이터를 testdata로 구성

nrow(traindata)  # 120
nrow(testdata)   # 30

6. 의사결정트리 모델(나무)을 생성

myformula <- Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width
변수 <-  라벨컬럼 ~  독립변수 컬럼1 +독립변수 컬럼2 + 독립변수 컬럼3 + 독립변수 컬럼4 
또는
myfomula <- Species ~ .  으로 해도 된다. 

# iris_ctree <- ctree(종속변수 ~ 독립변수1+독립변수2, data=traindata) 
iris_ctree <- ctree(myformula, data=traindata)

- party 패키지의 ctree 함수를 이용해서 의사결정 모델을 생성

7. 모델이 예측한 결과 확인

predict(iris_ctree)

8. 예측결과와 실제 테스트 데이터의 정답과 비교

table(predict(iris_ctree), traindata$Species)

- 120개로 예측한 결과를 보니, 6개를 제외하고 전부 맞췄다.

9. 모델 내부의 질문이 어떻게 되는지 확인

iris_tree

10. 의사결정트리 모델 시각화

plot(iris_ctree)

plot(iris_ctree, type="simple")

11. 테스트 데이터 30개를 예측하고 잘 맞췄는지 확인

testpred <- predict(iris_ctree, newdata=testdata)

table(testpred,testdata$Species)

- 확인 결과 모두 맞췄다!
  
# 다시 한 번 정리
  
C50 패키지는 trials를 이용해서 바로 성능 개선을 할 수 있는게 장점이고
party 패키지는 의사결정트리를 시각화할 수 있는 장점이 있다!