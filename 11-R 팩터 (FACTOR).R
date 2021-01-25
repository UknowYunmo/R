# R의 자료구조 

1. vector :  같은 데이터 타입을 갖는 1차원 배열구조

a <-  c(1, 2, 3, 4, 5)

2. matrix  :  같은 데이터 타입을 갖는 2차원 배열구조

3. array   :  같은 데이터 타입을 갖는 다차원 배열구조 

4. data frame  : rdbms 의 테이블과 같이 행과 열로 이루어진 자료구조 

5. list    :  서로 다른 데이터 구조의 중첩된 구조 

# factor 를 알아야 하는 이유

순위 데이터를 모델링하는 머신러닝 알고리즘은 순서 팩터를 기대하기 때문에 

# factor

팩터(factor) 란 범주 변수나 순위 변수를 나타내기 위해 사용하는 

특별한 종류의 백터(vector)

팩터 =  일반 벡터 + level  

예시 : 
  
a <-  c("middle", "low", "high")  # 백터를 생성
a
str(a)

a2 <-  factor(a) # 팩터로 변환
a2
str(a2)

- Factor w/ 3 levels "high","low","middle": 3 2 1

설명: 팩터는 백터와는 다르게 순서라는 개념이 들어가 있는데

위의 a2 의 팩터의 경우, 순서가 알파벳 순서로 abcd 순서로 순서의 개념이 들어가 있다.

order(a2, decreasing=F)

a2[ order(a2, decreasing=F) ]

a[ order(a, decreasing=F) ]

- 일반 벡터와 비교해 level의 유무의 차이를 확인

# 우리가 생각하는  low , middle  ,high  순서로 순서를 부여해서 a3 factor를 구성

a3 <- factor( a,  order=TRUE,  level=c("low", "middle", "high") )
a3
str(a3)

- Levels: low < middle < high   <--- 이렇게 순서를 부여할 수 있어서 머신러닝 모델 학습시킬 때

어떤게 높고 낮은지 즉 어떤게 좋고 나쁜지 어떤게 악성이고 어떤게 양성이지를 알려주면서 머신러닝 모델을 학습시킬 수 있다.  

# 팩터의 두 가지 형식

- nominal, ordinal

nominal 은 level 순서의 값이 무의미하며 알파벳 순서로 정의된다

ordinal 은 level 순서의 값을 직접 정의해서 원하는 순서를 정한다

nominal : a2 <-  factor(a)

ordinal : a3 <- factor( a,  order=TRUE,  level=c("low", "middle", "high") )

머신러닝 모델을 학습 시킬때는 데이터를 factor 로 제공해야 합니다. 

왜냐하면 뭐가 크고 뭐가 작은지 또는 뭐가 좋고 뭐가 나쁜지를 알아야 하기 때문입니다. 


예제:  유방암 데이터의 라벨은 factor 로 주기

wisc <-  read.csv("wisc_bc_data.csv", header=T, stringsAsFactor=T )

설명:  위와 같이 T가 아닌 반대인 stringsAsFactor=F 를 하게 되면

wisc_bc_data.csv 의 데이터 중에 문자형 데이터를 Factor 로 변환하지 말고 문자형으로 쓰겠다는 뜻.

그래서 유방암 데이터의 정답 컬럼인 diagnosis 가 문자형(chr)으로 되어 머신러닝 모델이 정답으로 인식하지 못한다.