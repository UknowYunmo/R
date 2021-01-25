# R이란?

데이터 분석을 위한 통계 및 시각화를 지원하는 무료 소프트웨어
파이썬과 비교해서 장점 : 데이터 시각화가 R이 더 예쁘다.

# R을 왜 사용하는지

1. R은 공짜

2. 데이터 분석을 위해 가장 많이 사용하는 통계 플랫폼

3. 복잡한 데이터를 다양한 그래프로 표현 가능

4. 분석을 위한 데이터를 쉽게 저장하고 조작할 수 있다.

5. 누구든지 유용한 패키지를 생성해서 공유할 수 있고, 새로운 기능에 대한 전파가 빠름

6. 어떠한 os에도 설치 및 이용 가능 ( 아이폰에도! )

# R의 자료구조

1.  vector  :  같은 데이터 타입을 갖는 1차원 배열 구조 

2.  matrix  :  같은 데이터 타입을 갖는 2차원 배열 구조 

3.  array    :  같은 데이터 타입을 갖는 다차원 배열 구조

4.  data.frame  : 각각의 데이터 타입을 갖는 컬럼으로 이루어진 2차원 배열구조

ex)  RDBMS의 테이블과 유사하다.

5.  list   :  서로 다른 데이터 구조(vector, data frame, matrix, array)인 데이터 타입이 중첩된 구조

# csv 데이터 불러오기

setwd("c:/users/user/Desktop/RR") # 디렉토리 설정

getwd() # 디렉토리 확인

emp<-read.csv("emp3.csv") # 데이터 로드

emp # 데이터 확인

# 데이터 조회

문법 : emp[행,열]

예제 : emp 데이터 프레임에서 이름과 월급을 출력

emp[ , c("ename","sal") ]  # c->combine

예제 : 월급이 3000인 사원들의 이름과 월급을 출력

emp[ emp$sal==3000, c("ename","sal") ]

예제 : 월급이 2000 이상인 사원들의 이름과 월급을 출력

emp[ emp$sal>=2000, c("ename","sal) ]

예제 : 직업이 SALESMAN인 사원들의 이름과 월급과 직업을 출력

emp[ emp$job=='SALESMAN', c("ename", "sal", "job") ]

예제 : 1981년 12월 11일에 입사한 사원들의 이름과 입사일을 출력

emp [ emp$hiredate=='1981-12-11 0:00' c("ename","hiredate") ]

# 데이터 프레임 구조 확인

str(emp)

# 연산자 총정리

1. 산술 연산자 :  *  /  +  -  

2. 비교 연산자 :  >, <, >=, <=, ==, !=  

3. 논리 연산자 :  &   :  and ( 백터화 된 연산)
                  &&  :  and ( 첫번째 원소간의 연산) 
                  |   :   or ( 백터화된 연산 )
                  ||  :   or ( 백터화 되지 않은 연산) 
                  !   :  not

ex) x <- c(1,2,3) 
    ( x > c(1, 1, 1) ) & ( x < c(3, 3, 3) ) 

출력 : FALSE  TRUE  FALSE

예:  x <- c(1,2,3)
     ( x > c(0, 0, 0) ) && ( x < c(2, 2, 2) )

출력 : TRUE

세번째 원소가 2보다 작으므로 말이 안되지만, TRUE가 나온 이유는

첫번째 원소인 1이 0보다 크고, 2보다 작기 때문

# 연결 연산자 

       오라클 --------------------------------- R

         ||                                   paste 

변수 + 문장으로 출력하고 싶을 때

1. data.table 패키지를 설치

install.packages("data.table")

2. data.table 을 사용하겠다고 지정

library(data.table)

3. data.table 을 사용

data.table( emp$ename, ' 의 직업은 ' , emp$job )

4. 예제

SQL> select  ename || ' 의 직업은 ' ||  job
         from emp;

R> paste(  emp$ename, ' 의 직업은 ', emp$job)


# 기타 비교 연산자 

  오라클 ------------------------ R  

1.  in                           %in%

2.  like                         grep

3.  is null                      is.na

4.  between  .. and     emp$sal >= 1000  & emp$sal <= 3000

예제 : 직업이 SALESMAN, ANALYST 인 사원들의 이름과 월급과 직업을 출력

emp[ emp$job %in%  c("SALESMAN","ANALYST"), c("ename","sal", "job") ]

예제 : 직업이 SALESMAN, ANALYST 가 아닌 사원들의 이름과 월급과 직업을 출력

emp[ ! emp$job %in%  c("SALESMAN","ANALYST"), c("ename","sal", "job") ]

예제 : 부서번호가 10번, 20번인 사원들의 이름과 월급과 부서번호를 출력

emp[ emp$deptno  %in%  c(10,20), c("ename", "sal", "deptno")  ]

예제 : 커미션이 null 인 사원들의 이름과 월급과 커미션을 출력

emp[ is.na(emp$comm),  c("ename", "sal", "comm") ]

# NA, NaN, NULL

1. NA (결손값) -------->  is.na()

2. NaN - 'Not a Number' (비수치) --------> is.nan()

3. NULL (아무것도 없다) -----> is.null()

예제 : 커미션이 NA 가 아닌 사원들의 이름과 월급과 커미션을 출력

emp[ ! is.na(emp$comm),  c("ename", "sal", "comm") ]

예제 : 월급이 1000 에서 3000 사이인 사원들의 이름과 월급을 출력

SQL> SELECT  ename, sal
          from  emp
         where  sal  between  1000  and 3000;

emp[ emp$sal >= 1000  &  emp$sal <= 3000 , c("ename", "sal") ]

예제 : 월급이 1000 에서 3000 사이가 아닌 사원들이 이름과 월급을 출력

emp[ ! ( emp$sal >= 1000  &  emp$sal <= 3000 ), c("ename", "sal") ]

# grep -> 문자열 검색

예제 : 이름에 L이 들어있는 사원들의 이름과 월급을 출력

emp [ grep("L", emp$ename), c("ename","sal")

예제 : 이름의 첫번째 철자가 A 로 시작하는 사원들의 이름과 월급을 출력

emp[ grep("^A", emp$ename) , c("ename", "sal") ] 

설명: ^ 는 시작을 의미

예제 : 이름의 끝글자가 T 로 끝나는 사원들의 이름과 월급을 출력

emp[ grep("T$", emp$ename),  c("ename", "sal") ]

설명: $ 는 끝을 의미

예제 : 이름의 두번째 철자가 M 인 사원들의 이름과 월급을 출력

emp[ grep("^.M", emp$ename), c("ename", "sal") ] 

설명:  점(.) 은 자릿수 하나를 의미

# 중복 제거 

      오라클  ------------------------------  R 

      distinct                              unique

예제 : 부서 번호를 출력하는데 중복을 제거해서 출력 

library(data.table)

data.table( "부서번호"=unique(emp$deptno)  )

예제 : 직업을 출력하는데 중복을 제거해서 출력

library(data.table)

data.table( "직업"=unique(emp$job)  )

# 정렬 작업 

    오라클 -------------------  R  

    order  by                  1. data frame 에서 order 옵션

                               2. doBy 패키지를 설치하고 orderBy 함수를 사용 

예제 : 이름과 월급을 출력하는데 월급이 높은 사원부터 출력

emp[ order(emp$sal, decreasing=T), c("ename", "sal") ]

예제 : 이름과 입사일을 출력하는데 먼저 입사한 사원부터 출력

emp[ order(emp$hiredate, decreasing=F), c("ename", "hiredate") ]

예제 :  직업이 SALESMAN 인 사원들의 이름과 월급과 직업을 출력하는데
         월급이 높은 사원부터 출력 ( 조건 2개 )

1.  직업이 SALESMAN 인 사원들의 이름과 월급을 출력해서 result 변수에 담는다

result <-  emp[ emp$job=='SALESMAN', c("ename", "sal", "job") ]

2.  result 변수의 월급을 높은 것부터 출력한다. 

result[ order(result$sal, decreasing=T), c("ename", "sal", "job") ]

예제 : 부서번호가 30번인 사원들의 이름과 월급과 입사일을 출력하는데
         먼저 입사한 사원부터 출력

result <-  emp[ emp$deptno == 30, c("ename", "sal", "hiredate") ]

result[ order(result$hiredate , decreasing=F),  ]  

# Doby 패키지를 사용한 order by

예제 : 이름과 월급을 출력하는데 월급이 높은 것부터 출력

install.packages("doBy")

library(doBy)

orderby(~-sal, emp[ , c("ename","sal")] )

설명:  emp[  , c("ename","sal")] 이름과 월급을 출력하는 결과를 orderBy 함수에
        넣고 정렬하고자하는 컬럼 sal 앞에 ~ 물결을 사용해서 정렬을 하면 된다. 
        물결 다음에 마이너스(-) 를 붙여주면 높은 것부터 정렬된다. 

예제 : 직업이 ANALYST 가 아닌 사원들의 이름과 월급과 직업을 출력하는데
        월급이 높은 사원부터 출력

orderBy( ~-sal,   emp[ emp$job !='ANALYST', c("ename", "sal", "job") ] )

# 현재 R에서 선언한 변수의 목록 확인

ls()

# 변수 삭제

rm(result) # result 변수 삭제