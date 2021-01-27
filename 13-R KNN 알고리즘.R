# KNN 알고리즘

- k nearest neighbor의 약자로, k개의 최근접 이웃이라는 뜻.
- 머신러닝 지도학습의 분류에 해당

새로 들어온 데이터가 기존 데이터의 그룹에서 어느 그룹에 속하는지 찾을 때

거리가 제일 가까운 데이터의 그룹을 자기 그룹으로 선택하는 알고리즘

- 장점 : 단순하고 효율적, 모델을 훈련시키지 않아도 됨

- 단점 : 모델을 생성하지 않기 때문에 특징과 클래스 간의 관계를 이해하는 능력이 제한됨

적절한 k 값을 모델 개발자가 직접 알아내야 함

# KNN의 원리

새로 들어온 데이터가 기존 데이터 중에서 ( 악성종양, 양성종양 )

어느 데이터에 더 인접해 있는지 거리를 계산해서

가장 가까운 거리[유클리드 거리]에 있는 데이터를 자기 이웃으로 선택

# 군집 간의 거리 계산

연속형 변수의 거리 계산

1. 수학적 거리 : 유클리드 거리, 맨허튼 거리, 민코프스키 거리

2. 통계적 거리 : 표준화 거리, 마할라노비스 거리

# 유클리드 거리 공식을 R로 계산

1. 두 점의 좌표를 지정

a=c(2,4)
b=c(5,6)

2. 두 점 사이의 거리를 계산

sqrt(sum((a-b)^2)) # 13의 제곱근, 3.60551

3. 위 계산을 함수로 만들기

a=c(2,4)
b=c(5,6)
distance<-function(a,b) {
  return (sqrt(sum((a-b)^2)))
}

distance(a,b) # 3.60551

4. 함수를 이용하여 한꺼번에 유클리드 거리 계산

a1=c(1,5)와 c(4,4)와의 거리
a2=c(2,6)와 c(4,4)와의 거리
a3=c(4,5)와 c(4,4)와의 거리
a4=c(5,2)와 c(4,4)와의 거리
a5=c(6,3)와 c(4,4)와의 거리
a6=c(1,7)와 c(4,4)와의 거리

x=c(1,2,4,5,6,1)
y=c(5,6,5,2,3,7)

temp<-c() # 거리를 담을 변수

for (i in 1:6) {
  temp<-append(temp,distance(c(x[i],y[i]),c(4,4)))
}
temp


# 토마토와 가장 가까운 거리에 있는 음식 종류가 무엇인지 출력

fruits<-data.frame(
  '재료'=c('사과','베이컨','바나나','당근','셀러리','치즈'),
  '단맛'=c(10,1,10,7,3,1),
  '아삭한맛'=c(9,4,1,10,10,1),
  '음식종류'=c('과일','단백질','과일','채소','채소','단백질') )

View(fruits)

토마토=c(6,4) # 토마토의 성질 (단맛, 아삭한 맛)

# 이제 토마토 성질을 넣고 각 재료와의 거리를 계산해준다.

토마토=c(6,4)
temp<-c()
for (i in 1:6) {
  temp<-append(temp,distance(c(fruits$단맛[i],fruits$아삭한맛[i]),토마토))
}

temp

이 결과를 아까 만든 fruits 데이터 프레임에 dist 라는 변수로 추가해서 확인하자

fruits$dist<-temp
View(fruits)

이제 dist 변수의 순위를 파생변수로 또 하나 만들자

library(dplyr)
fruits$rnk<-dense_rank(fruits$dist)
View(fruits)

위의 결과에서 3위까지만 출력하면,

fruits[ fruits$rnk<=3,'음식종류']

여기서 최빈값은,

a<-fruits[ fruits$rnk<=3,'음식종류']

table(a)[table(a)==max(table(a))]

그럼 토마토는 단백질이라는 결론이 나오게 된다.

물론 토마토가 단백질일리는 없지만,, 데이터를 임의로 막 넣어서 나온 결과이고,

마지막의 rnk<=3에서, 이 3이 knn의 k의 개수를 의미한다.

k가 너무 적으면, 과대적합이 일어나 새로운 결과를 얻기 힘들고,

k가 너무 크면, 과소적합이 일어나 분류를 제대로 하지 못하게 되니, 적절한 k를 찾는 것이 중요하다.


그럼 느낌을 대충 알았으니 이제 knn 알고리즘으로 유방암 데이터를 악성과 양성을 분류해보자.

유방암 진단 과정

1. 데이터 수집

2. 데이터 탐색, 준비 --> 결측치, 이상치, 정규분포(히스토그램) 확인, 학습시키기 적합한 데이터 형태인지 확인

3. 데이터로 모델 훈련 ---> knn 알고리즘 ( knn은 정확히 모델이라고는 할 수 없지만 )

4. 모델 성능 평가 ---> 이원교차표를 통해 모델의 정확도 확인

5. 모델 성능 개선 ---> 정확도가 제일 높은 k 값

# 1 - 데이터 수집

위스콘신 유방암 진단 데이터셋

- 569개의 암 조직검사 예시가 들어있고, 각 예시는 32개의 특징을 갖고 있음.
- 특징 : 디지털 이미지에 존재하는 세포핵의 특성 [ 반지름, 질감, 둘레, 넓이, 매끄러움 등 ]

diagnosis -> 라벨 컬럼 [ 지도학습의 정답에 해당하는 컬럼 ]

# 2 - 데이터 탐색 ( 시각화 )

1. 정답에 해당하는 라벨 컬럼의 데이터 분포를 원형 그래프로 시각화

미리 만들어둔 함수를 통해 확인한 결과, 63:37의 비율이다.

이 정도면 충분하다.

5:5가 가장 이상적이고,

만약 한 쪽 비율이 극단적으로 낮은 경우 학습이 제대로 되지 않을 수 있기 때문에

데이터를 더 수집해야한다.

2. 이상치 확인

변수가 30개가 넘으므로 변수별로 하나씩 확인하는게 쉽지 않다.

함수로 편하게 하자.

# 구글에서 구한 이상치 확인을 편하게 하는 함수

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

wisc <- read.csv("wisc_bc_data.csv")

for (i in 3:length(colnames(wisc))){
  a = grubbs.flag(wisc[,colnames(wisc)[i]])
  b = a[a$Outlier==TRUE,"Outlier"]
  print ( paste( colnames(wisc)[i] , '--> ',  length(b) )  )
}

테이블만 바꿔서 사용할 수 있다.


요런 식으로 이상치들을 확인할 수 있다.

일단은 이상치 값이 얼마나 있는지만 확인하고,

추후에 모델의 정확도가 너무 안 나오면 그 때 이상치 데이터를 삭제하고 학습 시켜보는 걸 고려할 수 있다.

3. 결측치가 많은 컬럼이 무엇인지 확인

colSums(is.na(wisc))

지금은 결측치가 없는데, 혹시 결측치가 있다면 다른 값으로 치환하거나 삭제를 고려해야 한다.

# 3 - 데이터 모델 훈련

1. 데이터 로드

wbcd<-read.csv("wisc_bc_data.csv",header=T,stringsAsFactors=F)

2. diagnosis (정답 컬럼)만 facotr로 변환

wbcd$diagnosis<-factor(wbcd$diagnosis,levels=c("B","M"),labels=c("Benign","Maliganant") )
str(wbcd)

3. 데이터를 shuffle

sample(10) # 1부터 10까지 섞어서 출력

wbcd[ c(1,2) , ] # wbcd의 1,2 번째 행만 선택

wbcd_shuffle<-wbcd[ sample(nrow(wbcd)) , ] # wbcd의 총 행 수만큼 섞어 wbcd_shuffle에 저장

wbcd_shuffle

확인해보면 잘 섞였다.

4. 쓸모없는 변수 제거 ( 좀 더 빨리해도 될 듯 )

wbcd2<-wbcd_shuffle[ , -1 ] # Id 제거
str(wbcd2)

5. 데이터 정규화

- 몸무게와 키와 같이 서로 단위가 다른 데이터를 전부 0~1 사이의 데이터로 맞춰주는 과정.
데이터 단위가 같지 않으면 키 데이터의 영향도가 크게 나타나기 때문!
  
  정규화 방법 2가지
1. scale 함수 2. min/max 함수 ( 머신러닝에서는 주로 2번을 채택)

# min/max 함수
normalize<-function(x) {
  return((x-min(x))/(max(x)-min(x)))
}

wbcd_n<-as.data.frame(lapply(wbcd2[,2:31],normalize)) # 2~31번 컬럼에 한꺼번에 적용
summary(wbcd_n) # 0~1 사이 값으로 모두 변환되었는지 확인

6. 훈련 데이터와 테스트 데이터로 wbcd_n 데이터를 9대 1로 나누기

방법 1 ( 임의로 9대 1로 나누기 )
nrow(wbcd_n) # 569
train_num<-round(0.9*nrow(wbcd_n),0)
train_num # 512

wbcd_train<-wbcd_n[1:train_num, ] # 1행부터~ 512행까지 훈련용 데이터에 저장
wbcd_test<-wbcd_n[(train_num+1):nrow(wbcd_n), ] # 513행부터 ~ 마지막 행까지 테스트 데이터에 저장
nrow(wbcd_test) # 57

방법 2 ( caret 사용해서, diagnosis가 적절히 섞이게 9대 1로 나누기 )
install.packages("caret")
library(caret)
wbcd<-read.csv("wisc_bc_data.csv")
nrow(wbcd)
train_num<-createDataPartition(wbcd$diagnosis,p=0.9,list=F)
train_num
train_data<-wbcd[train_num, ]
test_data<-wbcd[-train_num, ]
nrow(train_data)
nrow(test_data)
table(train_data$diagnosis)
table(test_data$diagnosis)
prop.table(table(test_data$diagnosis))
prop.table(table(train_data$diagnosis))

지금은 방법 1을 사용했다.

7. 훈련데이터 라벨 ( 정답 )과 생성하고 테스트 데이터의 라벨 ( 정답 )을 생성

wbcd_train_label<-wbcd2[1:train_num,1]
wbcd_test_label<-wbcd2[(train_num+1):nrow(wbcd_n), 1]

8. knn 모델로 훈련시켜서 모델을 만들고 바로 그 모델에 test 데이터를 넣어서 정확도를 확인하기

install.packages("class")
library(class)
result<-knn(train=wbcd_train, test=wbcd_test, cl=wbcd_train_label, k=21 )

train = 훈련 데이터
test = 테스트 데이터
cl = 훈련 데이터의 라벨

result에 테스트 데이터에 대한 예상 정답이 들어가게 된다.
이번에 k를 21로 줘서 만들었는데, 이 숫자의 이상적인 값은 우리가 알아내야 한다.
이러한 k 값을 '하이퍼 파라미터'라 한다.

파라미터 : 모델 내부에서 확인이 가능한 변수, 학습이 되어지면 만들어지는 숫자 값
ex) 인공신경망에서 가중치, 서포트 벡터 머신에서 서포트 벡터, 회귀의 결정계수

하이퍼 파라미터 : 모델에서 외적인 요소로 분석을 통해 얻어지는 값이 아닌, 사용자가 경험에 의해 직접 설정해주는 값
ex) knn에서 k 값, 신경망에서 학습률, 의사결정트리에서 깊이


위에 출력된 k를 21로 주었을 때 생성된 result가 예상 정답이고, 진짜 정답은 wbcd_test_label에 있다.

위 두 개를 비교하면, 예측의 정확도를 알 수 있을 것이다.

# 정확도 확인

data.frame(result,wbcd_test_label)

일일이 눈으로 확인하기는 어려우니, 같은 개수를 세보자.

sum(result==wbcd_test_label)

57개 중 53개를 맞췄으니 잘 예측한 것 같다.

이는 sample 과정에서 계속 변할 수 있다.

똑같은 식으로 실행해도 어떤 때는 50, 51,48 이렇게 나올 수도 있다.

x<-data.frame('실제'=wbcd_test_label,"예측"=result1)

table(x)

- 실제 양성인데 아니라고 한 경우 : 0

- 양성이 아닌데 양성이라고 한 경우 : 4
