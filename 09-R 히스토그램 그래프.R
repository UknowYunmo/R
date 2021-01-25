# R에서 히스토그램 그래프 그리기 

하나의 속성에 대한 데이터의 분포를 시각적으로 표현하는 그래프

중고차 가격 데이터 : usedcars.csv

usedcars <- read.csv("usedcars.csv")
View(usedcars) # 데이터 테이블 확인

1. 전체 건수를 확인

nrow(usedcars) # 150

2. 컬럼이 몇 개 인지 확인

ncol(usedcars) # 6

3. 각 컬럼들의 데이터에 대한 통계 정보를 확인

summary(usedcars)

4. 중고차 가격에 대한 히스토그램 그래프 그리기

hist(usedcars$price)

5. 히스토그램 x 축의 간격이 좀 더 이해하기 쉽게 나올 수 있도록 그래프 그리기

hist(usedcars$price, at=seq(0, 24000, by=2000),breaks= seq(0, 24000, by=2000) )


예제 : 중고차의 마일리지로 히스토그램 그래프를 그리기

max_m = max(usedcars$mileage)*1.1
주행거리=usedcars$mileage
hist( 주행거리, breaks=seq(0, max_m , by=10000),at=seq(0, max_m ,by=10000), main="중고차 주행거리", col='blue', density=80 )