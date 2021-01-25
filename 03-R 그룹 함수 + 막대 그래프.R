# 그룹 함수 

       Oracle                  vs                 R  

1.     max                                       max
2.     min                                       min
3.     sum                                       sum
4.     avg                                       mean
5.    count                           length (세로) table  (가로) 

예제 : 최대 월급을 출력

max(emp$sal)

예제 : 직업이 SALESMAN인 사원들의 최대 월급을 출력!
  
result <-  emp[ emp$job=="SALESMAN", "sal"]

max(result)

한 줄로 처리하고 싶다면 ?
  
max( emp[ emp$job=="SALESMAN", "sal"] )

예제 : 부서번호가 20인 사원들 중에서의 최소 월급을 출력

min(emp[ emp$deptno==20,  "sal"])

예제 : 직업, 직업별 최대월급을 출력하시오 !
  
SQL> select  job,  max(sal)
      from  emp
      group  by  job;

R>  aggregate( sal~job,  emp,  max )

문법 : aggregate(계산될 컬럼~그룹 기준을 가진 컬럼, 테이블명, 함수명)

aggregate(sal~job,emp,max)

예제 : 부서번호, 부서번호별 토탈 월급을 출력하시오 !
  
SQL> select  deptno, sum(sal)
      from  emp;
      group  by  deptno;
      
R>  aggregate( sal~deptno, emp, sum )

예제 : 위에서 출력되고 있는 컬럼명을 한글로 부서번호, 토탈월급으로 변경하시오 !

result <-  aggregate( sal~deptno, emp, sum )

names(result) <-  c('부서번호', '토탈월급')

result 

예제 : 위의 결과를 다시 출력하는데 토탈 월급이 높은것부터 출력하시오 !
  
library(doBy)

orderBy( ~-토탈월급, result )

예제 : 직업, 직업별 인원수를 출력하시오 !
  
SQL>  select  job,  count(empno)
        from  emp
        group  by  job;

R> result <-  aggregate( empno~job,  emp,  length )

R> names(result) <- c("직업", "인원수")

R> result   

예제 : 위의 결과를 다시 출력하는데 인원수가 높은 것부터 출력하시오 !
  
library(doBy)

orderBy( ~-인원수, result) 

예제 : 직업, 직업별 인원수를 가로로 출력하시오 !
  
table(emp$job)

예제 : 위의 결과를 원형 그래프로 시각화하기

pie(table(emp$job), col=rainbow(14))

예제 : 부서번호, 직업별 토탈 월급을 출력

SQL>  select  deptno,  job,  sum(sal)
        from  emp
        group  by  deptno, job; 
        
R> aggregate( sal ~ deptno+job,  emp, sum )

예제 : 입사한 년도(4자리), 입사한 년도별 평균월급을 출력

SQL>  select   to_char(hiredate, 'RRRR'),  avg(sal)
        from  emp
        group   by   to_char(hiredate,'RRRR');

R> x <- aggregate( sal ~ format( as.Date(emp$hiredate),'%Y'),  emp,  mean )

R> names(x) <- c("입사한 년도", "평균월급")

R> x 

예제 : 직업, 직업별 토탈 월급을 세로, 가로로 출력하기

- 세로 :  aggregate( sal~job,  emp,  sum )

- 가로 :  tapply( emp$sal, emp$job, sum ) 

예제 : 위의 결과를 막대 그래프로 시각화하기

x <-  tapply( emp$sal, emp$job, sum ) 

barplot( x,  main="직업별 토탈월급", col=rainbow(5),  density=50 )

예제 : 직업별, 부서번호별 인원수 막대그래프로 출력

R> attach(emp)

R> tapply( sal, list(job, deptno), sum )  

attach(emp)를 해주면 데이터 프레임이 저장되어 emp$sal, emp$job, emp$deptno 라고 안쓰고
sal, job, deptno 로만 작성할 수 있다.

해제 방법 : detach() 

그런데 위의 데이터를 가지고 그래프를 그리려면 NA가 있으면 안된다. 
NA 값을 숫자 0 으로 변경해줘야 한다. 


예제 : 위의 결과의 NA 를 숫자 0으로 출력되게 하기

x <- tapply( sal, list(job, deptno), sum )  

x[ is.na(x) ] <- 0

예제 : 위의 결과에서 컬럼명만 출력하고  로우명만 출력

colnames(x) -> 컬럼명

rownames(x) -> 로우명

예제 : 위의 결과 데이터를 막대 그래프로 시각화

barplot( x,  col=rainbow(5), legend=rownames(x), beside=T, density=50) 

legend : 그래프의 설명 박스입니다.

beside=T : 직업별로 각각 막대 그래프 생성