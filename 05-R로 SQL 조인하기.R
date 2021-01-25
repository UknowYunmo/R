■  SQL 과  R  비교 (조인)

Oracle           vs           R 

equi join

non equi join               merge 

outer  join

self  join

예제 : 이름(emp.csv)과 부서 위치(dept.csv)를 출력하시오 !
  
SQL>  select  e.ename,  d.loc
        from  emp  e, dept  d
        where  e.deptno = d.deptno;
        
R> x <- merge(  emp, dept,  by="deptno")

R> x[    ,  c("ename","loc") ] 


예제 : 부서 위치가 DALLAS인 사원들의 이름과 월급과 부서 위치를 출력

x <- merge(  emp, dept,  by="deptno")

x[ x$loc=="DALLAS"   ,  c("ename","loc") ] 

예제 : 커미션이 NA 인 사원들의 이름과 부서위치와 커미션을 출력하시오 !
  
x <- merge(  emp, dept,  by="deptno")

x[ is.na( x$comm) , c("ename", "loc", "comm") ]


예제 : outer join 으로 이름과 부서 위치를 출력하는데 사원 중 부서 위치가 없더라도 모든 부서 위치 출력

SQL>  select  e.ename,  d.loc
        from   emp  e,  dept   d
        where  e.deptno (+) = d.deptno ;

R>  x <-  merge( emp, dept,  by="deptno", all.y=T)
                 ↑     ↑
                 x      y 

all.x=T : emp 테이블 쪽에 데이터가 모두 나오게 해라
all.y=T : dept 테이블 쪽에 데이터가 모두 나오게 해라
all=T : 양쪽 테이블에 빠지는 데이터 없이 해라

- 15번째 행을 보면 부서 번호가 40인 사원은 없지만 출력되었다.

예제 : 사원의 이름을 출력하고 그 옆에 자기의 직속 상사의 이름을 출력하시오 !
  
SQL> select  사원.ename,  관리자.ename
      from    emp   사원,  emp  관리자
      where  사원.mgr = 관리자.empno; 

R> x <-  merge( emp,  emp,  by.x="mgr", by.y="empno")
                ↑     ↑
                x       y

emp를 x와 y 두 개로 만들고
x의 mgr과 y의 empno가 같으면 조인시키겠다.

R>  x[   ,  c("ename.x",  "ename.y") ] 

예제 : 위의 결과를 다시 출력하는데 자기의 월급이 자기의 직속상사의 월급보다 더 큰 사원들만 출력

x[ x$sal.x > x$sal.y  ,  c("ename.x",  "ename.y") ] 