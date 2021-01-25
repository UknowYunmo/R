# 함수 종류

1. 문자 함수
2. 숫자 함수
3. 날짜 함수
4. 변환 함수
5. 일반 함수 

# 문자 함수 

오라클   vs   R 

upper       toupper
lower       tolower
substr      substr
replace      gsub

예제 : 이름과 직업을 출력하는데 소문자로 출력

library(data.table)

data.table(이름=tolower(emp$ename), 직업=tolower(emp$job) )

예제 : 이름을 출력하고 그 옆에 이름의 첫번째 철자부터 세번째 철자까지 출력

문법 :  substr( 변수, 시작, 끝 )

SQL> select  ename,  substr(ename, 1, 3)
      from  emp;

R> data.table( 이름=emp$ename, 철자=substr(emp$ename,1,3)  )

예제 : 이름, 월급을 출력하는데 월급을 출력할 때에 숫자 0 을 * 로 출력

문법 : gsub(변경전, 변경후, 변수)

SQL> select  ename,  replace( sal, 0, '*' )
      from   emp;
      
R>  data.table( 이름=emp$ename, 월급= gsub( 0, '*', emp$sal)  ) 

예제 : 이름, 월급을 출력하는데 월급을 출력할 때에 숫자 0, 1, 2 를 * 로 출력

SQL> select  ename, regexp_replace( sal, '[0-2], '*')
          from  emp;

R>  data.table( 이름=emp$ename, 월급= gsub( '[0-2]', '*', emp$sal)  ) 

# 숫자 함수 

  오라클                vs                R 

1. round                                round

2. trunc                                trunc

3.  mod                                  %%

4.  power                               2^3    ( 2의 3승)

예제 : 6의 9승을 출력

6^9

10을 3으로 나눈 나머지 값 출력

10%%3

예제 : 이름과 연봉을 출력하는데 연봉은 월급의 12를 곱해서 출력하는데
        각 컬럼명은 이름, 연봉으로 출력

data.table(이름=emp$ename, 연봉=emp$sal * 12 )

예제 : 위의 결과를 다시 출력하는데 round 함수를 써서 백의 자리에서 반올림

data.table(이름=emp$ename, 연봉= round(emp$sal * 12, -3 )  )

 3  5  7  0  0   .   7  3  8

 -5 -4 -3 -2 -1  0  1  2  3 

ex) 35700.738 이라는 수에서 -3은 백의 자리인 7의 위치이다.


예제 : 반올림을 하지 않고 백의 자리 이후를 다 버려서 출력

x<-389.75
trunc(x,-1)
trunc(x,-2)
trunc(x,-3)

trunc는 소수점 이하만 버릴 수 있다.
소수점 이전은 못 버리므로 수행이 안 된다.

# R은 짝수를 좋아한다.

round(122.5)  ----------> 122
round(123.5)  ----------> 124 

딱 중간에 있으면 짝수를 선택한다.

# 날짜 함수 

오라클                  vs                 R 

sysdate                                Sys.Date()

add_months                             difftime

months_between                       내장함수 없음

last_day                             내장함수 없음

next_day                                내장함수 없음 

예제 : 오늘 날짜를 출력

Sys.Date()  

예제 : 이름, 입사한 날짜 부터 오늘까지 총 몇 일 근무했는지 출력

SQL>  select  ename,  sysdate - hiredate
              from  emp;

R>  data.table( emp$ename,  Sys.Date() - as.Date(emp$hiredate ) )

# as.Date() 함수로 문자형 데이터를 날짜 형태로 변환할 수 있다

# 오늘 날짜의 달의 마지막 날짜를 출력

SQL> select  last_day( sysdate ) 
           from  dual;

R>  install.packages("lubridate")

    library(lubridate)

    ceiling_date( Sys.Date(), "months")  - days(1) 

# 이번 달, 다음 달 1일의 날짜 출력

floor_date( Sys.Date(),"months" )  ------------> 2021-01-01

Sys.Date()                         ---------------->  2021-01-18

ceiling_date( Sys.Date() ,"months") ---------->  2021-02-01


# 변환 함수

오라클  --------------------------  R  

to_char                        as.character

to_number                      as.integer 

to_date                         as.Date 


# 이름, 입사한 요일을 출력

SQL> select  ename, to_char( hiredate, 'day')
           from   emp;

R>  data.table( emp$ename,  format( as.Date(emp$hiredate), '%A')  )

설명: format 의  옵션 :        %A : 요일
                               %Y : 년도 4자리
                               %y : 년도 2자리 
                               %m : 달 
                               %d : 일 

# 11월에 입사한 사원들의 이름과 입사일을 출력!

SQL> select  ename, hiredate
          from  emp
          where to_char(hiredate,'mm') = '11' ;

R>   emp[ format( as.Date(emp$hiredate),'%m')=='11', c("ename", "hiredate") ] 

# 오늘부터 100달 뒤에 돌아오는 날짜를 출력

SQL> select add_months( sysdate, 100 )
                from  dual;

R>  Sys.Date() + months(100)

설명 :  days(숫자), months(숫자), years(숫자)  


# 오늘부터 100달 뒤에 돌아오는 날짜의 요일을 출력

SQL> select  to_char( add_months( sysdate, 100) , 'day')
            from  dual;
            
R>  format(  Sys.Date() +  months(100)  ,'%A' )

# 내가 무슨 요일에 태어났는지 출력

SQL> select  to_char( to_date('1995/07/05','RRRR/MM/DD'), 'day')
           from  dual;

R>  format(  as.Date('1995/07/05') , '%A' )

# 일반 함수

  Oracle -----------------------------  R  

1. nvl 함수                          is.na
2. decode 함수                       ifelse
3. case 함수                         ifelse 


예제 : 이름, 월급, 등급을 출력하는데 월급이 1500 이상이면 등급을 A 로 출력하고 아니면 B 로 출력

R>  data.table( emp$ename, emp$sal,  ifelse( emp$sal >= 1500, 'A', 'B')  )

예제 : 이름, 월급, 보너스를 출력하는데 보너스가 입사한 년도가 1980 년도이면 A 로 출력하고 
        1981 년도이면 B 로 출력하고, 1982 년도이면 C 로 출력하고 나머지 년도는 D로 출력

data.table( emp$ename, emp$sal, 
                 ifelse( format( as.Date(emp$hiredate),'%Y')=='1980', 'A',
                 ifelse( format( as.Date(emp$hiredate),'%Y')=='1981', 'B',
                 ifelse( format( as.Date(emp$hiredate),'%Y')=='1982', 'C' ,'D')   ) ) )