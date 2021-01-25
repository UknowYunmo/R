예제 : 직업과 직업별 토탈 월급을 가지고 원형(pie) 그래프를 그리시오 !
  
x <-  tapply(  emp$sal,  emp$job,  sum )
  
pie( x,  col=rainbow(5),  density=80 )
  
예제 : 위의 그래프를 3D 로 그리기
  
install.packages("plotrix")
library( plotrix )
pie3D( x, explode=0.1, labels=rownames(x) ) #explode : 벌어짐 정도
  
예제 : 위의 그래프의 결과에 직업 옆에 비율도 같이 출력
  
x <- tapply( emp$sal, emp$job, sum ) # 직업별 토탈월급을 가로로 출력
x2 <- aggregate( sal~job, emp, sum ) # 직업별 토탈월급을 세로로 출력 

pct <-  round( x2$sal / sum(emp$sal) *100, 1) 
job_label <-  paste(  x2$job, ':', pct,  '%' )
pie3D(  x,  explode=0.1, labels=job_label )  # 3D 로 원형 그래프 그리기 
pie(  x, labels=job_label ,col=rainbow(14))  # 그냥 원형 그래프 그리기 