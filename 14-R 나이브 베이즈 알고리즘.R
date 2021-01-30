# 나이브 베이즈 알고리즘

나이브 베이즈 - 분류 - 지도 학습

# 활용 분야

1. 스팸 이메일 필터링과 같은 텍스트 분류
2. 컴퓨터 네트워크에서 침입이나 비정상적인 행위 탐지
3. 일련의 관찰된 증상에 따른 의학적 질병 진단

# 베이즈 분류

베이즈 이론을 이용해서 주어진 대상을 원하는 카테고리로 분류하는 방법

예제 : 비아그라가 포함되어져 있는 메일이 스팸 메일일 확률

                            우도           사전확률
                            ↓                ↓
                            p(비아그라 | 스팸) * p(스팸)

p( 스팸 | 비아그라 ) =---------------------------------------------
  ↑                                   p(비아그라)
사후확률


베이즈 이론을 적용해서 메세지가 스팸이 될 확률을 측정한 후

사후확률을 계산해서 50%보다 크다면 이 메세지는 햄보다는 스팸이 될 가능성이 좀 더 크다.

     빈도표                        ---->                우도표

    비아그라                                            비아그라
  
    예    아니요    총계                            예      아니요    총계

스팸 4      16         20                      스팸 4/20     16/20     20

햄   1      79         80                       햄  1/80     79/80     80

     5      95        100                           5/100   95/100   100


                                p(비아그라=예 | 스팸) * p(스팸)                4/20 * 20/100
p( 스팸 | 비아그라 ) =--------------------------------------------- = -------------------------- = 0.8
↑                                   p(비아그라)                                    5/100
사후확률

# 정상 버섯과 독버섯을 분류하는 나이브 베이즈 알고리즘

1. 버섯 데이터를 R 로 로드

mushroom <- read.csv("mushrooms.csv", header=T, stringsAsFactors=TRUE)

View(mushroom)

데이터를 살펴보니 knn은 전부 수치형 데이터였는데, 이번에는 전부 문자형 데이터이다.
이러면 knn은 사용할 수 없고, 나이브 베이즈로 분류를 해야한다.

table(mushroom$type) # 정답 컬럼
prop.table(table(mushroom$type))

두 개가 거의 절반이어서 정상 버섯과 독버섯을 잘 학습할 수 있는 좋은 자료라 할 수 있다.

2. 8123 독버섯 데이터만 따로 빼서 mush_test.csv 로 저장한다.

-> 학습 후 모델이 잘 맞추는지 확인하기 위함 

mush_test <- mushroom[8123, ]
mush_test 

write.csv( mush_test, "mush_test.csv",row.names=FALSE )

3. 8123 독버섯 데이터를 훈련 데이터에서 제외 시키시오 !
  
nrow(mushroom)

mushrooms <- mushroom[ -8123,  ] # 8123행 제외

nrow(mushrooms)

4. mushrooms 데이터를 훈련 데이터와 테스트 데이터로 나눈다 ( 훈련 데이터는 75%,  테스트 데이터는 25% )

set.seed(1)

dim(mushrooms) # 8123개의 행과, 23개의 열로 구성되어 있는 것을 확인

dim(mushrooms)[1] # 8123
dim(mushrooms)[2] # 23

train_cnt <- round( 0.75*dim(mushrooms)[1] ) # 총 8123건 중 75% 해당되는 데이터 위치(행)를 저장

train_cnt # 6092

train_index <- sample( 1:dim(mushrooms)[1], train_cnt, replace=F) # 1~6092 행 중 랜덤 추출, 'replace=F' : 비복원 추출

mushrooms_train <- mushrooms[ train_index,  ] # 훈련용 75%
mushrooms_test <- mushrooms[- train_index,  ] # 테스트용 25%

nrow(mushrooms_train)  #  6092
nrow(mushrooms_test)   #  2031 

str(mushrooms_train)

5. 나이브 베이즈 알고리즘으로 독버섯과 일반 버섯을 분류하는 모델을 생성한다.

install.packages("e1071")
library(e1071)       

                     모든 컬럼들
                          ↓
model1 <- naiveBayes(type~ . ,  data=mushrooms_train)  # 우도표를 작성
                      ↑
                  라벨 컬럼명 

model1

6. 위에서 만든 모델과 테스트 데이터를 가지고 독버섯과 일반버섯을 잘 분류하는지 예측해 본다.

result1 <- predict( model1, mushrooms_test[  , -1] )

result1

7. 이원 교차표를 그려서 최종 분류 결과를 확인한다. 

library(gmodels)

CrossTable( mushrooms_test[  ,1], result1) 
                  ↑                ↑
                 실제              예측 

g2<-CrossTable( mushrooms_test[  ,1], result1) 

print(g2$prop.tb[1]+g2$prop.tb[4]) # 정확도 계산

8. 위의 모델의 성능을 올리기 ( 라플라스 값 추가 )

model2 <- naiveBayes(type~ . ,  data=mushrooms_train, laplace=0.0004) # laplace -> 라플라스 값

** 라플라스 값은 데이터가 0인 경우 0대신 다른 값으로 대체해주어 성능을 높여준다.

result2 <- predict( model2, mushrooms_test[ , -1] )

CrossTable( mushrooms_test[ ,1], result2)

g3<-CrossTable( mushrooms_test[ ,1], result2)

print(g3$prop.tb[1]+g3$prop.tb[4]) # 정확도 계산

확인 결과 정확도가 95%였던 정확도가 99.7%까지 올랐다!
  
9. 2번 과정에서 따로 빼둔 8123의 데이터로 모델이 잘 예측하는지 확인

result3 <- predict( model2, mush_test[ ,-1] ) # 8123 데이터 예측

result3 # 예측

mush_test[,1] # 실제값

8123은 독성이었고, 모델도 독성이라고 잘 예측했다!