# k-means  알고리즘

k-means 알고리즘은 주어진 데이터를 k 개의 클러스터로 묶는 알고리즘으로,
각 클러스터와 거리차이의 분산을 최소화하는 방식으로 동작한다.
이 알고리즘은 자율학습의 일종으로 레이블(정답)이 달려있지 않은
입력 데이터에 레이블(정답)을 달아주는 역할로도 활용되고 있다.

이 세상의 데이터는 정답이 없는 데이터가 훨씬 많다.
그래서 정답이 없는 데이터 속에서 어떤 패턴을 찾고 싶을때
비지도 학습의 k-means 군집화 머신러닝 알고리즘을 활용한다.

k-means 현업사례:
  
1.  모통신사에서 기지국을 세울때 사용

2.  병원에서 암 판별 머신러닝 모델을 만든는데 라벨링있는 지도학습

- 데이터를 훈련 시킬때 비지도학습을 같이 사용해서 모형의 정확도를 올리는데 참조

- 이 데이터는 악성이다. 이 데이터는 양성이다라고 라벨링 하는 작업을 사람이 일일이 한다.

그러나 사람이 실수를 할 가능성이 있기 때문에 실수를 했는지 안했는지 빠르게 판단할 때 k-means 를 활용한다.

3. 마케팅에서 고객들을 특성에 맞는 사람들끼리 군집화

4. 미국의 유명한 사례 : 순찰 지역을 정하는데 활용을 해서 범죄율을 사용해서

영화 마이너리 리포트처럼 범죄를 미리 예방하는데 사용


# 군집간의 거리 측정 방법

1. 최단 연결법 : 두 군집 사이의 거리를 각 군집에서 하나씩 관측값을 뽑았을때

나타날수 있는 거리의 최솟값으로 측정

2. 최장 연결법 :  두 군집 사이의 거리를 각 군집에서 하나씩 관측값을 뽑았을때

나타날수 있는 거리의 최댓값으로 측정

3. 중심 연결법 : 두 군집간의 중심간의 거리를 측정

4. 평균 연결법 : 두 군집 사이의 거리를 각 군집에서 하나씩 관측값을 뽑았을때

나타날수 있는 거리의 평균값으로 측정

5. 와드 연결법 : 군집간의 거리에 기반하는 다른 연결법과는 다른

군집간의 오차 제곱합에 기초하여 군집을 수행

# k-means 의 단점  

1.  k 값을 지정하기가 어렵다. 

적당한 k 값을 계산하는 공식 :    k = sqrt(n/2)  ,  n 은 전체건수

-> 예시 중 하나일뿐

2.  이상치에 민감하다

-> 이상치까지 설명하려고 노력하기 때문

3.  k-means 로 군집화 한 결과에 대한 타당성 검증을 하기가 어렵다.

지도학습은 예측값과 정답과의 이원교차표를 통해서 좋은 모델인지 확인을 했는데

비지도학습은 정답이 없어서 타당성 검증이 어렵다.

그래서 보통 클러스터링한 결과를 가지고 기술 통계 기법을 써서 잘 군집화 했는지 분석한다.

# k-means 실습 예제

1. 데이터를 로드

academy <- read.csv("academy.csv")
View(academy)
academy <- academy[  ,  c(3,4) ] # 수학점수와 영어점수만 선택

2. k 값을 4로 주고 비지도학습 시켜 모델을 생성

km <- kmeans( academy,  4) 

3. 시각화

library(factoextra)
fviz_cluster(km , data=academy,  stand=F)

4. 학생번호, 수학점수, 영어점수, 분류번호를 같이 출력

academy <- read.csv("academy.csv")
cbind( academy[   ,c(1,3,4)], km$cluster)

5. 수학은 아주 잘하는데 영어가 보통인 학생들에게 연락을 하기 위해
그 학생들의 학생번호만 추출하기

academy <- read.csv("academy.csv")
academy_seg <- cbind( academy[   ,c(1,3,4)], km$cluster)
academy_seg[km$cluster==1,   "학생번호" ]

-> 마케팅을 위해서 k-means 를 이용해서 세그멘테이션을 해서 관련 학생들에게 광고를 따로 진행