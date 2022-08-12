-- 8-1
-- JOIN
-- 조인하는 테이블에는 같은 값을 가진 컬럼이 있어야 함
-- 2개 이상의 테이블을 조인할 수 있음
-- 조인 시 조인 조건(ON)이 필요함
USE world;

-- 조인하는 테이블에서 조인 칼럼의 값이 같은 것을 조회함.
SELECT a.id, a.name, a.countrycode, b.code, b.name country_name, 
       a.district, a.population
  FROM city a
 INNER JOIN country b -- 기본값 INNER. 즉, 생략이 가능함
    ON a.countrycode = b.code
 ORDER BY 1  ;


-- 8-2
SELECT b.name country_name, a.language, a.isofficial, a.percentage
  FROM countrylanguage a
 INNER JOIN country b
    ON a.countrycode = b.code
 ORDER BY 1;


-- 8-3
SELECT b.name country_name, a.language, a.isofficial, a.percentage
  FROM countrylanguage a
 INNER JOIN country b
    ON a.countrycode = b.code
 WHERE a.countrycode = 'KOR'   
 ORDER BY 1;
 

-- 8-4
-- 조인 순서를 바꾸더라도 결과는 동일하게 나옴.
SELECT a.code, a.name, a.continent, a.region, a.population, b.language
  FROM country a
 INNER JOIN countrylanguage b
    ON a.code = b.countrycode 
 WHERE a.code = 'KOR'
 ORDER BY 1;
 

-- 8-5
-- 총 3개의 테이블을 조인함.
SELECT a.code, a.name, a.continent, a.region, a.population, b.language,
       c.name, c.district, c.population
  FROM country a
 INNER JOIN countrylanguage b
    ON a.code = b.countrycode 
 INNER JOIN city c
    ON a.code = c.countrycode
 WHERE a.code = 'KOR'
 ORDER BY 1;
 
 
-- 8-6
-- 서로 다른 테이블에 동일한 컬럼명이 있을 경우, 이를 제대로 명시해줘야 함
SELECT a.code, a.name, a.continent, a.region, a.population, b.language,
       name, c.district, c.population
  FROM country a
 INNER JOIN countrylanguage b
    ON a.code = b.countrycode 
 INNER JOIN city c
    ON a.code = c.countrycode
 WHERE a.code = 'KOR'
 ORDER BY 1;
 

-- 8-7
-- FROM과 WHERE 절만으로도 INNER JOIN과 동일한 효과를 나타낼 수 있음
SELECT b.name country_name, a.language, a.isofficial, a.percentage
  FROM countrylanguage a,
       country b
 WHERE a.countrycode = b.code
   AND a.countrycode = 'KOR'   
 ORDER BY 1;
 

-- 8-8
-- 총 3개의 테이블을 FROM, WHERE 만으로 조인함
SELECT a.code, a.name, a.continent, a.region, a.population, b.language,
       c.name, c.district, c.population
  FROM country a,
       countrylanguage b,
       city c
 WHERE a.code = b.countrycode 
   AND a.code = c.countrycode
   AND a.code = 'KOR'
 ORDER BY 1;
 

-- 8-9
SELECT a.continent, COUNT(*)
  FROM country a  
 GROUP BY a.continent;
 
       
-- 8-10
SELECT a.continent, COUNT(*)
  FROM country a  
 INNER JOIN city b
    ON a.code = b.countrycode
 GROUP BY a.continent ;
 

-- 8-11
-- LEFT 조인, [OUTER]는 생략 가능
-- 조인 칼럼의 값이 같이 않은 것도 함께 조회를 함.
SELECT a.continent, COUNT(*)
  FROM country a  
  LEFT OUTER JOIN city b
    ON a.code = b.countrycode
 GROUP BY a.continent ;
 
 
-- 8-12
SELECT a.continent, COUNT(*) 전체건수, COUNT(b.name) 도시건수 
  FROM country a  
  LEFT OUTER JOIN city b
    ON a.code = b.countrycode
 GROUP BY a.continent ; 
 


-- 8-13
-- RIGHT 조인
-- iNNER 조인과는 다르게 LEFT, RIGHT는 테이블의 순서에 따라서 결과가 다르게 나올 수 있음
SELECT a.continent, COUNT(*) 전체건수, COUNT(b.name) 도시건수 
  FROM country a  
 RIGHT OUTER JOIN city b
    ON a.code = b.countrycode
 GROUP BY a.continent ;
 

-- 8-14
SELECT a.continent, COUNT(*) 전체건수, COUNT(b.name) 도시건수 
  FROM city b
 RIGHT OUTER JOIN country a  
    ON a.code = b.countrycode
 GROUP BY a.continent ;
 

-- 8-15
-- 자연 조인
-- 조인 조건을 기술하지 않는 것이 특징 (단, 두 테이블의 조인 컬럼명과 데이터 타입이 같아야 함)
SELECT a.continent, COUNT(*) 전체건수, COUNT(b.name) 도시건수 
  FROM country a  
NATURAL JOIN city b
 GROUP BY a.continent ;
 

-- 8-16
SELECT *
  FROM city a
NATURAL JOIN countrylanguage b ;

       
-- 8-17
-- 카티전 곱 : 조인 조건 자체가 없는 조인
-- 조인 조건을 기술하지 않거나 CROSS JOIN 구문 사용
-- 카티전 곱을 사용하면 두 테이블의 모든 조합들이 생성되는 것을 볼 수 있음. 
SELECT a.continent, COUNT(*) 전체건수, COUNT(b.name) 도시건수 
  FROM country a  
 INNER JOIN city b
 GROUP BY a.continent ;
 
       
-- 8-18
USE mywork;

CREATE TABLE tbl1 ( col1 INT, col2 VARCHAR(20));

CREATE TABLE tbl2 ( col1 INT, col2 VARCHAR(20));

INSERT INTO tbl1 VALUES (1,'가'),(2,'나'),(3,'다');

INSERT INTO tbl2 VALUES (1,'A'),(2,'B');

SELECT * FROM tbl1;

SELECT * FROM tbl2;
       
       
-- 8-19
-- UNION : 조인 없이 한 문장으로 두 개 이상의 테이블에서 데이터를 조회함.
-- UNION DISTINCT : 결과 집합에서 중복을 제거함. [DISTINCT]는 생략 가능
-- UNION ALL : 결과 집합에서 중복을 포함한 모든 데이터를 조회함.
SELECT col1
  FROM tbl1
 UNION 
SELECT col1
  FROM tbl2;
       
       
-- 8-20
-- 두 컬럼을 기준으로 보면 중복이 발생하지 않아서 모든 데이터가 조회됨
SELECT col1, col2
  FROM tbl1
 UNION 
SELECT col1, col2
  FROM tbl2;
       
       
-- 8-21
-- 각 SELECT 절의 칼럼 개수, 데이터 형은 일치해야 함. 아래 예시는 오류가 남
SELECT col1, col2
  FROM tbl1
 UNION 
SELECT col1
  FROM tbl2;
       
-- 8-22
SELECT col1
  FROM tbl1
 UNION ALL
SELECT col1
  FROM tbl2;
       
       
-- 8-23
-- UNION절에서 ORDER BY는 맨 끝에만 사용 가능. 아래 예시는 오류가 남
SELECT col1, col2
  FROM tbl1
 ORDER BY 1 DESC
 UNION 
SELECT col1, col2
  FROM tbl2;
       
       
-- 8-24
-- ( ) 로 묶은 경우에는 ORDER BY 오류가 나지 않음.
-- 그러나 ORDER BY 가 제대로 작동하지가 않음. 결과값은 출력되나 정렬은 안됨.
( SELECT col1, col2 FROM tbl1 ORDER BY 1 DESC )
 UNION 
SELECT col1, col2
  FROM tbl2;
       

-- 8-25
-- 정렬을 하고 싶다면 LIMIT를 추가로 적어줘야 함.
( SELECT col1, col2 FROM tbl1 ORDER BY 1 DESC LIMIT 3)
 UNION 
SELECT col1, col2
  FROM tbl2;
 
 
 
-- 8-26
USE mywork;

SELECT * 
FROM employees;

SELECT * 
FROM departments;

SELECT * 
FROM dept_emp;

-- 사원의 사번, 이름, 부서명 조회하기
SELECT a.emp_no, CONCAT(a.first_name, ' ', a.last_name) emp_name,
       c.dept_name
  FROM employees a
 INNER JOIN dept_emp b
    ON a.emp_no = b.emp_no
 INNER JOIN departments c
    ON b.dept_no = c.dept_no
 ORDER BY a.emp_no;


-- 8-27
SELECT * 
FROM dept_manager;

-- Marketing과 Finance 부서의 현재 관리자 정보 조회하기
SELECT b.dept_name, a.emp_no, CONCAT(c.first_name, ' ', c.last_name) emp_name
      ,a.from_date ,a.to_date
  FROM dept_manager a
 INNER JOIN departments b
    ON a.dept_no = b.dept_no
 INNER JOIN employees c
    ON a.emp_no = c.emp_no
 WHERE b.dept_name IN ('Marketing','Finance')
   AND SYSDATE() BETWEEN a.from_date AND a.to_date;
   
   
-- 8-28
-- 모든 부서의 이름과 현재 관리자의 사번 조회하기
-- 부서에 해당하는 이가 없더라도 모든 부서 정보를 가져오기 위해 RIGHT를 씀.
-- 또한 IT부서의 경우 해당하는 정보가 없기에 WHERE 절에서 걸러질 위험이 있으니 IFNULL을 사용함.
SELECT b.dept_name, a.emp_no, a.from_date ,a.to_date
  FROM dept_manager a
 RIGHT JOIN departments b
    ON a.dept_no = b.dept_no
 WHERE SYSDATE() BETWEEN IFNULL(a.from_date,SYSDATE())
                     AND IFNULL(a.to_date,  SYSDATE());  
                     
                     
-- 8-29
-- 부서별 사원 수와 전체 부서의 총 사원 수 구하기
-- 두 개의 SELECT 결과값을 UNION으로 합침.
SELECT a.dept_name, count(*)
  FROM departments a
 INNER JOIN dept_emp b
    ON a.dept_no = b.dept_no
 WHERE  SYSDATE() BETWEEN b.from_date AND b.to_date
 GROUP BY a.dept_name
 UNION 
SELECT '전체', COUNT(*)
  FROM dept_emp
 WHERE SYSDATE() BETWEEN from_date AND to_date;
 
 -- 다른 방식으로 표현한다면 아래처럼 쓸 수 있음.
 SELECT a.dept_name, count(*)
  FROM departments a
 INNER JOIN dept_emp b
    ON a.dept_no = b.dept_no
 WHERE  SYSDATE() BETWEEN b.from_date AND b.to_date
 GROUP BY a.dept_name WITH ROLLUP
 
 
 
-- Self Check 


-- 1분 퀴즈 2
USE world;

SELECT a.name, COUNT(*)
  FROM country a
 INNER JOIN city b
    ON a.code = b.countrycode    
GROUP BY a.name WITH ROLLUP ;

-- 1분 퀴즈 3
SELECT a.name, COUNT(b.language)
  FROM country a
  LEFT JOIN countrylanguage b
    ON a.code = b.countrycode
 WHERE a.continent = 'Africa'
 GROUP BY a.name
 HAVING COUNT(b.language) = 0;
 

-- 1분 퀴즈 4
SELECT a.continent, COUNT(*) 전체건수, COUNT(b.name) 도시건수 
  FROM country a  
 CROSS JOIN city b
 GROUP BY a.continent ;
 
 
-- 1분 퀴즈 5
USE mywork;

SELECT * FROM tbl1
 UNION ALL
SELECT * FROM tbl2
 WHERE col1 = 1;

 
  


-- Self Check1
USE mywork;

SELECT a.emp_no, CONCAT(a.first_name, ' ', a.last_name) emp_name,
       c.dept_name
  FROM employees a,
       dept_emp b,
       departments c
 WHERE a.emp_no = b.emp_no
   AND b.dept_no = c.dept_no
 ORDER BY a.emp_no;



-- Self Check2
SELECT b.dept_name, a.emp_no, CONCAT(c.first_name, ' ', c.last_name) emp_name,
       a.from_date ,a.to_date
  FROM dept_manager a
 RIGHT JOIN departments b
    ON a.dept_no = b.dept_no
 LEFT JOIN employees c
    ON a.emp_no = c.emp_no
 WHERE SYSDATE() BETWEEN IFNULL(a.from_date,SYSDATE())
                     AND IFNULL(a.to_date,  SYSDATE());


-- Self Check3
SELECT a.emp_no, a.first_name, a.last_name,  a.birth_date, c.dept_name
  FROM employees a
NATURAL JOIN dept_emp b
NATURAL JOIN departments c 
 WHERE EXTRACT(YEAR_MONTH FROM a.birth_date) >= '196502';
 
   
-- Self Check4
SELECT '관리자' gubun, a.emp_no, b.salary
  FROM dept_manager a
 INNER JOIN salaries b
    ON a.emp_no = b.emp_no
 WHERE a.dept_no = 'd007'
   AND SYSDATE() BETWEEN a.from_date AND a.to_date
   AND SYSDATE() BETWEEN b.from_date AND b.to_date
UNION ALL
SELECT '사원', a.emp_no, b.salary
  FROM dept_emp a
 INNER JOIN salaries b
    ON a.emp_no = b.emp_no
 WHERE a.dept_no = 'd007'
   AND SYSDATE() BETWEEN a.from_date AND a.to_date
   AND SYSDATE() BETWEEN b.from_date AND b.to_date;
   
   
