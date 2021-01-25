# R에서 라인 그래프 그리기 

시간 순서에 따른 데이터의 변화를 볼때 유용한 그래프

예제 : 아래의 데이터로 plot(점) 그래프 그리기

cars <-  c( 1, 3, 6, 4, 9 )
plot(cars)

예제 : 위의 그래프에 파란색 선 그리기

plot(cars, type='o',  col='blue' )

type='o'  : 선을 그어라!
  
예제 : 차와 트럭의 판매량을 라인 그래프로 시각화하기

cars <- c(1, 3, 6, 4, 9)
trucks <- c(2, 5, 4, 5, 12)

plot( cars, type='o', col='blue', ylim=c(0,12) 
      lines( trucks,  type='o', pch=22, lty=2, col='red')
      
pch= 21 : 동그라미 ,  lty =1 : 직선
pch=22  : 네모 ,      lty = 2 : 점선 
      
예제 : 가로축을 월, 화, 수, 목, 금으로 변경하기
      
cars <- c(1, 3, 6, 4, 9)
trucks <- c(2, 5, 4, 5, 12)

plot( cars, type='o', col='blue', ylim=c(0,12), axes=FALSE, ann=FALSE )
lines( trucks,  type='o', pch=22, lty=2, col='red')
      
설명: axes=FALSE : x 축과 y 축을 지워라!
        ann=FALSE  :  축이름을 지워라 !
        
새로운 축을 생성하기

axis(1,  at=1:5,  lab=c("mon", "tue", "wed", "thu", "fri") ) # x축 생성
     ↑
    x 축

axis(2)  # y 축 생성
      
cars <- c(1, 3, 6, 4, 9)
trucks <- c(2, 5, 4, 5, 12)
      
plot( cars, type='o', col='blue', ylim=c(0,12), axes=FALSE, ann=FALSE )
      lines( trucks,  type='o', pch=22, lty=2, col='red')
      axis( 1,  at=1:5,  lab=c("mon", "tue", "wed", "thu", "fri") )
      axis(2)  # y 축 생성 
      legend( 2, 10, c('car', 'truck'), col=c('blue','red'), cex=0.8, pch=21:22, lty=1:2  ) 
      
레전드 안의 속성 설명 : cex (글씨 크기), pch 21(동그라미), pch 22(네모), lty 1(직선), lty 2(점선) 