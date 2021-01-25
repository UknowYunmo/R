# R에서 순위를 출력하기

문법:  rank 함수 

예제:  이름, 월급, 월급에 대한 순위를 출력하시오 !
  
data.table( 이름=emp$ename, 월급=emp$sal, 
             순위= rank(-emp$sal, ties.method="min")  )

설명 : rank에 마이너스(-)를 사용하면 월급이 높은 것부터 매겨진다.

ties.method 옵션:
  
1. min :  오라클의 rank 와 같다 ( 동일한 점수 = 동일한 순위 )

2위가 두 명일 경우 다음 출력되는 순위는 4위

2. first :  오라클의 rank 와 같은데 순위가 같은 데이터가 있으면

인덱스 순서가 먼저 나온 데이터를 높은 순위로 부여

3. max :  2등이 두명이면 둘다 3등으로 출력

예제 : 순위별로 출력

library(doBy)
orderBy( ~ 순위, x )

※ 오라클의 dense_rank 와 같은 함수는 무엇인가 ?
   2위가 두 명일 경우 2위,2위,3위

library(dplyr)
x <- data.table( 이름=emp$ename, 월급=emp$sal, 
                순위=dense_rank(-emp$sal)  ) 
library(doBy)
orderBy( ~순위, x )