-- 11-1
-- CTE : Common Table Expression, WITH으로 시작되는 SELECT문 서브쿼리를 여러 개 선언해서 사용 
-- 장점 : 서브쿼리 안에서 또 다른 서브쿼리 참조가 가능하다. 이것은 파생테이블에서는 불가함. 
USE mywork;

WITH mng AS 
( SELECT b.dept_no, b.emp_no, c.first_name, c.last_name
    FROM dept_manager b, 
         employees c
   WHERE b.emp_no = c.emp_no
     AND SYSDATE() BETWEEN b.from_date AND b.to_date
) 
SELECT a.dept_no, a.dept_name,
       b.emp_no, b.first_name, b.last_name
  FROM departments a, 
       mng b     
 WHERE a.dept_no = b.dept_no
 ORDER BY 1;

-- 11-2
-- 파생 테이블에서는 서브쿼리 안에 또 다른 서브쿼리에서 불러오는 게 불가능함. 따라서 CTE을 활용을 함 
SELECT a.dept_no, a.dept_name, sal.emp_no, sal.salary 
  FROM departments a,
      ( SELECT emp_no, dept_no
          FROM dept_manager
         WHERE SYSDATE() BETWEEN from_date AND to_date
      ) dept_mgr,
      ( SELECT a.emp_no, a.salary, b.dept_no
          FROM salaries a,
               dept_mgr b
         WHERE SYSDATE() BETWEEN a.from_date AND a.to_date
           AND a.emp_no = b.emp_no
      ) sal
 WHERE a.dept_no = sal.dept_no; 
 

-- 11-3
-- CTE의 장점
WITH dept_mgr AS (
SELECT emp_no, dept_no
  FROM dept_manager
 WHERE sysdate() BETWEEN from_date AND to_date),
sal AS (
SELECT a.emp_no, a.salary, b.dept_no
  FROM salaries a,
       dept_mgr b
 WHERE SYSDATE() BETWEEN a.from_date AND a.to_date
   AND a.emp_no = b.emp_no )
SELECT a.dept_no, a.dept_name, sal.emp_no, sal.salary 
  FROM departments a,
       sal
 WHERE a.dept_no = sal.dept_no; 



-- 11-4
WITH tmp AS  
( SELECT a.dept_no, a.dept_name,
         COUNT(*) cnt, SUM(c.salary) salary
    FROM departments a, 
         dept_emp b, 
         salaries c
   WHERE a.dept_no = b.dept_no
     AND b.emp_no  = c.emp_no
     AND SYSDATE() BETWEEN b.from_date AND b.to_date
     AND SYSDATE() BETWEEN c.from_date AND c.to_date
   GROUP BY a.dept_no, a.dept_name ),
dept_avg AS 
( SELECT AVG(salary) avg_sal 
    FROM tmp )        
SELECT dept_no, dept_name, SALARY, avg_sal
  FROM tmp, 
       dept_avg;

-- 11-5
-- CTE로 재귀 쿼리 만들기가 가능함. WITH RECURSIVE, UNION ALL
WITH RECURSIVE cte AS
(
  SELECT 1 as n
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 5
)
SELECT * FROM cte;

-- 11-6
SELECT DATE(release_date) dates, COUNT(*) cnt
  FROM box_office
 WHERE EXTRACT(YEAR_MONTH FROM release_date) = 201901
 GROUP BY 1
 ORDER BY 1;

-- 11-7
WITH RECURSIVE cte1 AS 
( SELECT MIN(DATE(release_date)) dates 
    FROM box_office
   WHERE EXTRACT(YEAR_MONTH FROM RELEASE_DATE) = 201901
   UNION ALL 
  SELECT ADDDATE(dates, 1) 
    FROM cte1
   WHERE ADDDATE(dates, 1)  <= '2019-01-31'   
   )
SELECT a.dates, COUNT(b.movie_name) cnt
  FROM cte1 a
  LEFT JOIN box_office b
    ON a.dates = b.release_date
 GROUP BY 1
 ORDER BY 1;
    


-- 11-8
CREATE TABLE emp_hierarchy (
       employee_id   INT, 
       emp_name      VARCHAR(80),
       manager_id    INT,
       salary        INT,
       dept_name     VARCHAR(80)
);
       
INSERT INTO emp_hierarchy VALUES 
(200,'Jennifer Whalen',101,4400,'Administration'),
(203,'Susan Mavris',101,6500,'Human Resources'),
(103,'Alexander Hunold',102,9000,'IT'),
(104,'Bruce Ernst',103,6000,'IT'),
(105,'David Austin',103,4800,'IT'),
(107,'Diana Lorentz',103,4200,'IT'),
(106,'Valli Pataballa',103,4800,'IT'),
(204,'Hermann Baer',101,10000,'Public Relations'),
(100,'Steven King',null,24000,'Executive'),
(101,'Neena Kochhar',100,17000,'Executive'),
(102,'Lex De Haan',100,17000,'Executive'),
(113,'Luis Popp',108,6900,'Finance'),
(112,'Jose Manuel Urman',108,7800,'Finance'),
(111,'Ismael Sciarra',108,7700,'Finance'),
(110,'John Chen',108,8200,'Finance'),
(108,'Nancy Greenberg',101,12008,'Finance'),
(109,'Daniel Faviet',108,9000,'Finance'),
(205,'Shelley Higgins',101,12008,'Accounting'),
(206,'William Gietz',205,8300,'Accounting');


SELECT *
  FROM emp_hierarchy
 ORDER BY 1; 

-- 11-9 여기서부터
-- 재귀를 하기 위해, 시작점과 순환하는 지점, 그리고 끝나는 조건이 필요함..
WITH RECURSIVE cte1 AS (
SELECT 1 level, employee_id, emp_name, CAST(employee_id AS CHAR(200)) path
  FROM emp_hierarchy
 WHERE manager_id IS NULL
 UNION ALL
SELECT level + 1, b.employee_id, b.emp_name, CONCAT(a.path, ',', b.employee_id)
  FROM cte1 a 
 INNER JOIN emp_hierarchy b
    ON a.employee_id = b.manager_id
)
SELECT employee_id, emp_name, level, path, 
       CONCAT(LPAD('', 2 * level, ' '), emp_name ) hier_name
  FROM cte1
 ORDER BY path;
  
       
-- 11-10
SELECT YEAR(release_date) years,
       SUM(sale_amt) sum_amt, AVG(sale_amt) avg_amt
  FROM box_office
 WHERE YEAR(release_date) >= 2018
   AND ranks <= 10
 GROUP BY 1
 ORDER BY 1;

-- 11-11
WITH summary AS (
SELECT YEAR(release_date) years,
       SUM(sale_amt) sum_amt, AVG(sale_amt) avg_amt
  FROM box_office
 WHERE YEAR(release_date) >= 2018
   AND ranks <= 10
 GROUP BY 1
)
SELECT b.years, a.ranks, a.movie_name, a.sale_amt, b.sum_amt, b.avg_amt
  FROM box_office a
 INNER JOIN summary b
    ON YEAR(a.release_date) = b.years
 WHERE a.ranks <= 10
 ORDER BY 1, 2;

-- 11-12
-- 윈도우를 사용하면 위 명령어를 보다 간단하게 작성할 수 있음.
SELECT YEAR(release_date) years, ranks, movie_name, sale_amt, 
       SUM(sale_amt) OVER (PARTITION BY YEAR(release_date)) sum_amt,
       AVG(sale_amt) OVER (PARTITION BY YEAR(release_date)) avg_amt       
  FROM box_office
 WHERE YEAR(release_date) >= 2018
   AND ranks <= 10
 ORDER BY 1, 2;
 

-- 11-13
-- ROW_NUMBER() : 로우의 순번
SELECT employee_id, emp_name, dept_name, salary,
       ROW_NUMBER() OVER ( PARTITION by dept_name
                           ORDER BY salary DESC
                         ) seq
  FROM emp_hierarchy
 ORDER BY 3, 4 DESC;
   

-- 11-14
-- 윈도우 함수 : 특정 칼럼 값을 기준으로 지정한 로우의 그룹으로 다양한 집계 값을 산출함
-- PARTITION BY : 윈도우 지정
-- ORDER BY : 윈도우로 지정된 로우의 순서

-- 윈도우 함수는 정말 다양한 게 있음.
-- RANK() : 순위
-- DENSE_RANK() : 누적 순위
-- PERCENT_RANK() : 비율 순위
SELECT employee_id, emp_name, dept_name, salary,
       RANK() OVER ( PARTITION by dept_name
                     ORDER BY salary DESC
                    ) ranks,
       DENSE_RANK() OVER ( PARTITION by dept_name
                           ORDER BY salary DESC
                          ) dense_ranks,
       PERCENT_RANK() OVER ( PARTITION by dept_name
                             ORDER BY salary DESC
                           ) percent_ranks
  FROM emp_hierarchy
 ORDER BY 3, 4 DESC;  

-- 11-15
-- LAG() : 현재 로우의 바로 앞 로우 값
-- LEAD() : 현재 로우의 다음 로우 값
SELECT employee_id, emp_name, dept_name, salary,
       LAG(salary) OVER ( PARTITION by dept_name
                          ORDER BY salary DESC
                        ) lag_previous,
       LEAD(salary) OVER ( PARTITION by dept_name
                           ORDER BY salary DESC
                         ) lead_next
  FROM emp_hierarchy
 ORDER BY 3, 4 DESC;


-- 11-16
-- 2번째 매개변수 : 이전 또는 이후의 몇 번째 로우를 가져올 것인지
-- 3번째 매개변수 : 계산한 값이 NULL일 경우 default 값으로 무엇을 줄 것인지
SELECT employee_id, emp_name, dept_name, salary,
       LAG(salary, 1, 0) OVER ( PARTITION by dept_name
                                ORDER BY salary DESC
                              ) lag_previous,
       LEAD(salary, 1, 0) OVER ( PARTITION by dept_name
                                 ORDER BY salary DESC
                               ) lead_next
  FROM emp_hierarchy
 ORDER BY 3, 4 DESC;
       
-- 11-17
SELECT employee_id, emp_name, dept_name, salary,
       LAG(salary, 2, 0) OVER ( PARTITION by dept_name
                                ORDER BY salary DESC
                              ) lag_previous,
       LEAD(salary, 2, 0) OVER ( PARTITION by dept_name
                                 ORDER BY salary DESC
                               ) lead_next
  FROM emp_hierarchy
 ORDER BY 3, 4 DESC;
       
-- 11-18
WITH basis AS 
(SELECT year(release_date) years, sale_amt
       ,LAG(sale_amt, 1, 0) OVER ( ORDER BY YEAR(release_date)  )  lastyear_sale_amt
  FROM box_office
 WHERE ranks = 1
)
SELECT years, sale_amt, lastyear_sale_amt,
       ROUND((sale_amt - lastyear_sale_amt) / lastyear_sale_amt * 100, 2) rates
  FROM basis   
 ORDER BY 1 DESC ;

       
-- 11-19
-- CUME_DIST() : 누적 분포 값
SELECT employee_id, emp_name, dept_name, salary,
       CUME_DIST() OVER ( PARTITION by dept_name
                          ORDER BY salary DESC
                        ) rates
  FROM emp_hierarchy
 ORDER BY 3, 4 DESC;  
       
       
-- 11-20
-- NTILE() : 분할 버킷 수. 데이터를 K개 버킷으로 나누면 몇 번째 버킷에 담겨질 것인가.
SELECT employee_id, emp_name, dept_name, salary,
       NTILE(3) OVER ( PARTITION by dept_name
                       ORDER BY salary DESC
                     ) ntiles
  FROM emp_hierarchy
 ORDER BY 3, 4 DESC;
       
       
-- 11-21
-- FRAME 절로 집계 범위 조정하기
-- FRAME : PARTITION BY로 지정된 파티션을 다시 나눈 하위 집합
-- ROWS, RANGE, BETWEEN AND
-- CURRENT ROW : 현재 로우
-- UNBOUNDING PRECEDING : 파티션의 첫 번째 로우
-- UNBOUNDING FOLLOWING : 파티션의 마지막 로우
-- https://youtu.be/FQHEiQMe-ng?list=PLYFv2vXOfyGyvts0x8KxWScSjTQ_gmi2s (24분)
SELECT employee_id, emp_name, dept_name, salary,
       SUM(salary) OVER ( PARTITION BY dept_name
                          ORDER BY salary DESC
                          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) rows_value,
       SUM(salary) OVER ( PARTITION BY dept_name
                          ORDER BY salary DESC
                          RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                        ) range_value
  FROM emp_hierarchy 
 WHERE DEPT_NAME IN ('IT', 'Finance')
 ORDER BY 3, 4 DESC;
  
       
-- 11-22
SELECT employee_id, emp_name, dept_name, salary,
       SUM(salary) OVER ( PARTITION BY dept_name
                          ORDER BY salary DESC
                          ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
                        ) rows_value,
       SUM(salary) OVER ( PARTITION BY dept_name
                          ORDER BY salary DESC
                          RANGE BETWEEN 1000 PRECEDING AND 1000 FOLLOWING
                        ) range_value
  FROM emp_hierarchy 
 WHERE DEPT_NAME IN ('IT', 'Finance')
 ORDER BY 3, 4 DESC;
       
-- 11-23
SELECT employee_id, emp_name, dept_name, salary,
       FIRST_VALUE(salary) OVER ( PARTITION BY dept_name
                                  ORDER BY salary DESC
                                  ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
                                ) firstvalue,
       LAST_VALUE(salary) OVER ( PARTITION BY dept_name
                                 ORDER BY salary DESC
                                 ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
                               ) lastvalue
  FROM emp_hierarchy 
 WHERE DEPT_NAME IN ('IT', 'Finance')
 ORDER BY 3, 4 DESC;
       
       
-- 11-24
-- FIRST_VALUE() : 지정된 범위에서 첫 번째 로우의 값
-- LAST_VALUE() : 지정된 범위에서 마지막 로우의 값
SELECT employee_id, emp_name, dept_name, salary,
       FIRST_VALUE(salary) OVER ( PARTITION BY dept_name
                                  ORDER BY salary DESC
                                  RANGE BETWEEN 1000 PRECEDING AND 1000 FOLLOWING
                                ) firstvalue,
       LAST_VALUE(salary) OVER ( PARTITION BY dept_name
                                 ORDER BY salary DESC
                                 RANGE BETWEEN 1000 PRECEDING AND 1000 FOLLOWING
                               ) lastvalue
  FROM emp_hierarchy 
 WHERE DEPT_NAME IN ('IT', 'Finance')
 ORDER BY 3, 4 DESC;
       
-- 11-25
-- NTH_VALUE() : 지정된 범위에서 N번째 로우의 값
SELECT employee_id, emp_name, dept_name, salary,
       NTH_VALUE(salary, 2) OVER ( PARTITION BY dept_name
                                   ORDER BY salary DESC
                                   ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
                                 ) rows_value,
       NTH_VALUE(salary, 3) OVER ( PARTITION BY dept_name
                                   ORDER BY salary DESC
                                   RANGE BETWEEN 1000 PRECEDING AND 1000 FOLLOWING
                                 ) range_value
  FROM emp_hierarchy 
 WHERE DEPT_NAME IN ('IT', 'Finance')
 ORDER BY 3, 4 DESC;
        
       
-- 11-26
-- 윈도우 별칭 사용하기
SELECT employee_id, emp_name, dept_name, salary,
       FIRST_VALUE(salary) OVER wa firstvalue,
       LAST_VALUE(salary)  OVER wa lastvalue
  FROM emp_hierarchy 
 WHERE DEPT_NAME IN ('IT', 'Finance')
 WINDOW wa AS ( PARTITION BY dept_name
                ORDER BY salary DESC
                ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
              )
 ORDER BY 3, 4 DESC;
               
       
-- 11-27
SELECT * 
  FROM dept_emp
 WHERE SYSDATE() BETWEEN from_date AND to_date;
       
-- 11-28
-- 뷰 생성, 사용
-- 데이터를 저장하지 않고 SELECT 문을 저장
-- 명령어를 하나의 변수로 저장한다고 생각하면 됨. 
-- CREATE [OR REPLACE] VIEW 뷰명 AS
CREATE OR REPLACE VIEW dept_emp_v AS 
SELECT emp_no, dept_no 
  FROM dept_emp
 WHERE SYSDATE() BETWEEN from_date AND to_date;
 
SELECT *
  FROM dept_emp_v; 
       
-- 11-29
CREATE OR REPLACE VIEW dept_sal_v AS 
WITH tmp AS  
( SELECT a.dept_no, a.dept_name,
         COUNT(*) cnt, SUM(c.salary) salary
    FROM departments a, 
         dept_emp_v b, 
         salaries c
   WHERE a.dept_no = b.dept_no
     AND b.emp_no  = c.emp_no
     AND SYSDATE() BETWEEN c.from_date AND c.to_date
   GROUP BY a.dept_no, a.dept_name ),
dept_avg AS 
( SELECT AVG(salary) avg_sal 
    FROM tmp )        
SELECT dept_no, dept_name, SALARY, avg_sal
  FROM tmp, 
       dept_avg;
       
SELECT *
  FROM dept_sal_v;       
       
       
-- 11-30
-- 뷰 수정
-- ALTER VIEW 뷰명 AS
-- CREATE OR REPLACE VIEW 뷰명 AS
ALTER VIEW dept_emp_v AS 
SELECT emp_no, dept_no, from_date
  FROM dept_emp
 WHERE SYSDATE() BETWEEN from_date AND to_date;
 
SELECT *
  FROM dept_emp_v; 
       
       
-- 11-31
CREATE OR REPLACE VIEW dept_emp_v AS 
SELECT emp_no, dept_no, from_date, to_date
  FROM dept_emp
 WHERE SYSDATE() BETWEEN from_date AND to_date;
 
SELECT *
  FROM dept_emp_v; 
       
       
-- 11-32
-- 뷰 삭제
-- DROP VIEW 뷰명
DROP VIEW dept_emp_v;

-- 하나의 VIEW에 의해 생성된 또 다른 VIEW도 불러올 수 없음. 
SELECT *
  FROM dept_sal_v;



-- 1분 퀴즈 1
WITH RECURSIVE cte AS
(
  SELECT '2021-01-01' dates
  UNION ALL
  SELECT ADDDATE(dates, 1)
    FROM cte 
   WHERE dates < '2021-12-31'
)
SELECT * FROM cte;


-- 1분 퀴즈 2
USE mywork;

SELECT ranks, movie_name, sale_amt,
       SUM(sale_amt) OVER () sum_amt,
       CUME_DIST() OVER ( ORDER BY sale_amt DESC) dist_amt
  FROM box_office
 WHERE YEAR(release_date) = 2019
   AND ranks <= 10
 ORDER BY ranks;


-- 1분 퀴즈 3
CREATE OR REPLACE VIEW dept_emp_info_v AS
SELECT a.dept_name, b.emp_no, c.first_name, c.last_name
  FROM departments a,
       dept_emp b,
       employees c
 WHERE a.dept_no = b.dept_no
   AND SYSDATE() BETWEEN b.from_date AND b.to_date
   AND b.emp_no = c.emp_no;
 



-- Self Check 1.
CREATE OR REPLACE VIEW dept_emp_sal_v AS
SELECT a.dept_name, b.emp_no, c.first_name, c.last_name, d.salary
  FROM departments a,
       dept_emp b,
       employees c,
       salaries d
 WHERE a.dept_no = b.dept_no
   AND SYSDATE() BETWEEN b.from_date AND b.to_date
   AND b.emp_no = c.emp_no
   AND c.emp_no = d.emp_no
   AND SYSDATE() BETWEEN d.from_date AND d.to_date;
 
 
-- Self Check 2.
WITH basis AS (
SELECT dept_name, emp_no, first_name, last_name, salary, 
       RANK() OVER (PARTITION BY dept_name 
                    ORDER BY salary DESC) ranks
  FROM dept_emp_sal_v )
SELECT *
  FROM basis
 WHERE ranks <= 3
 ORDER BY 1, 6 ;
 

-- Self Check 3.
WITH basis AS (
SELECT dept_name, emp_no, first_name, last_name, salary, 
       RANK() OVER (PARTITION BY dept_name 
                    ORDER BY salary DESC) ranks
  FROM dept_emp_sal_v )
,top10 AS (
SELECT *
  FROM basis
 WHERE ranks <= 10)
SELECT dept_name, emp_no, first_name, last_name, salary, 
       NTILE(3) OVER ( PARTITION BY dept_name 
                           ORDER BY salary DESC ) grade
  FROM top10
 ORDER BY 1, 6 ;
 
-- Self Check 4 
WITH basis AS (
SELECT MONTH(release_date) months, SUM(sale_amt) tot_amt
  FROM box_office
 WHERE YEAR(RELEASE_DATE) = 2019
 GROUP BY 1
),
finals AS (
SELECT months, tot_amt,
       LAG(tot_amt) OVER (ORDER BY months) pre_month_amt
  FROM basis
)
SELECT months, tot_amt, 
       ROUND((tot_amt - pre_month_amt) / pre_month_amt * 100, 2) rates
  FROM finals  
 ORDER BY 1;
 
