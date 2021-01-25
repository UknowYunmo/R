# R로 막대 그래프 그리기 

예제 : emp 테이블의 월급으로 기본적인 막대 그래프를 그리기

barplot(emp$sal) 

예제 : 위의 그래프의 제목을 Salary Bar Chart 라고 이름을 붙이기

barplot(emp$sal, main="Salary Bar Chart")

예제 : 막대 그래프 x 축에 사원이름을 붙이기

barplot(emp$sal, main="Salary Bar Chart", names.arg= emp$ename) 

예제 : 막대 그래프의 x축과 y축의 이름을 각각 이름, 월급이라 붙이기

barplot(emp$sal, main="Salary Bar Chart", names.arg= emp$ename, xlab="이름", ylab="월급" ) 

예제 : 막대 그래프의 색깔을 파란색으로 출력하기

barplot(emp$sal, main="Salary Bar Chart", names.arg= emp$ename, xlab="이름", ylab="월급", col="Green Yellow", density=80 ) 